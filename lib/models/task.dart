// models/task.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Task {
  final int id;
  final int createdAt;
  final int updatedAt;
  final String title;
  final String description;
  bool isCompleted = false;

  Task(this.id, this.createdAt, this.updatedAt, this.title, this.description,
      this.isCompleted);

  Map<String, dynamic> toMapFireStore() => {
        'id': id,
        'createdAt': Timestamp.fromMillisecondsSinceEpoch(createdAt * 1000),
        'updatedAt': Timestamp.fromMillisecondsSinceEpoch(updatedAt * 1000),
        'title': title,
        'description': description,
        'isCompleted': isCompleted,
      };

  Map<String, dynamic> toMapSqlite() => {
        'id': id,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'title': title,
        'description': description,
        'isCompleted': isCompleted ? 1 : 0,
      };

  @override
  String toString() {
    return 'Task{id: $id, createdAt: $createdAt, updatedAt: $updatedAt, title: $title, description: $description, isCompleted: $isCompleted}';
  }
}
