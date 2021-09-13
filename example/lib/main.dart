import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:dotup_dart_logger/dotup_dart_logger.dart';
import 'package:dotup_flutter_logger/dotup_flutter_logger.dart';
import 'package:dotup_flutter_logger_sqflite/dotup_flutter_logger_sqflite.dart';
import 'package:dotup_flutter_widgets/dotup_flutter_widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

late final ILogWriter sqfLiteLogWriter;

final logger = Logger('Logger demo');

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LoggerManager.addLogWriter(ConsoleLogWriter(LogLevel.All, formater: PrettyFormater(showColors: true)));
  mainAsync();
}

Future<void> mainAsync() async {
  var dir = await getApplicationDocumentsDirectory();
  final dbFolder = dir.path;

  if (!await Directory(dbFolder).exists()) {
    await Directory(dbFolder).create(recursive: true);
  }

  final databaseFile = '$dbFolder/logging.db';

  await SqfLiteLoggerManager.initialize(databaseFile);
  sqfLiteLogWriter = SqfLiteLoggerManager.getSqfLiteLogWriter(LogLevel.All); //  SqfLiteLogWriter(LogLevel.All);
  LoggerManager.addLogWriter(sqfLiteLogWriter);
  runApp(const LoggerDemoProvider());
}

class LoggerDemoApp extends StatelessWidget {
  const LoggerDemoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.console('LoggerDemoApp build');
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          scrollBehavior: TouchAndMouseScrollBehavior(),
          debugShowCheckedModeBanner: false,
          title: 'dotup.de Logger Demo',
          theme: themeProvider.lightTheme,
          darkTheme: themeProvider.darkTheme,
          themeMode: themeProvider.themeMode,
          home: LoggerDemoScaffold(),
        );
      },
    );
  }
}

class LoggerDemoProvider extends StatelessWidget {
  const LoggerDemoProvider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.console('LoggerDemoProvider build');
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            final themeProvider = ThemeProvider.defaultThemes();
            themeProvider.switchTheme(false);
            return themeProvider;
          },
        )
      ],
      child: const LoggerDemoApp(),
    );
  }
}

class LoggerDemoScaffold extends StatefulWidget {
  const LoggerDemoScaffold({Key? key}) : super(key: key);

  @override
  _LoggerDemoScaffoldState createState() => _LoggerDemoScaffoldState();
}

class _LoggerDemoScaffoldState extends State<LoggerDemoScaffold> {
  late LoggerListController controller;
  late LoggerListSettings settings;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    controller = LoggerListController(stackSize: 50, logEntryReader: logEntryReader);
    settings = LoggerListSettings.standard();
  }

  @override
  Widget build(BuildContext context) {
    return LoggerScaffold(
      loggerListController: controller,
      appBar: AppBar(
        title: const Text('dotup Logger'),
        actions: [
          IconButton(
            icon: _timer == null ? const Icon(Icons.play_arrow_outlined) : const Icon(Icons.pause),
            tooltip: 'Start/Stop adding entries',
            onPressed: () {
              if (_timer == null) {
                _timer = Timer.periodic(const Duration(seconds: 1), (_) {
                  _createDemoEntry();
                });
                setState(() {});
              } else {
                _timer!.cancel();
                _timer = null;
                setState(() {});
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add entry',
            onPressed: _createDemoEntry,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Einstellungen',
            onPressed: () async {
              logger.info('Einstellungen geöffnet');
              final newSettings = await Navigator.of(context).push<LoggerListSettings>(MaterialPageRoute(
                builder: (context) => LoggerListSettingsPage(settings: settings),
              ));

              if (newSettings != null) {
                controller.setFilter(newSettings.logLevelStates);
                controller.stackSize = newSettings.pageSize;
                settings = newSettings;
                logger.info('Neue Einstellungen übernommen');
              }
            },
          ),
        ],
      ),
      title: 'dotup Logger',
    );
  }

  void _createDemoEntry() {
    var random = Random(DateTime.now().microsecondsSinceEpoch);
    var next = 1 << random.nextInt(LogLevel.values.length);
    var nextLevel = LogLevel.fromValue(next);

    switch (nextLevel) {
      case LogLevel.Debug:
        logger.debug("This is an debug entry. Disable debug entries if you're ready for production!",
            source: 'SOURCE1');
        break;

      case LogLevel.Error:
        logger.error(MyError("We've a problem!"));
        break;

      case LogLevel.Exception:
        logger.exception(MyException('Well. It can happen..'));
        break;

      case LogLevel.Info:
        logger.info("I think you've know this information.");
        break;

      case LogLevel.Warn:
        logger.warn("Uuuh it's working. Maybe you can take a look at your source code why this happens so foten?");
        break;

      default:
        logger.warn('nextLevel == ${nextLevel.name}');
    }
  }

  Future<List<LogEntry>> logEntryReader(int currentItemsCount, int partialItemsCount) async {
    final repo = SqfLiteLoggerManager.getLoggerRepository();
    final result = await repo.readPaged(skip: currentItemsCount, take: partialItemsCount, orderBy: 'timeStamp desc');
    // await Future.delayed(Duration(seconds: 2));
    print(result?.length.toString());
    return result?.map((e) => LoggerMapper.toLogEntry(e)).toList() ?? [];
  }
}

class MyError extends Error {
  final String message;
  MyError(this.message);

  @override
  String toString() {
    return message;
  }
}

class MyException implements Exception {
  final String? message;

  MyException([this.message]);

  @override
  String toString() {
    if (message == null) return 'Exception';
    return 'Exception: $message';
  }
}

class TouchAndMouseScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => { 
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    // etc.
  };
}