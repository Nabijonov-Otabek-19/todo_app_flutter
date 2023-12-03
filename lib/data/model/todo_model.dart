import 'package:hive/hive.dart';

part 'todo_model.g.dart';

@HiveType(typeId: 0)
class TodoModel {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String description;
  @HiveField(2)
  final String category;
  @HiveField(3)
  final String date;
  @HiveField(4)
  final String time;
  @HiveField(5)
  final bool isDone;

  TodoModel({
    required this.title,
    required this.description,
    required this.category,
    required this.date,
    required this.time,
    required this.isDone,
  });
}
