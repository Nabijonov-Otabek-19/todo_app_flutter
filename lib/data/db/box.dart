import 'package:hive/hive.dart';
import 'package:todo_app/data/model/todo_model.dart';
import 'package:todo_app/utils/constants.dart';

class Database {
  static Box box = Hive.box<TodoModel>(dbName);
}
