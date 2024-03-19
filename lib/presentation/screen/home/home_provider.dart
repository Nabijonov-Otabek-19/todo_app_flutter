import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../../data/model/todo_model.dart';

class HomeProvider extends ChangeNotifier {
  final Box _box;
  final BuildContext context;

  HomeProvider(this._box, this.context);

  Future<void> createItem(TodoModel newItem) async {
    await _box.add(newItem);
    notifyListeners();
  }

  TodoModel? _readItem(int key) {
    final item = _box.get(key);
    return item;
  }

  Future<int> totalCompletedTasks(List<int> keys, Box<TodoModel> items) async {
    int total = 0;

    for (var key in keys) {
      final TodoModel data = items.get(key) ??
          TodoModel(
            title: "",
            description: "",
            category: "",
            date: "",
            time: "",
            isDone: false,
          );

      if (data.isDone) total++;
    }
    return total;
  }

  Future<void> updateItem(int itemKey, TodoModel item) async {
    await _box.put(itemKey, item);
    notifyListeners();
  }

  Future<void> deleteItem(int itemKey, bool mounted) async {
    await _box.delete(itemKey);
    notifyListeners();

    // Display a snackbar
    if (!mounted) return;
    showSnackBar(mounted);
  }

  void showSnackBar(bool mounted) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An item has been deleted')));
  }
}
