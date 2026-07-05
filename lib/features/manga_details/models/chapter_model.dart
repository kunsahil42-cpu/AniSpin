class ChapterModel {
  final int number;
  final String title;
  final String scanGroup;
  final String date;
  final String language;
  final List<String> pages;

  ChapterModel({
    required this.number,
    required this.title,
    required this.scanGroup,
    required this.date,
    required this.language,
    required this.pages,
  });

  factory ChapterModel.mock(int mangaId, int chapterNumber) {
    // Generate mock manga page URLs
    // Stable high-quality public sample illustrations
    final pageUrls = List.generate(12, (index) {
      final id = (mangaId + chapterNumber + index) % 10 + 1;
      return 'https://picsum.photos/id/${10 + id * 5}/800/1200';
    });

    return ChapterModel(
      number: chapterNumber,
      title: 'Chapter $chapterNumber: An Unexpected Journey',
      scanGroup: 'Aurora Scanlations',
      date: 'July ${2 + chapterNumber}, 2026',
      language: 'EN',
      pages: pageUrls,
    );
  }
}
