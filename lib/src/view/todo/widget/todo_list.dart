import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_vimigo/src/model/todo_model.dart';

class TodoList extends StatefulWidget {
  TodoList({Key? key}) : super(key: key);

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<TodoModel> todoList = [
    TodoModel(title: "Clients"),
    TodoModel(title: "Designer"),
    TodoModel(title: "Developer"),
    TodoModel(title: "Director"),
    TodoModel(title: "Employee"),
    TodoModel(title: "Manager"),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // todoList.add()
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      // https://api.flutter.dev/flutter/material/ReorderableListView-class.html
      child: ReorderableListView.builder(
        header: Card(
          child: ListTile(
            title: Text('Add New Todos'),
            trailing:
                IconButton(onPressed: () {}, icon: Icon(Icons.add_box_rounded)),
          ),
        ),
        itemBuilder: (BuildContext context, int i) {
          return ListTile(
            key: ValueKey(i),
            title: Text(todoList[i].title ?? ''),
            subtitle: Text(todoList[i].description ?? ''),
            trailing:
                IconButton(onPressed: () {}, icon: Icon(Icons.add_box_rounded)),
          );
        },
        itemCount: todoList.length,
        onReorder: (oldKey, newKey) {
          setState(() {
            if (newKey > oldKey) {
              newKey -= 1;
            }
            final items = todoList.removeAt(oldKey);
            todoList.insert(newKey, items);
          });
          // print(jsonEncode({k, v}));
        },
      ),
    );
  }
}
