// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading_progress.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetReadingProgressCollection on Isar {
  IsarCollection<ReadingProgress> get readingProgress => this.collection();
}

const ReadingProgressSchema = CollectionSchema(
  name: r'ReadingProgress',
  id: -2251063111460261641,
  properties: {
    r'bannerImage': PropertySchema(
      id: 0,
      name: r'bannerImage',
      type: IsarType.string,
    ),
    r'completedChapters': PropertySchema(
      id: 1,
      name: r'completedChapters',
      type: IsarType.longList,
    ),
    r'coverImage': PropertySchema(
      id: 2,
      name: r'coverImage',
      type: IsarType.string,
    ),
    r'englishTitle': PropertySchema(
      id: 3,
      name: r'englishTitle',
      type: IsarType.string,
    ),
    r'lastReadAt': PropertySchema(
      id: 4,
      name: r'lastReadAt',
      type: IsarType.dateTime,
    ),
    r'lastReadChapter': PropertySchema(
      id: 5,
      name: r'lastReadChapter',
      type: IsarType.long,
    ),
    r'lastReadPage': PropertySchema(
      id: 6,
      name: r'lastReadPage',
      type: IsarType.long,
    ),
    r'mangaId': PropertySchema(
      id: 7,
      name: r'mangaId',
      type: IsarType.long,
    ),
    r'readingPercentage': PropertySchema(
      id: 8,
      name: r'readingPercentage',
      type: IsarType.double,
    ),
    r'romajiTitle': PropertySchema(
      id: 9,
      name: r'romajiTitle',
      type: IsarType.string,
    ),
    r'totalChapters': PropertySchema(
      id: 10,
      name: r'totalChapters',
      type: IsarType.long,
    )
  },
  estimateSize: _readingProgressEstimateSize,
  serialize: _readingProgressSerialize,
  deserialize: _readingProgressDeserialize,
  deserializeProp: _readingProgressDeserializeProp,
  idName: r'id',
  indexes: {
    r'mangaId': IndexSchema(
      id: 7466570075891278896,
      name: r'mangaId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'mangaId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _readingProgressGetId,
  getLinks: _readingProgressGetLinks,
  attach: _readingProgressAttach,
  version: '3.1.0+1',
);

int _readingProgressEstimateSize(
  ReadingProgress object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.bannerImage;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.completedChapters.length * 8;
  bytesCount += 3 + object.coverImage.length * 3;
  {
    final value = object.englishTitle;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.romajiTitle.length * 3;
  return bytesCount;
}

void _readingProgressSerialize(
  ReadingProgress object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.bannerImage);
  writer.writeLongList(offsets[1], object.completedChapters);
  writer.writeString(offsets[2], object.coverImage);
  writer.writeString(offsets[3], object.englishTitle);
  writer.writeDateTime(offsets[4], object.lastReadAt);
  writer.writeLong(offsets[5], object.lastReadChapter);
  writer.writeLong(offsets[6], object.lastReadPage);
  writer.writeLong(offsets[7], object.mangaId);
  writer.writeDouble(offsets[8], object.readingPercentage);
  writer.writeString(offsets[9], object.romajiTitle);
  writer.writeLong(offsets[10], object.totalChapters);
}

ReadingProgress _readingProgressDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ReadingProgress();
  object.bannerImage = reader.readStringOrNull(offsets[0]);
  object.completedChapters = reader.readLongList(offsets[1]) ?? [];
  object.coverImage = reader.readString(offsets[2]);
  object.englishTitle = reader.readStringOrNull(offsets[3]);
  object.id = id;
  object.lastReadAt = reader.readDateTime(offsets[4]);
  object.lastReadChapter = reader.readLong(offsets[5]);
  object.lastReadPage = reader.readLong(offsets[6]);
  object.mangaId = reader.readLong(offsets[7]);
  object.readingPercentage = reader.readDouble(offsets[8]);
  object.romajiTitle = reader.readString(offsets[9]);
  object.totalChapters = reader.readLongOrNull(offsets[10]);
  return object;
}

P _readingProgressDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readLongList(offset) ?? []) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readDouble(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _readingProgressGetId(ReadingProgress object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _readingProgressGetLinks(ReadingProgress object) {
  return [];
}

void _readingProgressAttach(
    IsarCollection<dynamic> col, Id id, ReadingProgress object) {
  object.id = id;
}

extension ReadingProgressByIndex on IsarCollection<ReadingProgress> {
  Future<ReadingProgress?> getByMangaId(int mangaId) {
    return getByIndex(r'mangaId', [mangaId]);
  }

  ReadingProgress? getByMangaIdSync(int mangaId) {
    return getByIndexSync(r'mangaId', [mangaId]);
  }

  Future<bool> deleteByMangaId(int mangaId) {
    return deleteByIndex(r'mangaId', [mangaId]);
  }

  bool deleteByMangaIdSync(int mangaId) {
    return deleteByIndexSync(r'mangaId', [mangaId]);
  }

  Future<List<ReadingProgress?>> getAllByMangaId(List<int> mangaIdValues) {
    final values = mangaIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'mangaId', values);
  }

  List<ReadingProgress?> getAllByMangaIdSync(List<int> mangaIdValues) {
    final values = mangaIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'mangaId', values);
  }

  Future<int> deleteAllByMangaId(List<int> mangaIdValues) {
    final values = mangaIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'mangaId', values);
  }

  int deleteAllByMangaIdSync(List<int> mangaIdValues) {
    final values = mangaIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'mangaId', values);
  }

  Future<Id> putByMangaId(ReadingProgress object) {
    return putByIndex(r'mangaId', object);
  }

  Id putByMangaIdSync(ReadingProgress object, {bool saveLinks = true}) {
    return putByIndexSync(r'mangaId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByMangaId(List<ReadingProgress> objects) {
    return putAllByIndex(r'mangaId', objects);
  }

  List<Id> putAllByMangaIdSync(List<ReadingProgress> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'mangaId', objects, saveLinks: saveLinks);
  }
}

