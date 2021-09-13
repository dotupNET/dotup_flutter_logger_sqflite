// ignore_for_file: non_constant_identifier_names
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../Entity.dart';
import 'models/SqLiteColumnDescriptor.dart';
import 'models/TableDescriptor.dart';

typedef Map<String, Object?> ToMap<T>(T value);
typedef T FromMap<T>(Map<String, Object?> value);

abstract class SqLiteRepository<T extends Entity> {
  static final Id = SqLiteColumnDescriptor.string('id', primaryKey: true);

  @protected
  late final DatabaseExecutor db;

  late String? databaseAlias;

  late String _tableName;

  TableDescriptor get tableDescriptor => _tableDescriptor;
  late TableDescriptor _tableDescriptor;

  late final ToMap<T> toMap;
  late final FromMap<T> fromMap;

  // late final List<SqLiteColumnDescriptor> _specificColumns;
  late final List<String> _allColumnNames;

  SqLiteRepository({
    required DatabaseExecutor db,
    // required String tableName,
    // required List<SqLiteColumnDescriptor> specificColumns,
    required ToMap<T> toMap,
    required FromMap<T> fromMap,
    required TableDescriptor tableDescriptor,
    String? databaseAlias,
  }) {
    this.db = db;
    this.databaseAlias = databaseAlias;
    this.toMap = toMap;
    this.fromMap = fromMap;
    _tableName = tableDescriptor.getTableName();

    _tableDescriptor = TableDescriptor(
      tableName: tableDescriptor.tableName,
      databaseAlias: tableDescriptor.databaseAlias,
      columnDescriptors: [
        Id,
        ...tableDescriptor.columnDescriptors,
      ],
    );
    // _specificColumns = tableDescriptor.columnDescriptors;
    _allColumnNames = _tableDescriptor.columnDescriptors.map((e) => e.columnName).toList();
  }

  FutureOr<void> onInitialize(DatabaseExecutor db) {
    this.db = db;
  }

  FutureOr<void> onCreate(DatabaseExecutor db, int version);
  FutureOr<void> onUpgrade(DatabaseExecutor db, int oldVersion, int newVersion);

  Future<String> create(T item) async {
    await db.insert(_tableName, toMap(item));
    return item.id;
  }

  Future<String> createOrUpdate(T item) async {
    final existing = await read(item.id);
    if (existing == null) {
      await db.insert(_tableName, toMap(item));
    } else {
      await update(item);
    }
    return item.id;
  }

  Future<List<T>> readAll({String? orderBy}) async {
    var allMaps = await db.query(
      _tableName,
      columns: _allColumnNames,
      orderBy: orderBy,
    );

    final result = allMaps.map((e) => fromMap(e)).toList();

    // final result = await Future.wait(allMaps.map((e) async => await fromMap(e)));
    return result;
  }

  Future<List<T>> readAllFromAccount(String accountId, {String? orderBy}) async {
    var allMaps = await db.query(
      _tableName,
      columns: _allColumnNames,
      orderBy: orderBy,
      where: 'accountId = ?',
      whereArgs: [accountId],
    );

    final result = allMaps.map((e) => fromMap(e)).toList();

    // final result = await Future.wait(allMaps.map((e) async => await fromMap(e)));
    return result;
  }

  Future<T?> read(String id) async {
    final maps = await db.query(
      _tableName,
      limit: 1,
      columns: _allColumnNames,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return fromMap(maps.first as dynamic);
    }
    return null;
  }

  Future<List<T>?> readPaged({required int skip, required int take, String? orderBy}) async {
    final maps = await db.query(
      _tableName,
      limit: take,
      columns: _allColumnNames,
      offset: skip,
      orderBy: orderBy,
    );
    if (maps.isNotEmpty) {
      return maps.map((e) => fromMap(e)).toList();
    }
    return null;
  }

  Future<T?> readFromAccount(String accountId, String id) async {
    final maps = await db.query(
      _tableName,
      limit: 1,
      columns: _allColumnNames,
      where: 'accountId = ? and id = ?',
      whereArgs: [accountId, id],
    );
    if (maps.isNotEmpty) {
      return fromMap(maps.first as dynamic);
    }
    return null;
  }

  Future<int> rawUpdate({required String sql, required List<Object?>? args}) async {
    final result = await db.rawUpdate(
      sql,
      args,
    );
    return result;
  }

  Future<T?> readWhereFirst({required String where, required List<String> whereArgs}) async {
    final maps = await db.query(
      _tableName,
      limit: 1,
      columns: _allColumnNames,
      where: where,
      whereArgs: whereArgs,
    );
    if (maps.isNotEmpty) {
      return fromMap(maps.first as dynamic);
    }
    return null;
  }

  Future<List<T>> readWhere({required String where, required List<String> whereArgs, int? limit}) async {
    final maps = await db.query(
      _tableName,
      limit: limit,
      columns: _allColumnNames,
      where: where,
      whereArgs: whereArgs,
    );

    final result = await Future.wait(maps.map((e) async => await fromMap(e)));
    return result;
  }

  Future<int> update(T item) async {
    return await db.update(
      _tableName,
      toMap(item),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<void> updateBatch(List<T> items) async {
    Batch batch = db.batch();

    for (var item in items) {
      batch.update(
        _tableName,
        toMap(item),
        where: 'id = ?',
        whereArgs: [item.id],
      );
    }

    await batch.commit(noResult: true);
  }

  Future<int> delete(String id) async {
    return await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static TValue? getValue<TValue>(Object? value) {
    if (value == null) {
      return null;
    } else {
      return value as TValue;
    }
  }

  // static String getCreateTableStatement(String tableName, List<SqLiteColumnDescriptor> columns) {
//   String getCreateTableStatement() {
//     final sqlColumns = _specificColumns.map((e) => e.toSqlString()).join(',\n');

//     // Beacause attached database not working proper !!
//     final tempDatabaseName = databaseAlias == null ? tableName : tableName.replaceAll('$databaseAlias.', '');
//     final createSql = '''
// create table $tempDatabaseName
// (
//   ${SqLiteRepository.Id.columnName}            text not null
//       constraint ${tempDatabaseName}_pk primary key,
// $sqlColumns,
//   ${SqLiteRepository.CreatedAt.columnName}     INT  not null,
//   ${SqLiteRepository.CreatedBy.columnName}     text,
//   ${SqLiteRepository.ChangedAt.columnName}     INT,
//   ${SqLiteRepository.ChangedBy.columnName}     text
// );
// ''';

//     logger.console(createSql);
//     return createSql;
//   }
}
