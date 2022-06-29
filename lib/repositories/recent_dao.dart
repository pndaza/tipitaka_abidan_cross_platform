

/*
class RecentDao implements Dao<Recent> {
  final tableRecent = 'recent';
  final tableWord = 'word';
  final columnWordId = 'word_id';
  final columnId = 'id';
  final columnWord = 'word';
  final columnBookId = 'book_id';
  final columnPageNumber = 'page_number';

  @override
  List<Recent> fromList(List<Map<String, dynamic>> query) {
    return query.map((e) => fromMap(e)).toList();
  }

  @override
  Recent fromMap(Map<String, dynamic> query) {
    return Recent(
      wordId: query[columnWordId] as int,
      word: query[columnWord] as String,
      bookID: query[columnBookId] as String, 
      pageNumber: query[columnPageNumber] as int,
    );
  }

  @override
  Map<String, dynamic> toMap(Recent object) {
    return <String, dynamic>{
      columnId: object.wordId,
      columnWord: object.word,
      columnBookId: object.bookID,
      columnPageNumber: object.pageNumber,
    };
  }
}

*/
