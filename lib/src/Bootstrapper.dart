import 'LoggerRepository.dart';
import 'database/DatabaseRepositoryManager.dart';
import 'database/SQLite/SqLiteDatabase.dart';

class Bootstrapper {
  Future<DatabaseRepositoryManager> initialize(String databaseFile) async {
    final _repositoryManager = DatabaseRepositoryManager(
      databaseFile,
    );

    _repositoryManager.register((db) => LoggerRepository(db.database));
    await _repositoryManager.initialize(version: 1);

    return _repositoryManager;
  }
}
