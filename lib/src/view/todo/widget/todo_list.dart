// import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_vimigo/src/controller/todo_controller.dart';
import 'package:todo_vimigo/src/model/todo_model.dart';
import 'package:todo_vimigo/src/view/todo/widget/todo_add.dart';
import 'package:todo_vimigo/src/view/todo/widget/todo_add_v2.dart';
import 'package:todo_vimigo/src/view/todo/widget/todo_edit.dart';

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final DateFormat formatter = DateFormat.yMMMd().add_jms();
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

          // if (todoList.isNotEmpty) {
          Future.delayed(const Duration(seconds: 2));

          return _buildReorderableList(todoList.reversed.toList());
        },
      ),
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
                  MaterialPageRoute(
                    // builder: (context) => TodoAdd(),
                    builder: (context) => TodoAddV2(),
                  ),
                );
              },
              icon: Icon(Icons.add_box_rounded)),
        ),
      ),
      itemBuilder: (context, i) {
        // print(todoList[i].date?.toIso8601String());
        // print(todoList[i].id);
        // return Card(
        //   key: ValueKey(todoList[i]),
        //   child: ListTile(
        //     // dense: true,
        //     title: Text(todoList[i].title ?? ''),
        //     subtitle: Text((todoList[i].description ?? '') +
        //         '\n' +
        //         (todoList[i].date != null
        //             ? formatter.format(todoList[i].date ?? DateTime.now())
        //             : '')),
        //     leading: ReorderableDragStartListener(
        //       // key: ValueKey(todoList[i]),
        //       index: i,
        //       child: const Icon(Icons.reorder),
        //     ),
        //     // delete todo
        //     trailing: ButtonBar(
        //       children: [
        //         IconButton(
        //             onPressed: () {
        //               Navigator.push(
        //                 context,
        //                 MaterialPageRoute(
        //                   builder: (context) => TodoEdit(
        //                     todoEdit: todoList[i],
        //                   ),
        //                 ),
        //               );
        //             },
        //             icon: Icon(Icons.edit_outlined)),
        //         IconButton(
        //           onPressed: () async {
        //             TodoController.deleteTodo(todoList[i]);
        //           },
        //           icon: Icon(Icons.delete_outline_outlined),
        //         ),
        //       ],
        //     ),
        //   ),
        // );
        return ReorderableDelayedDragStartListener(
          key: ValueKey(todoList[i]),
          index: i,
          child: Card(
            color: Colors.black.withOpacity(0.6),
            child: ListTile(
              // dense: true,
              title: Text(
                todoList[i].title ?? '',
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                (todoList[i].description ?? '') +
                    '\n' +
                    (todoList[i].date != null
                        ? formatter.format(todoList[i].date ?? DateTime.now())
                        : ''),
                style: const TextStyle(color: Colors.white),
              ),
              leading: IconButton(
                alignment: Alignment.centerLeft,
                iconSize: 18,
                padding: const EdgeInsets.all(2),
                onPressed: () {},
                icon: const Icon(
                  Icons.reorder_sharp,
                  color: Colors.white,
                ),
              ),
              // delete todo
              trailing: SizedBox(
                width: 100,
                // height: 100,
                child: Row(
                  // buttonMinWidth: 100,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      alignment: Alignment.centerRight,
                      iconSize: 18,
                      padding: const EdgeInsets.all(2),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TodoEdit(
                              todoEdit: todoList[i],
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      alignment: Alignment.centerRight,
                      iconSize: 18,
                      padding: const EdgeInsets.all(2),
                      onPressed: () async {
                        TodoController.deleteTodo(todoList[i]);
                      },
                      icon: const Icon(
                        Icons.delete_outline_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
