import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('todo');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

// Home Page
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _items = [];

  final _shoppingBox = Hive.box('todo');

  @override
  void initState() {
    super.initState();
    _refreshItems(); // Load data when app starts
  }

  // Get all items from the database
  void _refreshItems() {
    final data = _shoppingBox.keys.map((key) {
      final value = _shoppingBox.get(key);
      return {"key": key, "name": value["name"], "quantity": value['quantity']};
    }).toList();

    setState(() {
      _items = data.reversed.toList();
      // we use "reversed" to sort items in order from the latest to the oldest
    });
  }

  // Create new item
  Future<void> _createItem(Map<String, dynamic> newItem) async {
    await _shoppingBox.add(newItem);
    _refreshItems(); // update the UI
  }

  // Retrieve a single item from the database by using its key
  // Our app won't use this function but I put it here for your reference
  Map<String, dynamic> _readItem(int key) {
    final item = _shoppingBox.get(key);
    return item;
  }

  // Update a single item
  Future<void> _updateItem(int itemKey, Map<String, dynamic> item) async {
    await _shoppingBox.put(itemKey, item);
    _refreshItems(); // Update the UI
  }

  // Delete a single item
  Future<void> _deleteItem(int itemKey) async {
    await _shoppingBox.delete(itemKey);
    _refreshItems(); // update the UI

    // Display a snackbar
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An item has been deleted')));
  }

  // TextFields' controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showFormDialog(BuildContext ctx, int? itemKey) async {
    // itemKey == null -> create new item
    // itemKey != null -> update an existing item

    if (itemKey != null) {
      final existingItem =
          _items.firstWhere((element) => element['key'] == itemKey);
      _nameController.text = existingItem['name'];
      _quantityController.text = existingItem['quantity'];
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
                    controller: _nameController,
                    decoration: const InputDecoration(hintText: 'Name'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'Quantity'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      // Save new item
                      if (itemKey == null &&
                          _nameController.text.isNotEmpty &&
                          _quantityController.text.isNotEmpty) {
                        _createItem({
                          "name": _nameController.text,
                          "quantity": _quantityController.text
                        });
                      }

                      // update an existing item
                      if (itemKey != null &&
                          _nameController.text.isNotEmpty &&
                          _quantityController.text.isNotEmpty) {
                        _updateItem(itemKey, {
                          'name': _nameController.text.trim(),
                          'quantity': _quantityController.text.trim()
                        });
                      }

                      // Clear the text fields
                      _nameController.text = '';
                      _quantityController.text = '';

                      Navigator.of(context).pop(); // Close the bottom sheet
                    },
                    child: Text(itemKey == null ? 'Create New' : 'Update'),
                  ),
                  const SizedBox(height: 15)
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: _items.isEmpty
          ? const Center(
              child: Text(
                'No Data',
                style: TextStyle(fontSize: 30),
              ),
            )
          : ListView.builder(
              // the list of items
              itemCount: _items.length,
              itemBuilder: (_, index) {
                final currentItem = _items[index];
                return Card(
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.black54, width: 1.0),
                      borderRadius: BorderRadius.circular(8)),
                  color: Colors.white,
                  margin: const EdgeInsets.all(10),
                  elevation: 2,
                  child: ListTile(
                    title: Text(currentItem['name']),
                    subtitle: Text(currentItem['quantity'].toString()),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Edit button
                        IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () =>
                                _showFormDialog(context, currentItem['key'])),
                        // Delete button
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteItem(currentItem['key']),
                        ),
                      ],
                    ),
                  ),
                );
              }),
      // Add new item button
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFormDialog(context, null),
        child: const Icon(Icons.add),
      ),
    );
  }
}