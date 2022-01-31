import 'package:flutter/material.dart';

class TodoAdd extends StatelessWidget {
  const TodoAdd({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Add'),
      ),
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}
