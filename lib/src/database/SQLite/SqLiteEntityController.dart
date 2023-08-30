import 'dart:async';

import 'package:flutter/widgets.dart';

import '../Entity.dart';
import 'IChangeNotifierController.dart';
import 'SqLiteRepository.dart';
import 'models/SqLiteFilter.dart';

class SqLiteEntityController<T extends Entity> with ChangeNotifier implements IChangeNotifierController {
  List<T> _items = [];
  final SqLiteRepository<T> _repository;

  SqLiteEntityController(this._repository);

  Future<List<T>> getAll() async {
    await _loadAll();
    return _items;
  }

  @override
  Future<int> filter(SqLiteFilter filter) async {
    final where = filter.getWhere();
    final whereArgs = filter.getWhereArgs();
    _items = await _repository.readWhere(where: where, whereArgs: whereArgs);
    notifyListeners();
    return _items.length;
  }

  Future<T?> read(String id) async {
    return await _repository.read(id);
  }

  Future<bool> _loadAll() async {
    _items = await _repository.readAll();
    return true;
  }

  @override
  Future<int> loadAll() async {
    _items = await _repository.readAll();
    notifyListeners();
    return _items.length;
  }

  Future<String> addItem(T newItem) async {
    final result = await _repository.create(newItem);
    await _loadAll();
    notifyListeners();
    return result;
  }

  Future<void> updateItem(T item) async {
    await _repository.update(item);
    await _loadAll();
    notifyListeners();
  }

  Future<void> deleteItem(T item) async {
    await _repository.delete(item.id);
    await _loadAll();
    notifyListeners();
  }

  List<T> get allItems => _items;
}
