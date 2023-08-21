import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/data/model2/todo_model2.dart';
import 'package:todo_app/presentation/screen/home2/home_provider2.dart';
import 'package:todo_app/presentation/screen/home2/home_screen.dart';
import 'package:todo_app/utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(TodoModel2Adapter());
  await Hive.openBox<TodoModel2>(dbName);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo List',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: Colors.blue,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 22.0),
        ),
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: ChangeNotifierProvider(
        create: (context) => HomeProvider2(Hive.box<TodoModel2>(dbName)),
        builder: (context, child) => const HomeScreen2(),
      ),
    );
  }
}
