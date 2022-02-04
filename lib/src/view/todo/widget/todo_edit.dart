import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
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
          IconButton(
            onPressed: () async {
              _formKey.currentState?.save();
              // print(_formKey.currentState?.value['title']);
              var formData = _formKey.currentState?.value;
              setState(() {
                loading = true;
              });
              if (_formKey.currentState!.validate()) {
                await TodoController.editTodo(widget.todoEdit, formData).then(
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
                      // backgroundColor: Colors.white,
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

  SizedBox _spacer10() {
    return SizedBox(
      height: 10,
    );
  }
}
