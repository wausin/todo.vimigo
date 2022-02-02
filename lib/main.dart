import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_vimigo/src/model/todo_model.dart';
import 'package:todo_vimigo/src/view/todo/index.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(TodoModelAdapter());
  await Hive.openBox<TodoModel>('todo_model');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo List Vimigo',
      // theme: ThemeData(
      //     colorScheme:
      //         ColorScheme.fromSwatch().copyWith(secondary: Colors.amber)),
      home: const Todo(),
      routes: {
        '/home': (BuildContext context) => Todo(),
      },
    );
  }
}
