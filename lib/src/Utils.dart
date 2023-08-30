import 'package:sqflite/sqflite.dart';

import 'database/SQLite/SqLiteDatabase.dart';

Type typeOfT<T>() => T;

final intType = typeOfT<int>();
final intNullType = typeOfT<int?>();
final boolType = typeOfT<bool>();
final boolNullType = typeOfT<bool?>();
final stringType = typeOfT<String>();
final stringNullType = typeOfT<String?>();
final dateTimeType = typeOfT<DateTime>();
final dateTimeNullType = typeOfT<DateTime?>();

typedef RepositoryFactoryMethod<T> = T Function(SqLiteDatabase db);
typedef SqLiteRepositoryFactoryMethod<T> = T Function(DatabaseExecutor databaseExecutor);

extension IterableExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (T element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }
}

String? nullOrString(Object? value) {
  if (value == null) {
    return null;
  } else {
    return value.toString().isEmpty ? null : value as String;
  }
}

T getValue<T>(dynamic value) {
  if (value == null) {
    return null as T;
  }

  final x = typeOfT<T>();

  if (x == intType || x == intNullType) {
    return int.parse(value.toString()) as T;
  } else if (x == boolType || x == boolNullType) {
    return (value.toString().toLowerCase() == 'true') as T;
  } else if (x == stringType || x == stringNullType) {
    return value.toString() as T;
  } else if (x == dateTimeType || x == dateTimeNullType) {
    return nullOrDateTime(value) as T;
  }

  return value as T;
  // if (value == null) {
  //   return null as T;
  // } else {
  //   return value as T;
  // }
}

DateTime? nullOrDateTime(Object? value) {
  if (value == null) {
    return null;
  } else if (value.toString().isEmpty) {
    return null;
  } else if (value is int) {
    return DateTime.fromMillisecondsSinceEpoch(value);
  } else {
    return DateTime.fromMillisecondsSinceEpoch(int.parse(value.toString()));
  }
}
