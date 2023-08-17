import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/presentation/screen/home/home_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().refreshItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<HomeProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: p.items.isEmpty
          ? const Center(
              child: Text(
                'No Data',
                style: TextStyle(fontSize: 30),
              ),
            )
          : ListView.builder(
              // the list of items
              itemCount: p.items.length,
              itemBuilder: (_, index) {
                final currentItem = p.items[index];
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
                            onPressed: () => {
                                  context.read<HomeProvider>().showFormDialog(
                                      context, currentItem['key'])
                                }),
                        // Delete button
                        IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => {
                                  context
                                      .read<HomeProvider>()
                                      .deleteItem(currentItem['key'], context),
                                }),
                      ],
                    ),
                  ),
                );
              }),
      // Add new item button
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            context.read<HomeProvider>().showFormDialog(context, null),
        child: const Icon(Icons.add),
      ),
    );
  }
}
