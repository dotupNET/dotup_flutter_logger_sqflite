// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:sqflite/sqflite.dart';

import 'LoggerMapper.dart';
import 'database/LoggerEntity.dart';
import 'database/SQLite/SqLiteRepository.dart';
import 'database/SQLite/SqlGenerator.dart';
import 'database/SQLite/models/SqLiteColumnDescriptor.dart';
import 'database/SQLite/models/TableDescriptor.dart';

class LoggerRepository extends SqLiteRepository<LoggerEntity> {
  static const String _tableName = 'Logging';

  static final LogLevel = SqLiteColumnDescriptor.nullableString('logLevel');
  static final Message = SqLiteColumnDescriptor.string('message');
  static final TimeStamp = SqLiteColumnDescriptor.string('timeStamp');
  static final Error = SqLiteColumnDescriptor.nullableString('error');
  static final Data = SqLiteColumnDescriptor.nullableString('data');
  static final StackTrace = SqLiteColumnDescriptor.nullableString('stackTrace');
  static final Source = SqLiteColumnDescriptor.nullableString('source');
  static final LoggerName = SqLiteColumnDescriptor.nullableString('loggerName');

  LoggerRepository(Database db)
      : super(
          db: db,
          tableDescriptor: TableDescriptor(tableName: _tableName, columnDescriptors: COLUMNS),
          // tableName: _tableName,
          // columns: COLUMNS,
          toMap: LoggerMapper.toMap,
          fromMap: LoggerMapper.fromMap,
        );

  static final List<SqLiteColumnDescriptor> COLUMNS = [
    LogLevel,
    Message,
    TimeStamp,
    Error,
    Data,
    StackTrace,
    Source,
    LoggerName,
  ];

  @override
  FutureOr<void> onCreate(DatabaseExecutor db, int version) async {
    final sql = SqlGenerator.getCreateTableStatement(tableDescriptor);

    switch (version) {
      case 1:
        return await db.execute(sql);

      default:
    }
  }

  @override
  FutureOr<void> onUpgrade(DatabaseExecutor db, int oldVersion, int newVersion) {
    switch (oldVersion) {
      case 1:
        _upgradeFromV1(db, newVersion);
        break;
      default:
    }
  }

  Future<void> _upgradeFromV1(DatabaseExecutor db, int newVersion) async {}
}
