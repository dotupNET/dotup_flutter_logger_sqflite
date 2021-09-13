import 'SQLite/SqLiteRepository.dart';

abstract class Entity {
  late String id;
  Entity({
    required this.id,
  });

  static void toMap(Entity item, Map<String, Object?> target) {
    target[SqLiteRepository.Id.columnName] = item.id;
  }
}
