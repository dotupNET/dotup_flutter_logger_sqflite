# dotup_flutter_logger_sqflite

## Take a look at [dotup.de](https://dotup.de) or on [pub.dev](https://pub.dev/packages?q=dotup)

## Example

```dart
Future<void> example() async {

  var dir = await getApplicationDocumentsDirectory();
  final dbFolder = dir.path;

  if (!await Directory(dbFolder).exists()) {
    await Directory(dbFolder).create(recursive: true);
  }

  final databaseFile = '$dbFolder/logging.db';

  // Initialize log writer
  final sqfLiteLogWriter = SqfLiteLogWriter(LogLevel.All);
  await sqfLiteLogWriter.initialize(databaseFile);
  // Add to logger manager
  LoggerManager.addLogWriter(sqfLiteLogWriter);

  runApp(MyApp());


  // Use it everywhere
  final logger = Logger('Nice');
  logger.warn('Oh');
  logger.info('Ah');

  // Get all entries from database
  final repo = sqfLiteLogWriter.repository;
  final all = await repo.readAll();
  for (var item in all) {
    print(item.message);
  }

}
```
