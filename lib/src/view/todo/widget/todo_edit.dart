import 'package:flutter/material.dart';

class TodoEdit extends StatelessWidget {
  const TodoEdit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Edit'),
      ),
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}
