import 'package:hive/hive.dart';

part 'todo_model2.g.dart';

@HiveType(typeId: 0)
class TodoModel2 {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String description;

  TodoModel2({required this.title, required this.description});
}
