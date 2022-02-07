import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:todo_vimigo/src/controller/app_setting_controller.dart';
import 'package:todo_vimigo/src/controller/todo_controller.dart';
import 'package:todo_vimigo/src/model/app_setting_model.dart';
import 'package:todo_vimigo/src/view/todo/widget/todo_list.dart';

class Todo extends StatelessWidget {
  const Todo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      overlayColor: Colors.black,
      overlayOpacity: 0.8,
      child: ValueListenableBuilder<Box<AppSettingModel>>(
          valueListenable: AppSettingController.getApp().listenable(),
          builder: (context, box, _) {
            if (!box.containsKey(1)) {
              box.add(AppSettingModel(
                  isGuidedAdd: false,
                  addInitialData: false,
                  isGuidedList: false));
            }

            var bb = box.get(1);
            // print(box.containsKey(1));
            return Scaffold(
              appBar: AppBar(
                title: const Text('Todo List Vimigo'),
                automaticallyImplyLeading: false,
              ),
              body: SafeArea(
                child: TodoList(
                  appSeting: bb,
                ),
              ),
            );
          }),
    );
  }
}
