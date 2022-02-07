import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:todo_vimigo/src/model/todo_model.dart';
// import 'package:todo_vimigo/src/view/todo/widget/todo_list.dart';

class TodoController {
  static Box<TodoModel> getTodo() => Hive.box<TodoModel>('todo_model');

  static Future addTodo(dynamic formData, {bool addTocalender = false}) async {
    // final todo = TodoModel(title: title);
    final getTodo = TodoController.getTodo();

    // print(formData);
    TodoModel todo = TodoModel(
      id: getTodo.length + 1,
      title: formData['title'],
      description: formData['description'] ?? '',
      date: formData['datepicker'],
      addtocalender: addTocalender,
    );
    await Future.delayed(const Duration(milliseconds: 1000));
    // print(getTodo.length);
    // add new todo
    await getTodo.add(todo);

//     // get latest todo
//     List<TodoModel> newList = getTodo.values.toList().cast<TodoModel>();

// // make new list for reverse list
//     List<TodoModel> revList = newList.reversed.toList();
//     // delete old list
//     for (int i = 0; i < newList.length; i++) {
//       var e = newList[i];
//       await e.delete();
//     }

//     await getTodo.addAll(revList);
    // print(jsonEncode(revList.reversed));
  }

  static Future editTodo(TodoModel todo, dynamic formData) async {
    todo.title = formData['title'];
    todo.description = formData['description'] ?? '';
    todo.date = formData['datepicker'];
    todo.addtocalender = formData['addtocalender'];
    await Future.delayed(const Duration(milliseconds: 1000));
    await todo.save();
  }

  static Future deleteTodo(TodoModel todo) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    await todo.delete();
  }

// static Future
  static Future updateTodoKey(
      List<TodoModel> todoList, int oldKey, int newKey) async {
    // List<TodoModel> todoListrev = todoList.reversed.toList();
    // print([newKey, oldKey]);
    if (newKey > oldKey) {
      newKey -= 1;
    }

    print([newKey, oldKey]);
    final items = todoList.removeAt(oldKey);
    // todoList.elementAt(oldKey).id = newKey;
    // todoList.elementAt(newKey).id = oldKey;
    todoList.insert(newKey, items);

// // ready for new list
    var todoAddnew = todoList;
// // delete old list
    for (int i = 0; i < todoList.length; i++) {
      var e = todoList[i];
      print(e.key);
      e.delete();

      // if (todoAddnew[i].id == oldKey) {
      //   todoAddnew[i].id = newKey;
      //   print(todoAddnew[i].id);
      // }
    }

// // get todo box
    final getTodo = TodoController.getTodo();

//     // await Future.delayed(const Duration(milliseconds: 500));
// // add new list wit new key
    await getTodo.addAll(todoAddnew);
  }
}
