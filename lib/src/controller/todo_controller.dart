import 'package:hive/hive.dart';
import 'package:todo_vimigo/src/model/todo_model.dart';
// import 'package:todo_vimigo/src/view/todo/widget/todo_list.dart';

class TodoController {
  static Box<TodoModel> getTodo() => Hive.box<TodoModel>('todo_model');

  static Future addTodo(dynamic formData) async {
    // final todo = TodoModel(title: title);
    final getTodo = TodoController.getTodo();

    TodoModel todo = TodoModel(
      id: getTodo.length + 1,
      title: formData['title'],
      description: formData['description'] ?? '',
      date: formData['date'] ?? '',
    );

    // print(getTodo.length);
    getTodo.add(todo);
  }

  static Future updateTodoKey(
      List<TodoModel> todoList, int oldKey, int newKey) async {
    if (newKey > oldKey) {
      newKey -= 1;
    }
    final items = todoList.removeAt(oldKey);
    todoList.insert(newKey, items);

// ready for new list
    var todoAddnew = todoList;
// delete old list
    for (int i = 0; i < todoList.length; i++) {
      var e = todoList[i];
      e.delete();
    }

// get todo box
    final getTodo = TodoController.getTodo();
// add new list wit new key
    getTodo.addAll(todoAddnew);
  }
}
