import 'dart:convert';

import '../data/shared_pref_client.dart';
import '../models/favourite.dart';

abstract class FavouriteRepository {
  Future<void> insert(Favourite favourite);

  Future<void> delete(Favourite favourite);
  Future<void> deletes(List<Favourite> favourites);
  Future<void> deleteAll();

  Future<List<Favourite>> getFavourites();
}

/*
class FavouriteDatabaseRepository extends FavouriteRepository {
  FavouriteDatabaseRepository(this._databaseHelper, this.dao);
  final DatabaseHelper _databaseHelper;
  final FavouritekDao dao;

  @override
  Future<void> insert(Favourite favourite) async {
    final db = await _databaseHelper.database;
     await db.insert(dao.tableFavourite, dao.toMap(favourite));
  }

  @override
  Future<void> delete(Favourite favourite) async {
    final db = await _databaseHelper.database;
     await db.delete(dao.tableFavourite,
        where: '${dao.columnBookId} = ?', whereArgs: [favourite.bookID]);
  }

  @override
  Future<void> deletes(List<Favourite> favourites) async {
    int delecteds = 0;
    for (int i = 0, length = favourites.length; i < length; i++) {
      await delete(favourites[i]);
      delecteds++;
    }
  }

  @override
  Future<void> deleteAll() async {
    final db = await _databaseHelper.database;
     await db.delete(dao.tableFavourite);
  }

  @override
  Future<List<Favourite>> getFavourites() async {
    final db = await _databaseHelper.database;
    List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT ${dao.columnWordId}, ${dao.columnWord}, ${dao.columnBookId}, ${dao.columnPageNumber}
      FROM ${dao.tableFavourite}
      INNER JOIN ${dao.tableWord} ON ${dao.columnWordId} = ${dao.columnId}
      ''');
    return dao.fromList(maps).reversed.toList();
  }
}

*/


class PrefFavouriteRepository implements FavouriteRepository {

  @override
  Future<void> delete(Favourite favourite) async {
    final favourites = await getFavourites();
    favourites.removeWhere((element) => element.wordId == favourite.wordId);
    SharedPreferenceClient.favourites = json.encode(favourites);
  }

  @override
  Future<void> deleteAll() async {
    SharedPreferenceClient.favourites = '{}';
  }

  @override
  Future<void> deletes(List<Favourite> favourites) async {
        final savedFavourites = await getFavourites();
    for (final Favourite favourite in favourites) {
      savedFavourites.removeWhere((element) => element.wordId == favourite.wordId);
    }
    SharedPreferenceClient.favourites = json.encode(savedFavourites);
  }

  @override
  Future<List<Favourite>> getFavourites() async {
    final jsonString = SharedPreferenceClient.favourites;
    if (jsonString.isEmpty) return <Favourite>[];
    // parsing json to recent
    return (json.decode(jsonString) as List)
        .map((e) => Favourite.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> insert(Favourite favourite) async {
    final favourites = await getFavourites();
    // removing if exist
    favourites.removeWhere((element) => element.wordId == favourite.wordId);
    favourites.add(favourite);
    favourites.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    SharedPreferenceClient.favourites = json.encode(favourites);
  }
}
