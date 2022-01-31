import 'package:flutter/material.dart';
import 'package:todo_vimigo/src/view/todo/widget/todo_list.dart';

class Todo extends StatelessWidget {
  const Todo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List Vimigo'),
      ),
      body: SafeArea(
        child: TodoList(),
      ),
    );
  }
}