extension ReadingProgressQueryWhereSort
    on QueryBuilder<ReadingProgress, ReadingProgress, QWhere> {
  QueryBuilder<ReadingProgress, ReadingProgress, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterWhere> anyMangaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'mangaId'),
      );
    });
  }
}

extension ReadingProgressQueryWhere
    on QueryBuilder<ReadingProgress, ReadingProgress, QWhereClause> {
  QueryBuilder<ReadingProgress, ReadingProgress, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterWhereClause>
      mangaIdEqualTo(int mangaId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'mangaId',
        value: [mangaId],
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterWhereClause>
      mangaIdNotEqualTo(int mangaId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mangaId',
              lower: [],
              upper: [mangaId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mangaId',
              lower: [mangaId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mangaId',
              lower: [mangaId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mangaId',
              lower: [],
              upper: [mangaId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterWhereClause>
      mangaIdGreaterThan(
    int mangaId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'mangaId',
        lower: [mangaId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterWhereClause>
      mangaIdLessThan(
    int mangaId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'mangaId',
        lower: [],
        upper: [mangaId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterWhereClause>
      mangaIdBetween(
    int lowerMangaId,
    int upperMangaId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'mangaId',
        lower: [lowerMangaId],
        includeLower: includeLower,
        upper: [upperMangaId],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ReadingProgressQueryFilter
    on QueryBuilder<ReadingProgress, ReadingProgress, QFilterCondition> {
  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      bannerImageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'bannerImage',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      bannerImageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'bannerImage',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      bannerImageEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bannerImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      bannerImageGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bannerImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      bannerImageLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bannerImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      bannerImageBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bannerImage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      bannerImageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'bannerImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      bannerImageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'bannerImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      bannerImageContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'bannerImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      bannerImageMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'bannerImage',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      bannerImageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bannerImage',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      bannerImageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'bannerImage',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      completedChaptersElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedChapters',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      completedChaptersElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completedChapters',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      completedChaptersElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completedChapters',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      completedChaptersElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completedChapters',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      completedChaptersLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedChapters',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      completedChaptersIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedChapters',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      completedChaptersIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedChapters',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      completedChaptersLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedChapters',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      completedChaptersLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedChapters',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      completedChaptersLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedChapters',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      coverImageEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'coverImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      coverImageGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'coverImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      coverImageLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'coverImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      coverImageBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'coverImage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      coverImageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'coverImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      coverImageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'coverImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      coverImageContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'coverImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      coverImageMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'coverImage',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      coverImageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'coverImage',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      coverImageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'coverImage',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      englishTitleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'englishTitle',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      englishTitleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'englishTitle',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      englishTitleEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'englishTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      englishTitleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'englishTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      englishTitleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'englishTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      englishTitleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'englishTitle',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      englishTitleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'englishTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      englishTitleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'englishTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      englishTitleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'englishTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      englishTitleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'englishTitle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      englishTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'englishTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      englishTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'englishTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      lastReadAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastReadAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      lastReadAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastReadAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      lastReadAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastReadAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      lastReadAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastReadAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      lastReadChapterEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastReadChapter',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      lastReadChapterGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastReadChapter',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      lastReadChapterLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastReadChapter',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      lastReadChapterBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastReadChapter',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      lastReadPageEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastReadPage',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      lastReadPageGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastReadPage',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      lastReadPageLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastReadPage',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      lastReadPageBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastReadPage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      mangaIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mangaId',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      mangaIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mangaId',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      mangaIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mangaId',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      mangaIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mangaId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      readingPercentageEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'readingPercentage',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      readingPercentageGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'readingPercentage',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      readingPercentageLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'readingPercentage',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      readingPercentageBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'readingPercentage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      romajiTitleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'romajiTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      romajiTitleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'romajiTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      romajiTitleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'romajiTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      romajiTitleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'romajiTitle',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      romajiTitleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'romajiTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      romajiTitleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'romajiTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      romajiTitleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'romajiTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      romajiTitleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'romajiTitle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      romajiTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'romajiTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      romajiTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'romajiTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      totalChaptersIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'totalChapters',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      totalChaptersIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'totalChapters',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      totalChaptersEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalChapters',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      totalChaptersGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalChapters',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      totalChaptersLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalChapters',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      totalChaptersBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalChapters',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ReadingProgressQueryObject
    on QueryBuilder<ReadingProgress, ReadingProgress, QFilterCondition> {}

extension ReadingProgressQueryLinks
    on QueryBuilder<ReadingProgress, ReadingProgress, QFilterCondition> {}

extension ReadingProgressQuerySortBy
    on QueryBuilder<ReadingProgress, ReadingProgress, QSortBy> {
  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByBannerImage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bannerImage', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByBannerImageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bannerImage', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByCoverImage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverImage', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByCoverImageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverImage', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByEnglishTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'englishTitle', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByEnglishTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'englishTitle', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByLastReadAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadAt', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByLastReadAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadAt', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByLastReadChapter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadChapter', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByLastReadChapterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadChapter', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByLastReadPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadPage', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByLastReadPageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadPage', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy> sortByMangaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaId', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByMangaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaId', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByReadingPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readingPercentage', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByReadingPercentageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readingPercentage', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByRomajiTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'romajiTitle', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByRomajiTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'romajiTitle', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByTotalChapters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalChapters', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByTotalChaptersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalChapters', Sort.desc);
    });
  }
}

extension ReadingProgressQuerySortThenBy
    on QueryBuilder<ReadingProgress, ReadingProgress, QSortThenBy> {
  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByBannerImage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bannerImage', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByBannerImageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bannerImage', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByCoverImage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverImage', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByCoverImageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverImage', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByEnglishTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'englishTitle', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByEnglishTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'englishTitle', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByLastReadAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadAt', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByLastReadAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadAt', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByLastReadChapter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadChapter', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByLastReadChapterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadChapter', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByLastReadPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadPage', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByLastReadPageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadPage', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy> thenByMangaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaId', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByMangaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaId', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByReadingPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readingPercentage', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByReadingPercentageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readingPercentage', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByRomajiTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'romajiTitle', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByRomajiTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'romajiTitle', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByTotalChapters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalChapters', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByTotalChaptersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalChapters', Sort.desc);
    });
  }
}

extension ReadingProgressQueryWhereDistinct
    on QueryBuilder<ReadingProgress, ReadingProgress, QDistinct> {
  QueryBuilder<ReadingProgress, ReadingProgress, QDistinct>
      distinctByBannerImage({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bannerImage', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QDistinct>
      distinctByCompletedChapters() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedChapters');
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QDistinct>
      distinctByCoverImage({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'coverImage', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QDistinct>
      distinctByEnglishTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'englishTitle', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QDistinct>
      distinctByLastReadAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastReadAt');
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QDistinct>
      distinctByLastReadChapter() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastReadChapter');
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QDistinct>
      distinctByLastReadPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastReadPage');
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QDistinct>
      distinctByMangaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mangaId');
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QDistinct>
      distinctByReadingPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'readingPercentage');
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QDistinct>
      distinctByRomajiTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'romajiTitle', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QDistinct>
      distinctByTotalChapters() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalChapters');
    });
  }
}

extension ReadingProgressQueryProperty
    on QueryBuilder<ReadingProgress, ReadingProgress, QQueryProperty> {
  QueryBuilder<ReadingProgress, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ReadingProgress, String?, QQueryOperations>
      bannerImageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bannerImage');
    });
  }

  QueryBuilder<ReadingProgress, List<int>, QQueryOperations>
      completedChaptersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedChapters');
    });
  }

  QueryBuilder<ReadingProgress, String, QQueryOperations> coverImageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'coverImage');
    });
  }

  QueryBuilder<ReadingProgress, String?, QQueryOperations>
      englishTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'englishTitle');
    });
  }

  QueryBuilder<ReadingProgress, DateTime, QQueryOperations>
      lastReadAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastReadAt');
    });
  }

  QueryBuilder<ReadingProgress, int, QQueryOperations>
      lastReadChapterProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastReadChapter');
    });
  }

  QueryBuilder<ReadingProgress, int, QQueryOperations> lastReadPageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastReadPage');
    });
  }

  QueryBuilder<ReadingProgress, int, QQueryOperations> mangaIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mangaId');
    });
  }

  QueryBuilder<ReadingProgress, double, QQueryOperations>
      readingPercentageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'readingPercentage');
    });
  }

  QueryBuilder<ReadingProgress, String, QQueryOperations>
      romajiTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'romajiTitle');
    });
  }

  QueryBuilder<ReadingProgress, int?, QQueryOperations>
      totalChaptersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalChapters');
    });
  }
}
