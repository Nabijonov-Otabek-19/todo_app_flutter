import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomeProvider extends ChangeNotifier {
  final Box _box;

  HomeProvider(this._box);

  List<Map<String, dynamic>> _items = [];

  // getter
  List<Map<String, dynamic>> get items => _items;

  void refreshItems() {
    final data = _box.keys.map((key) {
      final value = _box.get(key);
      return {"key": key, "name": value["name"], "quantity": value['quantity']};
    }).toList();

    // we use "reversed" to sort items in order from the latest to the oldest
    _items = data.reversed.toList();

    notifyListeners();
  }

  Future<void> createItem(Map<String, dynamic> newItem) async {
    await _box.add(newItem);
    refreshItems(); // update the UI
  }

  Map<String, dynamic> _readItem(int key) {
    final item = _box.get(key);
    return item;
  }

  Future<void> updateItem(int itemKey, Map<String, dynamic> item) async {
    await _box.put(itemKey, item);
    refreshItems(); // Update the UI
  }

  Future<void> deleteItem(int itemKey, BuildContext context) async {
    await _box.delete(itemKey);
    refreshItems(); // update the UI

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
      final existingItem =
          _items.firstWhere((element) => element['key'] == itemKey);
      nameController.text = existingItem['name'];
      quantityController.text = existingItem['quantity'];
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
                        createItem({
                          "name": nameController.text.trim(),
                          "quantity": quantityController.text.trim()
                        });
                      }

                      // update an existing item
                      if (itemKey != null &&
                          nameController.text.isNotEmpty &&
                          quantityController.text.isNotEmpty) {
                        updateItem(itemKey, {
                          'name': nameController.text.trim(),
                          'quantity': quantityController.text.trim()
                        });
                      }

                      // Clear the text fields
                      nameController.text = '';
                      quantityController.text = '';

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
