import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_vimigo/src/controller/todo_controller.dart';
import 'package:todo_vimigo/src/model/todo_model.dart';
import 'package:todo_vimigo/src/view/todo/widget/todo_add.dart';
import 'package:todo_vimigo/src/view/todo/widget/todo_edit.dart';

class TodoList extends StatefulWidget {
  TodoList({Key? key}) : super(key: key);

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  // https://www.bezkoder.com/dart-list/
  // List<TodoModel> todoList = [
  //   TodoModel(title: "Clients"),
  //   TodoModel(title: "Designer"),
  //   TodoModel(title: "Developer"),
  //   TodoModel(title: "Director"),
  //   TodoModel(title: "Employee"),
  //   TodoModel(title: "Manager"),
  // ];

  @override
  void dispose() {
    Hive.box('todo_model').close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      // https://api.flutter.dev/flutter/material/ReorderableListView-class.html
      child: ValueListenableBuilder<Box<TodoModel>>(
          valueListenable: TodoController.getTodo().listenable(),
          builder: (context, todo, _) {
            final todoList = todo.values.toList().cast<TodoModel>();
            // print(todoList[0].title);
            return _buildReorderableList(todoList);
          }),
    );
  }

  ReorderableListView _buildReorderableList(List<TodoModel> todoList) {
    return ReorderableListView.builder(
      buildDefaultDragHandles: false,
      header: Card(
        child: ListTile(
          // dense: true,
          title: Text('Add New Todos'),
          trailing: IconButton(
              onPressed: () {
                // TodoController().addTodo(TodoModel(title: "Designer"));
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TodoAdd()),
                );
              },
              icon: Icon(Icons.add_box_rounded)),
        ),
      ),
      itemBuilder: (context, i) {
        // print(todoList[i].id);
        return ReorderableDragStartListener(
          key: ValueKey(todoList[i]),
          index: i,
          child: ListTile(
            title: Text(todoList[i].title ?? ''),
            subtitle: Text(todoList[i].description ?? ''),
            leading: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TodoEdit()),
                  );
                },
                icon: Icon(Icons.edit_outlined)),
            trailing: IconButton(
                onPressed: () {}, icon: Icon(Icons.delete_outline_outlined)),
          ),
        );
      },
      itemCount: todoList.length,
      onReorder: (oldKey, newKey) {
        TodoController.updateTodoKey(todoList, oldKey, newKey);
      },
    );
  }
}
