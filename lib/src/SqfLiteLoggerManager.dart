import 'package:dotup_dart_logger/dotup_dart_logger.dart';
import 'Bootstrapper.dart';
import 'LoggerRepository.dart';
import 'SqfLiteLogWriter.dart';

class SqfLiteLoggerManager {
  // static late final DatabaseRepositoryManager _rm;

  static late LoggerRepository _repository;

  static Future<void> initialize(String databasePath) async {
    final _rm = await Bootstrapper().initialize(databasePath);
    _repository = _rm.getRepository<LoggerRepository>()!;
  }

  static ILogWriter getSqfLiteLogWriter(LogLevel logLevel) {
    return SqfLiteLogWriter(logLevel, _repository);
  }

  static LoggerRepository getLoggerRepository() {
    return _repository;
  }
}
