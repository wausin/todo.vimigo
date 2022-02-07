import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:loader_overlay/src/overlay_controller_widget_extension.dart';
import 'package:todo_vimigo/src/controller/todo_controller.dart';
import 'package:todo_vimigo/src/model/app_setting_model.dart';
import 'package:todo_vimigo/src/model/todo_model.dart';
import 'package:todo_vimigo/src/view/todo/widget/todo_add_v2.dart';
import 'package:todo_vimigo/src/view/todo/widget/todo_edit.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class TodoList extends StatefulWidget {
  const TodoList({Key? key, required this.appSeting}) : super(key: key);
  final AppSettingModel? appSeting;
  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final DateFormat formatter = DateFormat.yMMMd().add_jms();
  bool loading = false;

  late TutorialCoachMark tutorialCoachMark;

  late List<TargetFocus> targets = [];

  GlobalKey addNewTodo = GlobalKey();
  // GlobalKey welcomeTour = GlobalKey();
  @override
  void dispose() {
    Hive.box('todo_model').close();
    super.dispose();
  }

  @override
  void initState() {
    _initTargetMark();
    WidgetsBinding.instance?.addPostFrameCallback(_startGuided);
    super.initState();
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
          // todoList.sort((a, b) => b.id!.compareTo(a.id ?? 0));
          return _buildReorderableList(todoList);
          // return _buildReorderableList(todoList);
        },
      ),
    );
  }

  ReorderableListView _buildReorderableList(List<TodoModel> todoList) {
    return ReorderableListView.builder(
      // key: welcomeTour,
      // reverse: true,
      buildDefaultDragHandles: false,
      header: Card(
        child: ListTile(
          // dense: true,
          key: addNewTodo,
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
        return ReorderableDelayedDragStartListener(
          key: ValueKey(todoList[i]),
          index: i,
          child: Card(
            color: Colors.black.withOpacity(0.6),
            child: ListTile(
              // dense: true,
              title: _titleButton(todoList, i),
              subtitle: _subtitleButton(todoList, i),
              leading: _dragButton(),
              // delete todo
              trailing: SizedBox(
                width: 100,
                // height: 100,
                child: Row(
                  // buttonMinWidth: 100,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _editButton(context, todoList, i),
                    _deleteButton(context, todoList, i),
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

  Text _titleButton(List<TodoModel> todoList, int i) {
    return Text(
      todoList[i].title ?? '',
      style: const TextStyle(color: Colors.white),
    );
  }

  Text _subtitleButton(List<TodoModel> todoList, int i) {
    return Text(
      (todoList[i].description ?? '') +
          '\n' +
          (todoList[i].date != null
              ? formatter.format(todoList[i].date ?? DateTime.now())
              : ''),
      style: const TextStyle(color: Colors.white),
    );
  }

  IconButton _dragButton() {
    return IconButton(
      alignment: Alignment.centerLeft,
      iconSize: 18,
      padding: const EdgeInsets.all(2),
      onPressed: () {},
      icon: const Icon(
        Icons.reorder_sharp,
        color: Colors.white,
      ),
    );
  }

  IconButton _editButton(
      BuildContext context, List<TodoModel> todoList, int i) {
    return IconButton(
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
    );
  }

  IconButton _deleteButton(
      BuildContext context, List<TodoModel> todoList, int i) {
    return IconButton(
      alignment: Alignment.centerRight,
      iconSize: 18,
      padding: const EdgeInsets.all(2),
      onPressed: () async {
        context.loaderOverlay.show();
        setState(() {
          loading = context.loaderOverlay.visible;
        });
        await TodoController.deleteTodo(todoList[i]).then((value) {
          if (loading) {
            context.loaderOverlay.hide();
          }
          setState(() {
            loading = context.loaderOverlay.visible;
          });
        });
      },
      icon: const Icon(
        Icons.delete_outline_outlined,
        color: Colors.white,
      ),
    );
  }

  void showTutorial() {
    TutorialCoachMark(
      context,
      targets: targets, // List<TargetFocus>
      // colorShadow: Colors.black,
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.8,
      onClickTarget: (target) {
        print(target);
      },
      onClickOverlay: (target) {
        print(target);
        // target.
      },
      onSkip: () {
        print("skip");
      },
      onFinish: () {
        // print("finish");
        var j = widget.appSeting;
        j?.addInitialData = true;
        j?.save();
      },
    )..show();
  }

  void _initTargetMark() {
    targets.add(
      TargetFocus(
        identify: "Add New Todo",
        keyTarget: addNewTodo,
        shape: ShapeLightFocus.RRect,
        radius: 5,
        contents: [
          TargetContent(
            // align: ContentAlign.left,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Create new todo",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Click plus icon to Get Started!.",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void _startGuided(_) {
    Future.delayed(Duration(milliseconds: 1000));
    var j = widget.appSeting;
    // print((j?.isGuidedList));

    // bool? isGuided = j?.isGuidedList;
    // if (isGuided) {
    showTutorial();
    // }
  }
}
