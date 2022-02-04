import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:todo_vimigo/src/controller/todo_controller.dart';

class TodoAdd extends StatefulWidget {
  const TodoAdd({Key? key}) : super(key: key);

  @override
  State<TodoAdd> createState() => _TodoAddState();
}

class _TodoAddState extends State<TodoAdd> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool loading = false;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Add'),
        actions: [
          IconButton(
            onPressed: () async {
              _formKey.currentState?.save();
              // print(_formKey.currentState?.value['title']);
              var formData = _formKey.currentState?.value;
              if (_formKey.currentState!.validate()) {
                setState(() {
                  loading = true;
                });

                await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return _buildAlertDialog(formData);
                    });
              }
            },
            icon: loading
                ? const SizedBox(
                    height: 25,
                    child: CircularProgressIndicator.adaptive(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.lime),
                    ),
                  )
                : const Icon(Icons.save),
          ),
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
                  decoration: InputDecoration(
                    labelText: 'Date',
                    border: const OutlineInputBorder(),
                  ),
                ),
                FormBuilderCheckbox(
                  // onChanged: (value) =>
                  initialValue: false,
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

  AlertDialog _buildAlertDialog(formData) {
    return AlertDialog(
      title: Text(
        'Add to calender Event?',
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            _formKey.currentState?.fields['addtocalender']?.didChange(true);
            var formData = _formKey.currentState?.value;
            _formKey.currentState?.save();
            await Add2Calendar.addEvent2Cal(
              Event(
                title: _formKey.currentState?.fields['title']?.value,
                description:
                    _formKey.currentState?.fields['description']?.value,
                location: 'Vimigo',
                startDate: _formKey.currentState?.fields['datepicker']?.value,
                endDate: _formKey.currentState?.fields['datepicker']?.value
                    .add(Duration(minutes: 30)),
                allDay: false,
                iosParams: IOSParams(
                  reminder: Duration(minutes: 40),
                ),
                androidParams: AndroidParams(
                  emailInvites: ["test@example.com"],
                ),
              ),
            ).then((value) {
              print(value);
              if (value) {
                TodoController.addTodo(formData).then(
                  (value) {
                    setState(() {
                      loading = false;
                    });
                    Navigator.pop(context);
                  },
                );
              }
            });
          },
          child: Text('Yes'),
        ),
        ElevatedButton(
          onPressed: () => TodoController.addTodo(formData).then(
            (value) {
              setState(() {
                loading = false;
              });
              Navigator.pop(context);
            },
          ),
          child: Text('No'),
        ),
      ],
    );
  }

  SizedBox _spacer10() {
    return SizedBox(
      height: 10,
    );
  }
}
