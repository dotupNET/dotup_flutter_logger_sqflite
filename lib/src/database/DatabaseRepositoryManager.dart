import 'dart:async';
import 'package:sqflite_common/sqlite_api.dart';
// import 'package:dotup_flutter_zefas/pages/Task/database/TaskProjectRepository.dart';

import 'SQLite/SqLiteDatabase.dart';
import '../Utils.dart';

class DatabaseRepositoryManager extends SqLiteDatabase {

static final  Map<Type, RepositoryFactoryMethod<dynamic>> factories = {};
  static final Map<Type, dynamic> repositories = {};

  DatabaseRepositoryManager(String databaseFile ) : super(databaseFile);

  void register<T extends dynamic>(RepositoryFactoryMethod<T> factoryMethod) {
    final key = typeOfT<T>();
    factories[key] = factoryMethod;
  }

  T? getRepository<T>() {
    final key = typeOfT<T>();
    return getRepositoryOf(key);
  }

  T? getRepositoryOf<T extends dynamic>(Type type) {
    T? instance;

    if (!repositories.containsKey(type)) {
      final fac = _getFactoryOf<T>(type);
      instance = fac!(this);
      repositories[type] = instance;
    } else {
      final entry = repositories.entries.firstWhereOrNull((element) => element.key == type);
      instance = entry?.value as T?;
    }

    return instance;
  }

  RepositoryFactoryMethod<dynamic>? _getFactoryOf<T extends dynamic>(Type type) {
    // final key = typeOfT<T>();

    final result = factories.entries.firstWhereOrNull((element) => element.key == type);
    return result?.value;
  }

  @override
  FutureOr<void> onCreate(Database db, int version) {
    final allTypes = factories.keys;
    final allRepos = allTypes.map((e) => getRepositoryOf(e)).toList();
    for (var item in allRepos) {
      item?.onCreate(db, version);
    }
  }

  @override
  FutureOr<void> onOpen(Database db) {
    // logger.console('open');
    // for (var item in repositories.entries) {
    //   item.value.onOpen(db);
    // }
  }

  @override
  FutureOr<void> onUpgrade(Database db, int oldVersion, int newVersion) {
    final allTypes = factories.keys;
    final allRepos = allTypes.map((e) => getRepositoryOf(e));
    for (var item in allRepos) {
      item?.onUpgrade(db, oldVersion, newVersion);
    }
  }

}
