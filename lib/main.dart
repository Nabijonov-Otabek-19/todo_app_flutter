import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/data/model/todo_model.dart';
import 'package:todo_app/presentation/screen/splash/splash_screen.dart';
import 'package:todo_app/utils/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Hive.initFlutter();
  Hive.registerAdapter(TodoModelAdapter());
  await Hive.openBox<TodoModel>(dbName);

  // When some error occurs,
  // screen will show custom error widget, not red screen
  ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Error"),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: Colors.red,
                size: 100,
              ),
              Text(
                kReleaseMode
                    ? "Oops... something went wrong"
                    : errorDetails.exception.toString(),
              ),
            ],
          ),
        ),
      ),
    );
  };

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
          iconTheme: IconThemeData(color: Colors.white),
        ),
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const SplashScreen(),
    );
  }
}
