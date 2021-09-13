import 'package:dotup_dart_logger/dotup_dart_logger.dart';

import 'Entity.dart';

class LoggerEntity extends Entity {
  final LogLevel logLevel;
  final String message;
  late final DateTime timeStamp;
  final Object? error;
  final Map<String, dynamic>? data;
  final StackTrace? stackTrace;
  final String? source;
  final String? loggerName;

  LoggerEntity({
    required this.logLevel,
    required this.message,
    DateTime? timeStamp,
    this.data,
    this.error,
    this.stackTrace,
    this.source,
    this.loggerName,
    // From Entity
    required String id,
  }) : super(
          // From Entity
          id: id,
        ){
          this.timeStamp= timeStamp!;
        }
}
