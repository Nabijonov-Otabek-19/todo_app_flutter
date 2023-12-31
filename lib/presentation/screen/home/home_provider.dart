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

  void showFormDialog(BuildContext ctx, int? itemKey) async {
    // itemKey == null -> create new item
    // itemKey != null -> update an existing item

    final TextEditingController nameController = TextEditingController();
    final TextEditingController quantityController = TextEditingController();

    if (itemKey != null) {
      final existingItem = _readItem(itemKey)!;
      nameController.text = existingItem.title;
      quantityController.text = existingItem.description;
    }

    showModalBottomSheet(
        isDismissible: false,
        context: ctx,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(ctx).viewInsets.bottom,
                  top: 15,
                  left: 15,
                  right: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(hintText: 'Name'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'Quantity'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      // Save new item
                      if (itemKey == null &&
                          nameController.text.isNotEmpty &&
                          quantityController.text.isNotEmpty) {
                        createItem(TodoModel(
                          title: nameController.text.trim(),
                          description: quantityController.text.trim(),
                          category: "",
                          date: "",
                          time: "",
                          isDone: false,
                        ));
                      }

                      // update an existing item
                      if (itemKey != null &&
                          nameController.text.isNotEmpty &&
                          quantityController.text.isNotEmpty) {
                        updateItem(
                            itemKey,
                            TodoModel(
                              title: nameController.text.trim(),
                              description: quantityController.text.trim(),
                              category: "",
                              date: "",
                              time: "",
                              isDone: false,
                            ));
                      }

                      // Clear the text fields
                      nameController.clear();
                      quantityController.clear();

                      Navigator.of(ctx).pop(); // Close the bottom sheet
                    },
                    child: Text(itemKey == null ? 'Create New' : 'Update'),
                  ),
                  const SizedBox(height: 15)
                ],
              ),
            ));
  }
}
