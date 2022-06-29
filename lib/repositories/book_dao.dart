import '../models/book.dart';

class BookDao {
  final tableName = 'books';
  final columnID = 'id';
  final columnName = 'name';
  final columnNameInfo = 'name_info';
  final columnStartPage = 'start_page';

  Book fromMap(Map<String, dynamic> map) {
    return Book(
      id: map[columnID] as String,
      name: map[columnName] as String,
      nameInfo: map[columnNameInfo] as String,
      startPage: map[columnStartPage] as int

    );
  }

  List<Book> fromList(List<Map<String, dynamic>> query) {
    return query.map((e) => fromMap(e)).toList();
  }
}