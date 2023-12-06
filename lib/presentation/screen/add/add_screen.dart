import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/data/model/todo_model.dart';
import 'package:todo_app/presentation/screen/add/add_provider.dart';
import 'package:todo_app/utils/output_utils.dart';

class AddScreen extends StatefulWidget {
  final int? itemKey;

  const AddScreen({super.key, required this.itemKey});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  @override
  void initState() {
    if (widget.itemKey != null) {
      final existingItem =
          context.read<AddProvider>().readItem(widget.itemKey!)!;
      titleController.text = existingItem.title;
      descriptionController.text = existingItem.description;
      categoryController.text = existingItem.category;

      context.read<AddProvider>().setDate(existingItem.date);
      context.read<AddProvider>().setTime(existingItem.time);
    }
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.itemKey == null ? 'Add Task' : 'Edit Task'),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    "Title",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextField(
                  controller: titleController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: "Title",
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Description
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    "Description",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextField(
                  controller: descriptionController,
                  keyboardType: TextInputType.text,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "Description",
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Category
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    "Category",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextField(
                  controller: categoryController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: "Category",
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Date and Time picker
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Date picker
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              "Date",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          TextField(
                            canRequestFocus: false,
                            enableInteractiveSelection: false,
                            decoration: InputDecoration(
                              labelText: context.watch<AddProvider>().date,
                              fillColor: Colors.white,
                              filled: true,
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.calendar_month),
                                onPressed: () async {
                                  context
                                      .read<AddProvider>()
                                      .selectDate(context);
                                },
                              ),
                              suffixIconColor: Colors.blueAccent,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Time picker
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              "Time",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          TextField(
                            canRequestFocus: false,
                            enableInteractiveSelection: false,
                            decoration: InputDecoration(
                              labelText: context.watch<AddProvider>().time,
                              fillColor: Colors.white,
                              filled: true,
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.watch_later_outlined),
                                onPressed: () async {
                                  context
                                      .read<AddProvider>()
                                      .selectTime(context);
                                },
                              ),
                              suffixIconColor: Colors.blueAccent,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Create button
                FilledButton(
                  onPressed: () async {
                    final title = titleController.text.toString().trim();
                    final description =
                        descriptionController.text.toString().trim();
                    final categ = categoryController.text.toString().trim();
                    final date = context.read<AddProvider>().getDate();
                    final time = context.read<AddProvider>().getTime();

                    if (widget.itemKey == null &&
                        title.isNotEmpty &&
                        description.isNotEmpty &&
                        categ.isNotEmpty &&
                        date.isNotEmpty &&
                        time.isNotEmpty) {
                      final newItem = TodoModel(
                        title: title,
                        description: description,
                        category: categ,
                        date: date,
                        time: time,
                        isDone: false,
                      );
                      context.read<AddProvider>().createItem(newItem);

                      Navigator.of(context).pop();
                    } else if (widget.itemKey != null &&
                        title.isNotEmpty &&
                        description.isNotEmpty &&
                        categ.isNotEmpty &&
                        date.isNotEmpty &&
                        time.isNotEmpty) {
                      final newItem = TodoModel(
                        title: title,
                        description: description,
                        category: categ,
                        date: date,
                        time: time,
                        isDone: false,
                      );

                      context
                          .read<AddProvider>()
                          .updateItem(widget.itemKey!, newItem);

                      Navigator.of(context).pop();
                    } else {
                      toast("Fill the blank");
                    }
                  },
                  style: ButtonStyle(
                    minimumSize: const MaterialStatePropertyAll(
                      Size(double.infinity, 54),
                    ),
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  child: Text(
                      widget.itemKey == null ? 'Create task' : 'Update task'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
