import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/data/model/todo_model.dart';
import 'package:todo_app/presentation/screen/add/add_provider.dart';

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
  final String category = "";
  final String date = "";
  final String time = "";

  @override
  void initState() {
    if (widget.itemKey != null) {
      final existingItem =
          context.read<AddProvider>().readItem(widget.itemKey!)!;
      titleController.text = existingItem.title;
      descriptionController.text = existingItem.description;
      categoryController.text = existingItem.category;
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
        title: Text(widget.itemKey == null ? 'Add Todo' : 'Edit Todo'),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Title
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
              const SizedBox(height: 24),
              // create button
              FilledButton(
                onPressed: () async {
                  final title = titleController.text.toString().trim();
                  final description =
                      descriptionController.text.toString().trim();
                  final categ = categoryController.text.toString().trim();

                  if (widget.itemKey == null &&
                      title.isNotEmpty &&
                      description.isNotEmpty &&
                      categ.isNotEmpty) {
                    final newItem = TodoModel(
                      title: title,
                      description: description,
                      category: categ,
                      date: date,
                      time: time,
                      isDone: false,
                    );
                    context.read<AddProvider>().createItem(newItem);
                  } else if (widget.itemKey != null &&
                      title.isNotEmpty &&
                      description.isNotEmpty &&
                      categ.isNotEmpty) {
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
                  }

                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                  minimumSize: const MaterialStatePropertyAll(
                    Size(double.infinity, 48),
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
    );
  }
}
