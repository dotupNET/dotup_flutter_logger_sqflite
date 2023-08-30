import '../SqLiteType.dart';

class SqLiteColumnDescriptor {
  String? displayName;
  String? tempAlias;
  late final String columnName;
  late final SqLiteType type;
  late final bool nullable;
  late final bool primaryKey;

  SqLiteColumnDescriptor({
    required this.columnName,
    required this.type,
    required this.nullable,
    this.displayName,
    String? exportName,
    this.primaryKey = false,
  });

  String getAliasOrName() {
    return tempAlias ?? columnName;
  }

// TODO: displayName as required
  factory SqLiteColumnDescriptor.string(String name, {String? displayName, bool primaryKey = false}) {
    return SqLiteColumnDescriptor(
        columnName: name, displayName: displayName, type: SqLiteType.string, nullable: false, primaryKey: primaryKey);
  }

  factory SqLiteColumnDescriptor.nullableString(String name, {String? displayName}) {
    return SqLiteColumnDescriptor(columnName: name, displayName: displayName, type: SqLiteType.string, nullable: true);
  }

  factory SqLiteColumnDescriptor.date(String name, {String? displayName}) {
    return SqLiteColumnDescriptor(columnName: name, displayName: displayName, type: SqLiteType.date, nullable: false);
  }

  factory SqLiteColumnDescriptor.nullableDate(String name, {String? displayName}) {
    return SqLiteColumnDescriptor(columnName: name, displayName: displayName, type: SqLiteType.date, nullable: true);
  }

  factory SqLiteColumnDescriptor.bool(String name, {String? displayName}) {
    return SqLiteColumnDescriptor(
        columnName: name, displayName: displayName, type: SqLiteType.integer, nullable: false);
  }

  factory SqLiteColumnDescriptor.nullableBool(String name, {String? displayName}) {
    return SqLiteColumnDescriptor(columnName: name, displayName: displayName, type: SqLiteType.integer, nullable: true);
  }

  factory SqLiteColumnDescriptor.numeric(String name, {String? displayName}) {
    return SqLiteColumnDescriptor(
        columnName: name, displayName: displayName, type: SqLiteType.numeric, nullable: false);
  }

  factory SqLiteColumnDescriptor.nullabelNumeric(String name, {String? displayName}) {
    return SqLiteColumnDescriptor(columnName: name, displayName: displayName, type: SqLiteType.numeric, nullable: true);
  }

  factory SqLiteColumnDescriptor.int(String name, {String? displayName, bool primaryKey = false}) {
    return SqLiteColumnDescriptor(
        columnName: name, displayName: displayName, type: SqLiteType.integer, nullable: false, primaryKey: primaryKey);
  }

  factory SqLiteColumnDescriptor.nullableInt(String name, {String? displayName}) {
    return SqLiteColumnDescriptor(columnName: name, displayName: displayName, type: SqLiteType.integer, nullable: true);
  }

  @override
  toString() {
    return columnName;
  }
}
