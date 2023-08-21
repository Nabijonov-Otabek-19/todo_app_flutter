import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/data/model2/todo_model2.dart';
import 'package:todo_app/presentation/screen/home/home_provider.dart';
import 'package:todo_app/utils/constants.dart';

import 'home_provider2.dart';

class HomeScreen2 extends StatefulWidget {
  const HomeScreen2({super.key});

  @override
  State<HomeScreen2> createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen2> {
  late final Box<TodoModel2> box;

  @override
  void initState() {
    super.initState();
    box = Hive.box<TodoModel2>(dbName);
  }

  @override
  void dispose() {
    box.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: ValueListenableBuilder(
          valueListenable: box.listenable(),
          builder: (context, items, child) {
            List<int> keys = items.keys.cast<int>().toList();

            return keys.isEmpty
                ? const Center(
                    child: Text(
                      'No Data',
                      style: TextStyle(fontSize: 30),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: keys.length,
                    itemBuilder: (_, index) {
                      final int key = keys[index];
                      final TodoModel2 data = items.get(key) ??
                          TodoModel2(title: "", description: "");
                      return Card(
                        shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                color: Colors.black54, width: 1.0),
                            borderRadius: BorderRadius.circular(8)),
                        color: Colors.white,
                        margin: const EdgeInsets.all(10),
                        elevation: 2,
                        child: ListTile(
                          title: Text(data.title),
                          subtitle: Text(data.description),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Edit button
                              IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => {
                                        context
                                            .read<HomeProvider2>()
                                            .showFormDialog(context, key)
                                      }),
                              // Delete button
                              IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => {
                                        context
                                            .read<HomeProvider2>()
                                            .deleteItem(key, context),
                                      }),
                            ],
                          ),
                        ),
                      );
                    });
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            context.read<HomeProvider2>().showFormDialog(context, null),
        child: const Icon(Icons.add),
      ),
    );
  }
}
