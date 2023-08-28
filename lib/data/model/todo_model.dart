import 'package:hive/hive.dart';

part 'todo_model.g.dart';

@HiveType(typeId: 0)
class TodoModel {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String description;

  TodoModel({required this.title, required this.description});
}
