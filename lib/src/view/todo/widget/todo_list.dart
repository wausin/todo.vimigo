import 'dart:convert';

import 'package:flutter/material.dart';

class TodoList extends StatefulWidget {
  TodoList({Key? key}) : super(key: key);

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<String> item = [
    "Clients",
    "Designer",
    "Developer",
    "Director",
    "Employee",
    "Manager",
    "Worker",
    "Owner"
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
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
            title: Text(item[i]),
            trailing:
                IconButton(onPressed: () {}, icon: Icon(Icons.add_box_rounded)),
          );
        },
        itemCount: item.length,
        onReorder: (oldKey, newKey) {
          setState(() {
            if (newKey > oldKey) {
              newKey -= 1;
            }
            final items = item.removeAt(oldKey);
            item.insert(newKey, items);
          });
          // print(jsonEncode({k, v}));
        },
      ),
    );
  }
}
