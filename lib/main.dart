import 'package:flutter/material.dart';
import 'package:todo_vimigo/src/view/todo/index.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo List Vimigo',
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      home: Todo(),
      routes: {
        '/home': (BuildContext context) => Todo(),
      },
    );
  }
}
