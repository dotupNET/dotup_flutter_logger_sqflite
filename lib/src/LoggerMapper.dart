import 'package:dotup_dart_logger/dotup_dart_logger.dart';


import 'LoggerRepository.dart';
import 'Utils.dart';
import 'database/LoggerEntity.dart';
import 'database/SQLite/SqLiteRepository.dart';

class LoggerMapper {
  static LoggerEntity fromMap(Map<String, Object?> map) {
    final level = LogLevel.values.firstWhere((element) => element.name == map[LoggerRepository.LogLevel.columnName]);

    return LoggerEntity(
      id: map[SqLiteRepository.Id.columnName] as String,
      logLevel: level,
      message: map[LoggerRepository.Message.columnName] as String,
// data: map[LoggerRepository.Data.columnName] as Map<String, dynamic>? data,
      error: nullOrString(map[LoggerRepository.Error.columnName]),
      loggerName: nullOrString(map[LoggerRepository.LoggerName.columnName]),
      source: nullOrString(map[LoggerRepository.Source.columnName]),
// stackTrace: nullOrString(map[LoggerRepository.StackTrace.columnName]),
      timeStamp: nullOrDateTime(map[LoggerRepository.TimeStamp.columnName]),
    );
  }

  static Map<String, Object?> toMap(LoggerEntity item) {
    return <String, Object?>{
      // Date
      SqLiteRepository.Id.getAliasOrName(): item.id,
      LoggerRepository.LogLevel.getAliasOrName(): item.logLevel.name,
      LoggerRepository.Message.getAliasOrName(): item.message,
      LoggerRepository.Error.getAliasOrName(): item.error.toString(),
      LoggerRepository.LoggerName.getAliasOrName(): item.loggerName,
      LoggerRepository.Source.getAliasOrName(): item.source,
      LoggerRepository.TimeStamp.getAliasOrName(): item.timeStamp.millisecondsSinceEpoch,
    };
  }

  static LoggerEntity toLoggerEntity(String id, LogEntry entry) {
    return LoggerEntity(
      id: id,
      logLevel: entry.logLevel,
      message: entry.message,
      data: entry.data,
      error: entry.error,
      loggerName: entry.loggerName,
      source: entry.source,
      stackTrace: entry.stackTrace,
      timeStamp: entry.timeStamp,
    );
  }

  static LogEntry toLogEntry(LoggerEntity entity) {
    return LogEntry(
      // id: id,
      logLevel: entity.logLevel,
      message: entity.message,
      data: entity.data,
      error: entity.error,
      loggerName: entity.loggerName,
      source: entity.source,
      stackTrace: entity.stackTrace,
      timeStamp: entity.timeStamp,
    );
  }
}
