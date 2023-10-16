import 'dart:ffi';
import 'dart:io';

import 'package:hybrid_check_list/models/task.dart';
import 'package:path/path.dart';
import 'package:sqlite3/open.dart';
import 'package:sqlite3/sqlite3.dart';

class SqlService {
  final db = sqlite3.openInMemory();

  void initDB() {
    db.execute('''
      CREATE TABLE tasks (
        id String PRIMARY KEY,
        createdAt String,
        updatedAt String,
        title String,
        description String,
        isCompleted INTEGER
      )
    ''');
    print('DB created');
  }

  void insert(String table, List<Map<String, dynamic>> data) {
    final stmt = db.prepare('''
      INSERT INTO $table (
        id,
        createdAt,
        updatedAt,
        title,
        description,
        isCompleted
      ) VALUES (?, ?, ?, ?, ?, ?)
    ''');

    for (final row in data) {
      stmt.execute([
        row['id'],
        row['createdAt'],
        row['updatedAt'],
        row['title'],
        row['description'],
        row['isCompleted'] ? 1 : 0,
      ]);
    }

    stmt.dispose();
  }

  List<Map<String, dynamic>> select(String table) {
    final stmt = db.prepare('SELECT * FROM $table');
    final result = stmt.select();
    stmt.dispose();

    return result;
  }

  static List<Task> getTasks() {
    List<Task> tasks = [];
    final db = sqlite3.openInMemory();
    final stmt = db.prepare('SELECT * FROM tasks');
    final result = stmt.select();
    for (final row in result) {
      tasks.add(Task(
        row['id'],
        row['createdAt'],
        row['updatedAt'],
        row['title'],
        row['description'],
        row['isCompleted'] == 1 ? true : false,
      ));
    }

    return tasks;
  }
}
