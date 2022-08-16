import '../models/word.dart';

class WordDao {
  final tableName = 'words';
  final columnId = 'id';
  final columnWord = 'word';
  final columnBookID = 'book_id';
  final columnPage = 'page_number';

  Word fromMap(Map<String, dynamic> map) {
    return Word(
      id: map[columnId] as int,
      word: map[columnWord] as String,
      bookId: map[columnBookID] as String,
      pageNumber: map[columnPage] as int,
    );
  }

  List<Word> fromList(List<Map<String, dynamic>> query) {
    return query.map((e) => fromMap(e)).toList();
  }
}
