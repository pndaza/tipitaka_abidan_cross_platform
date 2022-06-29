import '../models/word.dart';
import 'database.dart';
import 'word_dao.dart';

enum SearchMode { prefix, anywhere }

abstract class WordRepository {
  Future<List<Word>> fetchWordlist(String bookId);
  Future<List<Word>> getWords(
      {required String word, SearchMode searchMode = SearchMode.prefix});
}

class DatabaseWordRepository extends WordRepository {
  DatabaseWordRepository(this.databaseProvider, this.wordDao);
  final DatabaseHelper databaseProvider;
  final WordDao wordDao;

  @override
  Future<List<Word>> fetchWordlist(String bookId) async {
    final db = await databaseProvider.database;

    final results = await db.query(wordDao.tableName,
        columns: [
          wordDao.columnId,
          wordDao.columnWord,
          wordDao.columnBookID,
          wordDao.columnPage,
        ],
        where: '${wordDao.columnBookID} = ?',
        whereArgs: [bookId]);
    return wordDao.fromList(results);
  }

  @override
  Future<List<Word>> getWords(
      {required String word, SearchMode searchMode = SearchMode.prefix}) async {
    word = searchMode == SearchMode.prefix ? '$word%' : '%$word%';
    final db = await databaseProvider.database;

    final results = await db.query(wordDao.tableName,
        columns: [
          wordDao.columnId,
          wordDao.columnWord,
          wordDao.columnBookID,
          wordDao.columnPage,
        ],
        where: '${wordDao.columnWord} LIKE ?',
        whereArgs: [word]);
    return wordDao.fromList(results);
  }
}
