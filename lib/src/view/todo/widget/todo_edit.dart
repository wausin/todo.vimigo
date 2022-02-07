import 'dart:io';

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:loader_overlay/src/overlay_controller_widget_extension.dart';
import 'package:todo_vimigo/src/controller/todo_controller.dart';
import 'package:todo_vimigo/src/model/todo_model.dart';

class TodoEdit extends StatefulWidget {
  const TodoEdit({Key? key, required this.todoEdit}) : super(key: key);

  final TodoModel todoEdit;
  @override
  State<TodoEdit> createState() => _TodoEditState();
}

class _TodoEditState extends State<TodoEdit> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool loading = false;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.todoEdit.addtocalender);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Edit'),
        actions: [
          _saveButton(context),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: FormBuilder(
            autovalidateMode: AutovalidateMode.always,
            key: _formKey,
            child: Column(
              children: [
                FormBuilderTextField(
                  initialValue: widget.todoEdit.title,
                  name: 'title',
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Title',
                    // errorText: 'lol',
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context,
                        errorText: 'required'),
                    // FormBuilderValidators.maxLength(context, 3,
                    //     errorText: 'not more than 3 letters'),
                  ]),
                ),
                _spacer10(),
                FormBuilderTextField(
                  initialValue: widget.todoEdit.description,
                  name: 'description',
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 4,
                ),
                _spacer10(),
                FormBuilderDateTimePicker(
                  initialValue: widget.todoEdit.date,
                  name: 'datepicker',
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2032),
                  decoration: InputDecoration(
                    labelText: 'Date',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _formKey.currentState!.fields['datepicker']
                            ?.didChange(null);
                      },
                    ),
                  ),
                ),
                FormBuilderCheckbox(
                  initialValue: widget.todoEdit.addtocalender,
                  name: 'addtocalender',
                  title: Text('Add to Calender'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconButton _saveButton(BuildContext context) {
    return IconButton(
      onPressed: () async {
        _formKey.currentState?.save();
        // print(_formKey.currentState?.value['title']);
        var formData = _formKey.currentState?.value;

        if (_formKey.currentState!.validate()) {
          context.loaderOverlay.show();
          setState(() {
            loading = context.loaderOverlay.visible;
          });

          await TodoController.editTodo(widget.todoEdit, formData).then(
            (value) async {
              if (loading) {
                context.loaderOverlay.hide();
              }
              setState(() {
                loading = context.loaderOverlay.visible;
              });

              bool checkBox =
                  _formKey.currentState?.fields['addtocalender']?.value;
              if (checkBox) {
                if (Platform.isAndroid) {
                  await Add2Calendar.addEvent2Cal(
                    Event(
                      title: _formKey.currentState?.fields['title']?.value,
                      description:
                          _formKey.currentState?.fields['description']?.value,
                      location: 'Vimigo',
                      startDate:
                          _formKey.currentState?.fields['datepicker']?.value,
                      endDate: _formKey
                          .currentState?.fields['datepicker']?.value
                          .add(const Duration(minutes: 30)),
                      allDay: false,
                      iosParams: const IOSParams(
                        reminder: Duration(minutes: 40),
                      ),
                      androidParams: const AndroidParams(
                        emailInvites: ["test@example.com"],
                      ),
                    ),
                  ).then((value) => Navigator.pop(context));
                } else {
                  Navigator.pop(context);
                }
              } else {
                if (loading) {
                  context.loaderOverlay.hide();
                }
                setState(() {
                  loading = context.loaderOverlay.visible;
                });
                Navigator.pop(context);
              }
            },
          );
        }
      },
      icon: const Icon(Icons.save),
    );
  }

  SizedBox _spacer10() {
    return SizedBox(
      height: 10,
    );
  }
}
