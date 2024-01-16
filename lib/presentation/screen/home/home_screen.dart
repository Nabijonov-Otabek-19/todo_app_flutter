import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/data/model/todo_model.dart';
import 'package:todo_app/presentation/screen/add/add_provider.dart';
import 'package:todo_app/presentation/screen/add/add_screen.dart';
import 'package:todo_app/presentation/widgets/message_display.dart';
import 'package:todo_app/presentation/widgets/todo_item_widget.dart';

import '../../../data/db/box.dart';
import 'home_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController scrollController = ScrollController();

  ChangeNotifier notifier = ChangeNotifier();
  ValueNotifier<int> notifier2 = ValueNotifier(0);

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ValueListenableBuilder(
          valueListenable: Database.box.listenable(),
          builder: (context, items, child) {
            List<int> keys = items.keys.cast<int>().toList();

            List<int> doneItems = items.keys
                .cast<int>()
                .where((el) => items.get(el).isDone == true)
                .toList();

            List<int> unDoneItems = items.keys
                .cast<int>()
                .where((el) => items.get(el).isDone == false)
                .toList();

            print("Done items = ${doneItems.length}");
            print("UnDone items = ${unDoneItems.length}");

            if (keys.isEmpty) {
              return const MessageDisplay(message: "Empty list");
            } else {
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Upcoming task
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: Text(
                        "Upcoming : ${unDoneItems.length}",
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: unDoneItems.length,
                        itemBuilder: (context, index) {
                          final int key = unDoneItems[index];
                          final TodoModel todoModel = items.get(key) ??
                              TodoModel(
                                title: "",
                                description: "",
                                category: "",
                                date: "",
                                time: "",
                                isDone: false,
                              );
                          return TodoItemWidget(
                            todoModel: todoModel,
                            itemKey: key,
                            onEditClick: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChangeNotifierProvider(
                                    create: (context) =>
                                        AddProvider(Database.box),
                                    builder: (context, child) => AddScreen(
                                      itemKey: key,
                                    ),
                                  ),
                                ),
                              );
                            },
                            onDeleteClick: () {
                              context
                                  .read<HomeProvider>()
                                  .deleteItem(key, mounted);
                            },
                            onChangeClick: () {
                              context.read<HomeProvider>().updateItem(
                                  key,
                                  TodoModel(
                                    title: todoModel.title,
                                    description: todoModel.description,
                                    category: todoModel.category,
                                    date: todoModel.date,
                                    time: todoModel.time,
                                    isDone: true,
                                  ));
                            },
                          );
                        }),
                    // Completed task
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: Text(
                        "Completed : ${doneItems.length}",
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: doneItems.length,
                      itemBuilder: (context, index) {
                        final int key = doneItems[index];
                        final TodoModel todoModel = items.get(key) ??
                            TodoModel(
                              title: "",
                              description: "",
                              category: "",
                              date: "",
                              time: "",
                              isDone: false,
                            );
                        return TodoItemWidget(
                          todoModel: todoModel,
                          itemKey: key,
                          onEditClick: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChangeNotifierProvider(
                                  create: (context) =>
                                      AddProvider(Database.box),
                                  builder: (context, child) => AddScreen(
                                    itemKey: key,
                                  ),
                                ),
                              ),
                            );
                          },
                          onDeleteClick: () {
                            context
                                .read<HomeProvider>()
                                .deleteItem(key, mounted);
                          },
                          onChangeClick: () {
                            context.read<HomeProvider>().updateItem(
                                key,
                                TodoModel(
                                  title: todoModel.title,
                                  description: todoModel.description,
                                  category: todoModel.category,
                                  date: todoModel.date,
                                  time: todoModel.time,
                                  isDone: false,
                                ));
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider(
                create: (context) => AddProvider(Database.box),
                builder: (context, child) => const AddScreen(itemKey: null),
              ),
            ),
          );
          //context.read<HomeProvider>().showFormDialog(context, null);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
