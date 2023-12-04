import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../../../data/model/todo_model.dart';

class AddProvider extends ChangeNotifier {
  final Box _box;

  AddProvider(this._box);

  String date = "dd.mm.yyyy";
  String time = "hh:mm";

  Future<void> createItem(TodoModel newItem) async {
    await _box.add(newItem);
    notifyListeners();
  }

  Future<void> updateItem(int itemKey, TodoModel item) async {
    await _box.put(itemKey, item);
    notifyListeners();
  }

  TodoModel? readItem(int key) {
    final item = _box.get(key);
    return item;
  }

  String getDate() => date;

  void setDate(String d) async {
    date = d;
  }

  String getTime() => time;

  void setTime(String t) async {
    time = t;
  }

  selectTime(BuildContext context) async {
    TimeOfDay selectedTime = TimeOfDay.now();
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked != null) {
      time = "${picked.hour}:${picked.minute}";
      notifyListeners();
    }
  }

  selectDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );

    if (picked != null) {
      // Format the DateTime to "dd.mm.yyyy" format
      String formattedDate = DateFormat('dd.MM.yyyy').format(picked);
      date = formattedDate;
      notifyListeners();
    }
  }
}
