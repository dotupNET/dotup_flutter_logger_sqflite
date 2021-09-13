import 'SqLiteColumnDescriptor.dart';

class TableDescriptor {
  final String tableName;
  final List<SqLiteColumnDescriptor> columnDescriptors;
  final String? databaseAlias;

  TableDescriptor({required this.tableName, required this.columnDescriptors, this.databaseAlias});

  String getTableName(){
    return databaseAlias == null ? tableName: '$databaseAlias.$tableName';
  }
}
