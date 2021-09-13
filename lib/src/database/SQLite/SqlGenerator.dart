import 'package:dotup_dart_logger/dotup_dart_logger.dart';

import 'SqLiteType.dart';
import 'models/SqLiteColumnDescriptor.dart';
import 'models/TableDescriptor.dart';

final logger = Logger('SqlGenerator');

class SqlGenerator {
  static String getCreateTableStatement(TableDescriptor tableDescriptor) {
    // Beacause attached database not working proper !!
    // final tempTableName = tableDescriptor.databaseAlias == null
    //     ? tableDescriptor.tableName
    //     : tableDescriptor.tableName
    //         .replaceAll('${tableDescriptor.databaseAlias}.', '');
    final tempTableName = tableDescriptor.getTableName();

    final columnsSql = tableDescriptor.columnDescriptors.map((e) => _getColumnSql(tableDescriptor.tableName, e));

    final columns = columnsSql.map((e) {
      if (e == columnsSql.last) {
        return '$e\n';
      } else {
        return '$e,\n';
      }
    });

    final createSql = '''
create table $tempTableName
(
${columns.join()}
);
''';

    logger.console(createSql);
    return createSql;
  }

  static String _getColumnSql(String tableName, SqLiteColumnDescriptor column) {
    String? datatype;
    switch (column.type) {
      case SqLiteType.string:
        datatype = 'text';
        break;
      case SqLiteType.integer:
        datatype = 'int';
        break;
      case SqLiteType.numeric:
        datatype = 'numeric';
        break;
      case SqLiteType.blob:
        datatype = 'blob';
        break;
      case SqLiteType.date:
        datatype = 'numeric';
        break;
    }

    final canNull = column.nullable ? '' : ' not null';
    final columnSql = '${column.columnName} $datatype$canNull';

    if (column.primaryKey) {
      return '$columnSql constraint ${tableName}_PK primary key';
    } else {
      return columnSql;
    }
  }

  static String getSelectSql(TableDescriptor tableDescriptor, {bool selectAll = false}) {
    final cols = selectAll ? '*' : tableDescriptor.columnDescriptors.map((e) => e.columnName).join(', ');

    return 'SELECT $cols FROM ${tableDescriptor.tableName}';
  }
}
