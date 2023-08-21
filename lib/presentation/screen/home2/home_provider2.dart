import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_app/data/model2/todo_model2.dart';

class HomeProvider2 extends ChangeNotifier {
  final Box<TodoModel2> _box;

  HomeProvider2(this._box);

  Future<void> createItem(TodoModel2 newItem) async {
    await _box.add(newItem);
    notifyListeners();
  }

  TodoModel2? _readItem(int key) {
    final item = _box.get(key);
    return item;
  }

  Future<void> updateItem(int itemKey, TodoModel2 item) async {
    await _box.put(itemKey, item);
    notifyListeners();
  }

  Future<void> deleteItem(int itemKey, BuildContext context) async {
    await _box.delete(itemKey);
    notifyListeners();

    // Display a snackbar
    //if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An item has been deleted')));
  }

  void showFormDialog(BuildContext ctx, int? itemKey) async {
    // itemKey == null -> create new item
    // itemKey != null -> update an existing item

    // TextFields' controllers
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
                        createItem(TodoModel2(
                            title: nameController.text.trim(),
                            description: quantityController.text.trim()));
                      }

                      // update an existing item
                      if (itemKey != null &&
                          nameController.text.isNotEmpty &&
                          quantityController.text.isNotEmpty) {
                        updateItem(
                            itemKey,
                            TodoModel2(
                                title: nameController.text.trim(),
                                description: quantityController.text.trim()));
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
