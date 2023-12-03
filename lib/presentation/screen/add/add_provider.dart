import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../../data/model/todo_model.dart';

class AddProvider extends ChangeNotifier {
  final Box _box;

  AddProvider(this._box);

  Future<void> createItem(TodoModel newItem) async {
    await _box.add(newItem);
    notifyListeners();
  }

  Future<void> updateItem(int itemKey, TodoModel item) async {
    await _box.put(itemKey, item);
    notifyListeners();
  }

  TodoModel? readItem(int key) {
    final item = _box.get(key);
    return item;
  }
}
