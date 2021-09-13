
import 'SqLiteColumnDescriptor.dart';

class SqLiteFilter {
  late final List<SqLiteColumnDescriptor> columns;
  late final String value;
  late final String comparator;

  SqLiteFilter(this.columns, this.value, this.comparator);

  factory SqLiteFilter.equals(SqLiteColumnDescriptor column, String value) {
    return SqLiteFilter([column], value, '=');
  }

  factory SqLiteFilter.equalsOr(List<SqLiteColumnDescriptor> columns, String value) {
    return SqLiteFilter(columns, value, '=');
  }

  factory SqLiteFilter.like(SqLiteColumnDescriptor column, String value) {
    return SqLiteFilter([column], value, 'like');
  }

  factory SqLiteFilter.likeOr(List<SqLiteColumnDescriptor> columns, String value) {
    return SqLiteFilter(columns, value, 'like');
  }

  String getWhere() {
    switch (comparator) {
      case 'like':
        return columns.map((column) => '${column.columnName} like ?').join(' or ');

      default:
        return columns.map((column) => '${column.columnName} $comparator ?').join(' or ');
    }
  }

  List<String> getWhereArgs() {
    String result = value;

    switch (comparator) {
      case 'like':
        if (!result.startsWith('%')) {
          result = '%$result';
        }
        if (!result.endsWith('%')) {
          result = '$result%';
        }
        break;

      default:
      // return columns.map((column) => '${column.columnName} $comparator ?').join(' or ');
    }

    return List.filled(columns.length, result);
  }
}
