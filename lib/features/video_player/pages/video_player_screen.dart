import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:go_router/go_router.dart';
import '../../tracker/models/watch_progress.dart';
import '../../tracker/providers/tracker_providers.dart';
import '../../anime_details/models/episode_model.dart';

class VideoPlayerScreen extends ConsumerStatefulWidget {
  final int animeId;
  final int episodeNumber;
  
  // Passed details via GoRouter extra
  final String romajiTitle;
  final String? englishTitle;
  final String coverImage;
  final String bannerImage;
  final int totalEpisodes;

  const VideoPlayerScreen({
    super.key,
    required this.animeId,
    required this.episodeNumber,
    required this.romajiTitle,
    this.englishTitle,
    required this.coverImage,
    required this.bannerImage,
    required this.totalEpisodes,
  });

  @override
  ConsumerState<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends ConsumerState<VideoPlayerScreen> {
  VideoPlayerController? _controller;
  bool _initialized = false;
  bool _showControls = true;
  bool _locked = false;
  bool _isPipActive = false;
  
  // Custom gesture overlays
  double _volume = 0.7; // Range: 0.0 to 1.0
  double _brightness = 0.5; // Range: 0.0 to 1.0
  bool _showVolumeIndicator = false;
  bool _showBrightnessIndicator = false;
  Timer? _indicatorTimer;

  // Selected tracks
  String _activeAudio = 'Sub';
  String _activeServer = 'Server 1 (HLS)';
  String _activeSubtitle = 'English';
  double _playbackSpeed = 1.0;

  Timer? _controlsTimer;
  EpisodeModel? _episode;
  
  // Auto next countdown
  bool _showCountdown = false;
  int _countdownSeconds = 5;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _episode = EpisodeModel.mock(widget.animeId, widget.episodeNumber);
    _initializePlayer();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  Future<void> _initializePlayer() async {
    setState(() {
      _initialized = false;
    });

    final streamUrl = _episode?.servers[_activeAudio]?[_activeServer] ?? '';
    
    // Dispose previous controller if any
    if (_controller != null) {
      await _controller!.dispose();
    }

    _controller = VideoPlayerController.networkUrl(Uri.parse(streamUrl));
    
    try {
      await _controller!.initialize();
      _controller!.addListener(_videoListener);
      
      // Load saved progress from Isar if exists
      final repo = ref.read(watchProgressRepositoryProvider);
      final savedProgress = await repo.getProgress(widget.animeId);
      if (savedProgress != null && savedProgress.lastWatchedEpisode == widget.episodeNumber) {
        await _controller!.seekTo(Duration(milliseconds: savedProgress.lastWatchedPosition));
      }
      
      await _controller!.play();
      setState(() {
        _initialized = true;
      });
      _startControlsTimer();
    } catch (e) {
      debugPrint('Error initializing video player: $e');
    }
  }

  void _videoListener() {
    if (_controller == null) return;

    // Trigger Watch Progress Save
    final currentPos = _controller!.value.position.inMilliseconds;
    final totalDur = _controller!.value.duration.inMilliseconds;
    if (totalDur > 0) {
      final percentage = currentPos / totalDur;
      _saveWatchProgress(currentPos, totalDur, percentage);

      // Check if video is finished -> trigger Auto Next countdown
      if (_controller!.value.position >= _controller!.value.duration && !_showCountdown) {
        _triggerAutoNext();
      }
    }
  }

  void _saveWatchProgress(int position, int duration, double percentage) {
    final repo = ref.read(watchProgressRepositoryProvider);
    
    final progress = WatchProgress()
      ..animeId = widget.animeId
      ..romajiTitle = widget.romajiTitle
      ..englishTitle = widget.englishTitle
      ..coverImage = widget.coverImage
      ..bannerImage = widget.bannerImage
      ..totalEpisodes = widget.totalEpisodes
      ..lastWatchedEpisode = widget.episodeNumber
      ..lastWatchedPosition = position
      ..lastWatchedDuration = duration
      ..watchPercentage = percentage
      ..lastWatchedSource = _activeServer
      ..lastWatchedAudio = _activeAudio
      ..lastWatchedAt = DateTime.now();

    // Mark as completed if watched more than 90%
    if (percentage > 0.90) {
      final completed = List<int>.from(progress.completedEpisodes);
      if (!completed.contains(widget.episodeNumber)) {
        completed.add(widget.episodeNumber);
        progress.completedEpisodes = completed;
      }
    }

    repo.saveProgress(progress).then((_) {
      // Invalidate provider to update UI
      ref.invalidate(animeProgressProvider(widget.animeId));
      ref.invalidate(continueWatchingProvider);
    });
  }

  void _triggerAutoNext() {
    if (widget.episodeNumber >= widget.totalEpisodes) return;
    
    setState(() {
      _showCountdown = true;
      _countdownSeconds = 5;
    });

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdownSeconds > 1) {
          _countdownSeconds--;
        } else {
          timer.cancel();
          _playNextEpisode();
        }
      });
    });
  }

  void _playNextEpisode() {
    _countdownTimer?.cancel();
    if (widget.episodeNumber < widget.totalEpisodes) {
      context.pushReplacement(
        '/anime/${widget.animeId}/play/${widget.episodeNumber + 1}',
        extra: {
          'romajiTitle': widget.romajiTitle,
          'englishTitle': widget.englishTitle,
          'coverImage': widget.coverImage,
          'bannerImage': widget.bannerImage,
          'totalEpisodes': widget.totalEpisodes,
        },
      );
    }
  }

  void _cancelCountdown() {
    _countdownTimer?.cancel();
    setState(() {
      _showCountdown = false;
    });
  }

  void _startControlsTimer() {
    _controlsTimer?.cancel();
    _controlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && !_locked) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
      if (_showControls) {
        _startControlsTimer();
      }
    });
  }

  // Swipe gesture volume/brightness modifiers
  void _handleVerticalDragUpdate(double delta, double screenWidth, double localX) {
    if (_locked) return;
    
    // Left side: Brightness, Right side: Volume
    final isLeft = localX < screenWidth / 2;
    setState(() {
      if (isLeft) {
        _brightness = (_brightness - delta / 200).clamp(0.0, 1.0);
        _showBrightnessIndicator = true;
        _showVolumeIndicator = false;
      } else {
        _volume = (_volume - delta / 200).clamp(0.0, 1.0);
        _showVolumeIndicator = true;
        _showBrightnessIndicator = false;
        _controller?.setVolume(_volume);
      }
    });

    _indicatorTimer?.cancel();
    _indicatorTimer = Timer(const Duration(seconds: 2), () {
      setState(() {
        _showVolumeIndicator = false;
        _showBrightnessIndicator = false;
      });
    });
  }

  @override
  void dispose() {
    _controlsTimer?.cancel();
    _countdownTimer?.cancel();
    _indicatorTimer?.cancel();
    _controller?.removeListener(_videoListener);
    _controller?.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleControls,
        onVerticalDragUpdate: (details) {
          _handleVerticalDragUpdate(details.delta.dy, size.width, details.localPosition.dx);
        },
        child: Stack(
          children: [
            // Video display
            Center(
              child: _initialized && _controller != null
                  ? AspectRatio(
                      aspectRatio: _controller!.value.aspectRatio,
                      child: VideoPlayer(_controller!),
                    )
                  : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Color(0xFF7C4DFF)),
                        SizedBox(height: 16),
                        Text('Preparing stream...', style: TextStyle(color: Colors.white70)),
                      ],
                    ),
            ),

            // Top Gradient overlay
            if (_showControls)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 90,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xD9000000), Colors.transparent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),

            // Bottom Gradient overlay
            if (_showControls && !_locked)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 90,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Color(0xD9000000)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),

            // Floating gesture level indicators
            if (_showVolumeIndicator)
              Center(
                child: Card(
                  color: const Color(0xD9000000),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.volume_up, color: Color(0xFF7C4DFF)),
                        const SizedBox(width: 8),
                        Text('Volume: ${(_volume * 100).toInt()}%', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),

            if (_showBrightnessIndicator)
              Center(
                child: Card(
                  color: const Color(0xD9000000),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.brightness_medium, color: Color(0xFF7C4DFF)),
                        const SizedBox(width: 8),
                        Text('Brightness: ${(_brightness * 100).toInt()}%', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),

            // Overlays & HUD
            if (_showControls) ...[
              // Header Controls
              if (!_locked)
                Positioned(
                  top: 20,
                  left: 20,
                  right: 20,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => context.pop(),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.romajiTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Episode ${widget.episodeNumber} / ${widget.totalEpisodes}',
                              style: const TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      // PiP / Chromecast Mock icons
                      IconButton(
                        icon: Icon(_isPipActive ? Icons.picture_in_picture_alt : Icons.picture_in_picture, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            _isPipActive = !_isPipActive;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(_isPipActive ? 'PiP Mode Activated' : 'PiP Mode Deactivated')),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.cast, color: Colors.white),
                        onPressed: () => _showChromecastDialog(),
                      ),
                    ],
                  ),
                ),

              // Lockdown lock button
              Positioned(
                left: 20,
                top: size.height / 2 - 20,
                child: IconButton(
                  icon: Icon(_locked ? Icons.lock : Icons.lock_open, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _locked = !_locked;
                      _showControls = true;
                    });
                    _startControlsTimer();
                  },
                ),
              ),

              // Central controllers (Play/Pause, Seek forward, rewind)
              if (!_locked)
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        iconSize: 42,
                        icon: const Icon(Icons.replay_10_rounded, color: Colors.white),
                        onPressed: () {
                          if (_controller == null) return;
                          final newPos = _controller!.value.position - const Duration(seconds: 10);
                          _controller!.seekTo(newPos);
                          _startControlsTimer();
                        },
                      ),
                      IconButton(
                        iconSize: 64,
                        icon: Icon(
                          _controller?.value.isPlaying == true ? Icons.pause_circle_filled : Icons.play_circle_filled,
                          color: const Color(0xFF7C4DFF),
                        ),
                        onPressed: () {
                          if (_controller == null) return;
                          setState(() {
                            if (_controller!.value.isPlaying) {
                              _controller!.pause();
                            } else {
                              _controller!.play();
                            }
                          });
                          _startControlsTimer();
                        },
                      ),
                      IconButton(
                        iconSize: 42,
                        icon: const Icon(Icons.forward_10_rounded, color: Colors.white),
                        onPressed: () {
                          if (_controller == null) return;
                          final newPos = _controller!.value.position + const Duration(seconds: 10);
                          _controller!.seekTo(newPos);
                          _startControlsTimer();
                        },
                      ),
                    ],
                  ),
                ),

              // Bottom status bar / seeker
              if (!_locked)
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Column(
                    children: [
                      // Seeker Slider
                      if (_controller != null)
                        Row(
                          children: [
                            Text(
                              _formatDuration(_controller!.value.position),
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                            Expanded(
                              child: Slider(
                                activeColor: const Color(0xFF7C4DFF),
                                inactiveColor: Colors.white24,
                                value: _controller!.value.position.inMilliseconds.toDouble(),
                                min: 0.0,
                                max: _controller!.value.duration.inMilliseconds.toDouble(),
                                onChanged: (val) {
                                  _controller!.seekTo(Duration(milliseconds: val.toInt()));
                                  _startControlsTimer();
                                },
                              ),
                            ),
                            Text(
                              _formatDuration(_controller!.value.duration),
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      const SizedBox(height: 4),
                      // Quality / Sub-Dub selector bar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              TextButton.icon(
                                icon: const Icon(Icons.speed, color: Colors.white, size: 16),
                                label: Text('${_playbackSpeed}x', style: const TextStyle(color: Colors.white)),
                                onPressed: () => _showSpeedSelector(),
                              ),
                              const SizedBox(width: 16),
                              TextButton.icon(
                                icon: const Icon(Icons.settings, color: Colors.white, size: 16),
                                label: Text(_activeServer, style: const TextStyle(color: Colors.white)),
                                onPressed: () => _showServerSelector(),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              TextButton.icon(
                                icon: const Icon(Icons.subtitles, color: Colors.white, size: 16),
                                label: Text(_activeSubtitle, style: const TextStyle(color: Colors.white)),
                                onPressed: () => _showSubtitleSelector(),
                              ),
                              const SizedBox(width: 16),
                              TextButton.icon(
                                icon: const Icon(Icons.audiotrack, color: Colors.white, size: 16),
                                label: Text(_activeAudio, style: const TextStyle(color: Colors.white)),
                                onPressed: () => _showAudioSelector(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],

            // Auto next countdown overlay
            if (_showCountdown)
              Container(
                color: Colors.black87,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Up Next',
                        style: TextStyle(color: Colors.white70, fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Episode ${widget.episodeNumber + 1}',
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 24),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: CircularProgressIndicator(
                              value: _countdownSeconds / 5,
                              color: const Color(0xFF7C4DFF),
                              strokeWidth: 6,
                            ),
                          ),
                          Text(
                            '$_countdownSeconds',
                            style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                            onPressed: _cancelCountdown,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white30),
                            ),
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: _playNextEpisode,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF7C4DFF),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Skip'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  void _showSpeedSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView(
        shrinkWrap: true,
        children: [0.5, 0.75, 1.0, 1.25, 1.5, 2.0].map((speed) {
          return ListTile(
            title: Text('${speed}x'),
            trailing: _playbackSpeed == speed ? const Icon(Icons.check, color: Color(0xFF7C4DFF)) : null,
            onTap: () {
              setState(() {
                _playbackSpeed = speed;
                _controller?.setPlaybackSpeed(speed);
              });
              Navigator.pop(context);
            },
          );
        }).toList(),
      ),
    );
  }

  void _showServerSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final options = _episode?.servers[_activeAudio]?.keys.toList() ?? [];
        return ListView(
          shrinkWrap: true,
          children: options.map((server) {
            return ListTile(
              title: Text(server),
              trailing: _activeServer == server ? const Icon(Icons.check, color: Color(0xFF7C4DFF)) : null,
              onTap: () {
                setState(() {
                  _activeServer = server;
                });
                Navigator.pop(context);
                _initializePlayer();
              },
            );
          }).toList(),
        );
      },
    );
  }

  void _showAudioSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final options = _episode?.servers.keys.toList() ?? [];
        return ListView(
          shrinkWrap: true,
          children: options.map((audio) {
            return ListTile(
              title: Text(audio == 'Sub' ? '🇯🇵 Japanese (Sub)' : '🇺🇸 English (Dub)'),
              trailing: _activeAudio == audio ? const Icon(Icons.check, color: Color(0xFF7C4DFF)) : null,
              onTap: () {
                setState(() {
                  _activeAudio = audio;
                  // Auto pick first server of new audio option
                  final servers = _episode?.servers[audio]?.keys.toList() ?? [];
                  if (servers.isNotEmpty) {
                    _activeServer = servers.first;
                  }
                });
                Navigator.pop(context);
                _initializePlayer();
              },
            );
          }).toList(),
        );
      },
    );
  }

  void _showSubtitleSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final options = _episode?.subtitles ?? [];
        return ListView(
          shrinkWrap: true,
          children: options.map((sub) {
            return ListTile(
              title: Text(sub),
              trailing: _activeSubtitle == sub ? const Icon(Icons.check, color: Color(0xFF7C4DFF)) : null,
              onTap: () {
                setState(() {
                  _activeSubtitle = sub;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

  void _showChromecastDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.cast, color: Color(0xFF7C4DFF)),
            SizedBox(width: 10),
            Text('Connect to device'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.tv),
              title: const Text('Living Room TV'),
              subtitle: const Text('Chromecast Ultra'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Connected to Living Room TV')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.tv),
              title: const Text('Bedroom Shield TV'),
              subtitle: const Text('Android TV'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Connected to Bedroom Shield TV')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
