import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../../data/model/todo_model.dart';

class AddProvider extends ChangeNotifier {
  final Box _box;

  AddProvider(this._box);

  DateTime dateTime = DateTime.now();
  TimeOfDay timeOfDay = TimeOfDay.now();

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

  DateTime getDate() => dateTime;

  void setDate(DateTime d) async {
    dateTime = d;
  }

  TimeOfDay getTime() => timeOfDay;

  void setTime(TimeOfDay t) async {
    timeOfDay = t;
  }

  void selectTime(BuildContext context) async {
    TimeOfDay selectedTime = TimeOfDay.now();
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked != null) {
      timeOfDay = picked;
      notifyListeners();
    }
  }

  DateTime combineDateTimeAndTimeOfDay() {
    return DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );
  }

  void selectDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );

    if (picked != null) {
      dateTime = picked;
      notifyListeners();
    }
  }
}
