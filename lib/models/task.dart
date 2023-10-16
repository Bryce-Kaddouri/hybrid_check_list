// models/task.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final String title;
  final String description;
  bool isCompleted = false;

  Task(this.id, this.createdAt, this.updatedAt, this.title, this.description,
      this.isCompleted);

  Task.fromMap(Map<String, dynamic> data, String id)
      : this(
          id,
          data['createdAt'],
          data['updatedAt'],
          data['title'],
          data['description'],
          data['isCompleted'],
        );

  Map<String, dynamic> toMap() => {
        'id': id,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'title': title,
        'description': description,
        'isCompleted': isCompleted,
      };

  @override
  String toString() {
    return 'Task{id: $id, createdAt: $createdAt, updatedAt: $updatedAt, title: $title, description: $description, isCompleted: $isCompleted}';
  }
}
