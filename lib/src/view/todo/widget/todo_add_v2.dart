import 'dart:io';

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:todo_vimigo/src/controller/todo_controller.dart';
import 'package:loader_overlay/loader_overlay.dart';

class TodoAddV2 extends StatefulWidget {
  const TodoAddV2({Key? key}) : super(key: key);

  @override
  State<TodoAddV2> createState() => _TodoAddV2State();
}

class _TodoAddV2State extends State<TodoAddV2> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool loading = false;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      overlayColor: Colors.black,
      overlayOpacity: 0.8,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Todo Add'),
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
                    name: 'title',
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Title',
                      // errorText: 'lol',
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context,
                          errorText: 'required'),
                      // FormBuilderValidators.maxLength(context, 3,
                      //     errorText: 'not more than 3 letters'),
                    ]),
                    // autovalidateMode: AutovalidateMode.always,
                    // maxLines: 4,
                  ),
                  _spacer10(),
                  FormBuilderTextField(
                    name: 'description',
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: const OutlineInputBorder(),
                    ),
                    maxLines: 4,
                  ),
                  _spacer10(),
                  FormBuilderDateTimePicker(
                    name: 'datepicker',
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2032),
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      border: OutlineInputBorder(),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context,
                          errorText: 'required'),
                      // FormBuilderValidators.maxLength(context, 3,
                      //     errorText: 'not more than 3 letters'),
                    ]),
                  ),
                  FormBuilderCheckbox(
                    // onChanged: (value) =>
                    initialValue: false,
                    name: 'addtocalender',
                    title: const Text('Add to Calender'),
                  ),
                ],
              ),
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
          await TodoController.addTodo(formData, addTocalender: true).then(
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

  AlertDialog _buildAlertDialog(formData) {
    return AlertDialog(
      title: const Text('Add to event Calender ?'),
      actions: [
        ElevatedButton.icon(
          onPressed: () async {
            context.loaderOverlay.show();
            setState(() {
              loading = context.loaderOverlay.visible;
            });
            await TodoController.addTodo(formData, addTocalender: true).then(
              (value) {
                if (loading) {
                  context.loaderOverlay.hide();
                }
                setState(() {
                  loading = context.loaderOverlay.visible;
                });
                Navigator.pushReplacementNamed(context, '/home');
              },
            );
          },
          icon: Icon(Icons.done_outline),
          label: Text('Yes'),
        ),
        ElevatedButton.icon(
          onPressed: () async {
            await TodoController.addTodo(formData).then(
              (value) {
                setState(() {
                  loading = false;
                });
                Navigator.pushNamed(context, '/home');
              },
            );
          },
          icon: Icon(Icons.cancel_sharp),
          label: Text('No'),
        )
      ],
    );
  }

  SizedBox _spacer10() {
    return SizedBox(
      height: 10,
    );
  }
}
