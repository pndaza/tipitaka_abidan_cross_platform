import '../models/book.dart';
import 'book_dao.dart';
import 'database.dart';

abstract class BookRepository {
  Future<List<Book>> fetchBooks();
  Future<Book> fetchBookInfo(String bookId);
}

class DatabaseBookRepository extends BookRepository {
  DatabaseBookRepository(this.databaseProvider, this.bookDao);
  final DatabaseHelper databaseProvider;
  final BookDao bookDao;

  @override
  Future<List<Book>> fetchBooks() async {
    final db = await databaseProvider.database;

    final results = await db.query(bookDao.tableName, columns: [
      bookDao.columnID,
      bookDao.columnName,
      bookDao.columnNameInfo,
      bookDao.columnStartPage
    ]);
    return bookDao.fromList(results);
  }

  @override
  Future<Book> fetchBookInfo(String bookId) async {
    final db = await databaseProvider.database;

    final results = await db.query(bookDao.tableName,
        columns: [
          bookDao.columnID,
          bookDao.columnName,
          bookDao.columnNameInfo,
          bookDao.columnStartPage,
        ],
        where: '${bookDao.columnID} = ?',
        whereArgs: [bookId]);

    return bookDao.fromMap(results.first);
  }
}
