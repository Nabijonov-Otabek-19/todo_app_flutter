import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/data/model/todo_model.dart';
import 'package:todo_app/notification/notification_service.dart';
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

      List<String> time = existingItem.time.split(':');
      final hour = int.parse(time[0]);
      final minute = int.parse(time[1]);

      context.read<AddProvider>().setDate(DateTime.parse(existingItem.date));
      context
          .read<AddProvider>()
          .setTime(TimeOfDay(hour: hour, minute: minute));
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
    final read = context.read<AddProvider>();
    final watch = context.watch<AddProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.itemKey == null ? 'Add Task' : 'Edit Task',
        ),
      ),
      body: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
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
                              labelText: convertDate(watch.dateTime),
                              fillColor: Colors.white,
                              filled: true,
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.calendar_month),
                                onPressed: () async {
                                  read.selectDate(context);
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
                              labelText:
                                  "${watch.timeOfDay.hour}:${watch.timeOfDay.minute}",
                              fillColor: Colors.white,
                              filled: true,
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.watch_later_outlined),
                                onPressed: () async {
                                  read.selectTime(context);
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
                    final date = read.getDate();
                    final time = read.getTime();

                    if (widget.itemKey == null &&
                        title.isNotEmpty &&
                        description.isNotEmpty &&
                        categ.isNotEmpty) {
                      final newItem = TodoModel(
                        title: title,
                        description: description,
                        category: categ,
                        date: date.toIso8601String(),
                        time: "${time.hour}:${time.minute}",
                        isDone: false,
                      );
                      read.createItem(newItem);
                      await NotificationService.scheduleNotification(
                        1,
                        title,
                        description,
                        read.combineDateTimeAndTimeOfDay(),
                      );

                      //NotificationService.showInstantNotification(title, description);

                      if (context.mounted) Navigator.pop(context);
                    } else if (widget.itemKey != null &&
                        title.isNotEmpty &&
                        description.isNotEmpty &&
                        categ.isNotEmpty) {
                      final newItem = TodoModel(
                        title: title,
                        description: description,
                        category: categ,
                        date: date.toIso8601String(),
                        time: "${time.hour}:${time.minute}",
                        isDone: false,
                      );

                      read.updateItem(widget.itemKey!, newItem);

                      await NotificationService.scheduleNotification(
                        1,
                        title,
                        description,
                        read.combineDateTimeAndTimeOfDay(),
                      );

                      if (context.mounted) Navigator.pop(context);
                    } else {
                      toast("Fill the blank");
                    }
                  },
                  style: ButtonStyle(
                    minimumSize: const WidgetStatePropertyAll(
                      Size(double.infinity, 54),
                    ),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  child: Text(
                    widget.itemKey == null ? 'Create task' : 'Update task',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String convertDate(DateTime date) {
    // Format the DateTime to "dd.mm.yyyy" format
    String formattedDate = DateFormat('dd.MM.yyyy').format(date);
    return formattedDate;
  }
}
