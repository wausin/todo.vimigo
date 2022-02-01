import 'package:hive/hive.dart';
import 'package:todo_vimigo/src/model/todo_model.dart';
// import 'package:todo_vimigo/src/view/todo/widget/todo_list.dart';

class TodoController {
  static Box<TodoModel> getTodo() => Hive.box<TodoModel>('todo_model');

  Future addTodo(TodoModel todo) async {
    // final todo = TodoModel(title: title);

    final getTodo = TodoController.getTodo();

    getTodo.add(todo);
  }
}
