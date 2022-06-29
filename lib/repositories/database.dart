import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../data/constants.dart';
import '../data/shared_pref_client.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper _instance = DatabaseHelper._();
  factory DatabaseHelper() => _instance;

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

// Open Assets Database
  _initDatabase() async {
    // print('initializing Database');
    late String databasesDirPath;

    if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
      databasesDirPath = await getDatabasesPath();
    }
    if (Platform.isLinux || Platform.isWindows) {
      final docDirPath = await getApplicationSupportDirectory();
      databasesDirPath = docDirPath.path;
    }

    var dbFilePath = join(databasesDirPath, DatabaseInfo.dbName);

    var exists = await databaseExists(dbFilePath);

    debugPrint('db version: ${SharedPreferenceClient.databaseVerion}');

    if (exists &&
        SharedPreferenceClient.isInitialized &&
        SharedPreferenceClient.databaseVerion == DatabaseInfo.dbVersion) {
      // database is upto date
      return await openDatabase(dbFilePath);
    }

    // final recents = <Map<String, Object?>>[];
    // final bookmarks = <Map<String, Object?>>[];

    if ((exists &&
            SharedPreferenceClient.isInitialized &&
            SharedPreferenceClient.databaseVerion < DatabaseInfo.dbVersion) ||
        (exists &&
            SharedPreferenceClient.databaseVerion < DatabaseInfo.dbVersion)) {
      // database is outdated

      debugPrint('update mode');
      /*
      // backuping user data to memory
      final oldDatabase = await openDatabase(dbFilePath);
      recents
          .addAll(await backup(oldDatabase: oldDatabase, tableName: 'recent'));
      bookmarks.addAll(
          await backup(oldDatabase: oldDatabase, tableName: 'favourite'));
*/
      // deleting old database
      await deleteDatabase(dbFilePath);
      // saving new database
      await _saveDatabaseFromAssets(dbFilePath: dbFilePath);

      //  databaseHelper = DatabaseHelper();
      /*
      // restoring user data
      final newDatabase = await openDatabase(dbFilePath);
      if (recents.isNotEmpty) {
        await restore(
            newDatabase: newDatabase, tableName: 'recent', values: recents);
      }

      if (bookmarks.isNotEmpty) {
        await restore(
            newDatabase: newDatabase, tableName: 'bookmark', values: bookmarks);
      }
*/
      return await openDatabase(dbFilePath);
    }

    // database is not initialized
    debugPrint('new db mode');
    // make sure destination path is created
    try {
      await Directory(dirname(databasesDirPath)).create(recursive: true);
    } catch (_) {}
    // saving database
    await _saveDatabaseFromAssets(dbFilePath: dbFilePath);

    return await openDatabase(dbFilePath);
  }

  Future<void> _saveDatabaseFromAssets({required String dbFilePath}) async {
    // Copy from asset
    const dbFileAssetsPath =
        "${DatabaseInfo.assetsPath}/${DatabaseInfo.dbName}";
    await _copyDatabase(assetsPath: dbFileAssetsPath, destination: dbFilePath);

    // save to pref
    SharedPreferenceClient.isInitialized = true;
    SharedPreferenceClient.databaseVerion = DatabaseInfo.dbVersion;
  }

  Future<void> _copyDatabase(
      {required String assetsPath, required String destination}) async {
    ByteData data = await rootBundle.load(assetsPath);
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    await File(destination).writeAsBytes(bytes, flush: true);
  }

/*
  Future<List<Map<String, Object?>>> backup(
      {required Database oldDatabase, required String tableName}) async {
    // print('maps: ${maps.length}');
    return await oldDatabase.query(tableName);
  }

  Future<void> restore(
      {required Database newDatabase,
      required String tableName,
      required List<Map<String, Object?>> values}) async {
    for (final value in values) {
      await newDatabase.insert(tableName, value);
    }
  }
  */

  Future close() async {
    return _database?.close();
  }
}
