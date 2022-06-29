import 'dart:convert';

import '../data/shared_pref_client.dart';
import '../models/recent.dart';

abstract class RecentRepository {
  Future<void> insertOrReplace(Recent recent);

  Future<void> delete(Recent recent);

  Future<void> deletes(List<Recent> recents);

  Future<void> deleteAll();

  Future<List<Recent>> getRecents();
}

/*
class RecentDatabaseRepository implements RecentRepository {
  RecentDatabaseRepository(this.databaseProvider, this.dao);
  DatabaseHelper databaseProvider;
  final RecentDao dao;

  @override
  Future<void> insertOrReplace(Recent recent) async {
    final db = await databaseProvider.database;
    // var result = await db.update(dao.tableName, dao.toMap(recent),
    //     where: '${dao.columnBookId} = ?', whereArgs: [recent.bookID]);
    // print('update result: $result');
    // if (result == 0) {
    //   result = await db.insert(dao.tableName, dao.toMap(recent));
    // }

    var result = await db.delete(dao.tableRecent,
        where: '${dao.columnWordId} = ?', whereArgs: [recent.wordId]);
    result = await db.insert(
        dao.tableRecent,
        {
          dao.columnWordId: recent.wordId,
        },
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  @override
  Future<void> delete(Recent recent) async {
    final db = await databaseProvider.database;
    await db.delete(dao.tableRecent,
        where: '${dao.columnWordId} = ?', whereArgs: [recent.wordId]);
  }

  @override
  Future<void> deletes(List<Recent> recents) async {
    int delecteds = 0;
    for (int i = 0, length = recents.length; i < length; i++) {
      await delete(recents[i]);
      delecteds++;
    }
    delecteds;
  }

  @override
  Future<void> deleteAll() async {
    final db = await databaseProvider.database;
    await db.delete(dao.tableRecent);
  }

  @override
  Future<List<Recent>> getRecents() async {
    final db = await databaseProvider.database;
    List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT ${dao.columnWordId}, ${dao.columnWord}, ${dao.columnBookId}, ${dao.columnPageNumber}
      FROM ${dao.tableRecent}
      INNER JOIN ${dao.tableWord} ON ${dao.columnWordId} = ${dao.columnId}
      ''');
    return dao.fromList(maps).reversed.toList();
  }
}
*/

class PrefRecentRepository implements RecentRepository {
  @override
  Future<void> delete(Recent recent) async {
    final recents = await getRecents();
    recents.removeWhere((element) => element.wordId == recent.wordId);
    SharedPreferenceClient.recents = json.encode(recents);
  }

  @override
  Future<void> deleteAll() async {
    SharedPreferenceClient.recents = '{}';
  }

  @override
  Future<void> deletes(List<Recent> recents) async {
    final savedRecents = await getRecents();
    for (final Recent recent in recents) {
      savedRecents.removeWhere((element) => element.wordId == recent.wordId);
    }
    SharedPreferenceClient.recents = json.encode(savedRecents);
  }

  @override
  Future<List<Recent>> getRecents() async {
    final jsonString = SharedPreferenceClient.recents;
    if (jsonString.isEmpty) return <Recent>[];
    // parsing json to recent
    return (json.decode(jsonString) as List)
        .map((e) => Recent.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> insertOrReplace(Recent recent) async {
    final recents = await getRecents();
    // removing if exist
    recents.removeWhere((element) => element.wordId == recent.wordId);
    recents.add(recent);
    recents.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    SharedPreferenceClient.recents = json.encode(recents);
  }
}
