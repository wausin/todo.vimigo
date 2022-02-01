import 'package:hive/hive.dart';

part 'todo_model.g.dart';

// hive tutorial
// https://www.youtube.com/watch?v=w8cZKm9s228
@HiveType(typeId: 0)
class TodoModel extends HiveObject {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? title;
  @HiveField(2)
  String? description;
  @HiveField(3)
  String? date;

  TodoModel({this.id, required this.title, this.description, this.date});
}
