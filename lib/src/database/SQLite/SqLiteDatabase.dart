import 'dart:async';

import 'package:sqflite/sqflite.dart';


abstract class SqLiteDatabase {
  FutureOr<void> onCreate(Database db, int version);
  FutureOr<void> onUpgrade(Database db, int oldVersion, int newVersion);
  FutureOr<void> onOpen(Database db);

  late final String _databaseFile;
  late Database _db;
  Database get database => _db;

  SqLiteDatabase(String databaseFile) {
    _databaseFile = databaseFile;
  }

  Future<void> initialize({required int version}) async {
    await openDatabase(
      _databaseFile,
      version: version,
      onConfigure: (db) async {
        _db = db;
      },
      onCreate: onCreate,
      onUpgrade: onUpgrade,
      onOpen: onOpen,
      singleInstance: true,
    );
  }

  Future<void> close() {
    return database.close();
  }
}
