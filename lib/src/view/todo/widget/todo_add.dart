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
                await TodoController.addTodo(formData).then(
                  (value) {
                    setState(() {
                      loading = false;
                    });
                    Navigator.pop(context);
                  },
                );
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

  SizedBox _spacer10() {
    return SizedBox(
      height: 10,
    );
  }
}
