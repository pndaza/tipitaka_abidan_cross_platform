

/*
class FavouritekDao extends Dao<Favourite> {
  final tableFavourite = 'favourite';
  final tableWord = 'word';
  final columnWordId = 'word_id';
  final columnId = 'id';
  final columnWord = 'word';
  final columnBookId = 'book_id';
  final columnPageNumber = 'page_number';

  @override
  Favourite fromMap(Map<String, dynamic> query) {
    return Favourite(
      wordId: query[columnWordId] as int,
      word: query[columnWord] as String,
      bookID: query[columnBookId] as String,
      pageNumber: query[columnPageNumber] as int,
    );
  }

  @override
  Map<String, dynamic> toMap(Favourite object) {
     return <String, dynamic>{
      columnId: object.wordId,
      columnWord: object.word,
      columnBookId: object.bookID,
      columnPageNumber: object.pageNumber,
    };
  }

  @override
  List<Favourite> fromList(List<Map<String, dynamic>> query) {
    return query.map((e) => fromMap(e)).toList();
  }
}
*/