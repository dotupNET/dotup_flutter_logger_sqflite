import 'package:dotup_dart_logger/dotup_dart_logger.dart';
import 'package:uuid/uuid.dart';

import 'LoggerMapper.dart';
import 'LoggerRepository.dart';

class SqfLiteLogWriter implements ILogWriter {
  late final LoggerRepository repository;

  @override
  LogLevel logLevel;

  SqfLiteLogWriter(this.logLevel, this.repository);

  @override
  void write(LogEntry logEntry) {
    repository.create(LoggerMapper.toLoggerEntity(const Uuid().v4(), logEntry));
  }
}
