
import 'models/SqLiteFilter.dart';

abstract class IChangeNotifierController {
  Future<int> loadAll();
  Future<void> filter(SqLiteFilter filter);
}
