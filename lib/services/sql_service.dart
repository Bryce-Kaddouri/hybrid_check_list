// // import 'dart:ffi';
// // import 'dart:io';
// //
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:hybrid_check_list/models/task.dart';
// // import 'package:sqlite3/sqlite3.dart';
// //
// // class SqlService {
// //   void initDB() {
// //     final scriptDir = File(Platform.script.toFilePath()).parent;
// //     final dbPath = scriptDir.path + '/db.sqlite';
// //     print('dbPath : $dbPath');
// //     // Create a table and insert some data
// //     /*db.execute('''
// //     CREATE TABLE tasks (
// //         id TEXT NOT NULL PRIMARY KEY,
// //         createdAt TEXT,
// //         updatedAt TEXT,
// //         title TEXT,
// //         description TEXT,
// //         isCompleted INTEGER
// //     );
// //   ''');*/
// //     /*Task task =
// //         Task('1', Timestamp.now(), Timestamp.now(), 'test', 'test desc', false);
// //     insertTask([task]);*/
// //
// //     print('DB initialized');
// //   }
// //
// //   void insertTask(List<Task> tasks) {
// //     final db = sqlite3.openInMemory();
// //
// //     // Prepare a statement to run it multiple times:
// //     final stmt = db.prepare(
// //         'INSERT INTO tasks (id, createdAt, updatedAt, title, description, isCompleted) VALUES (?, ?, ?, ?, ?, ?)');
// //     for (final task in tasks) {
// //       stmt.execute([
// //         task.id,
// //         task.createdAtFormatted,
// //         task.updatedAtFormatted,
// //         task.title,
// //         task.description,
// //         task.isCompleted ? 1 : 0,
// //       ]);
// //     }
// //     print('Inserted ${tasks.length} rows');
// //
// //     // Dispose a statement when you don't need it anymore to clean up resources.
// // /*
// //     stmt.dispose();
// // */
// //   }
// //
// //   List<Task> getTasks() {
// //     List<Task> tasks = [];
// //     final db = sqlite3.openInMemory();
// //
// //     final ResultSet resultSet = db.select('SELECT * FROM tasks;');
// //
// //     for (final Row row in resultSet) {
// //       Task task = Task(
// //         row['id'] as String,
// //         Timestamp.fromDate(DateTime.parse(row['createdAt'] as String)),
// //         Timestamp.fromDate(DateTime.parse(row['updatedAt'] as String)),
// //         row['title'] as String,
// //         row['description'] as String,
// //         row['isCompleted'] == 1 ? true : false,
// //       );
// //       tasks.add(task);
// //     }
// //
// //     print('getTasks : $tasks');
// //
// //     return tasks;
// //   }
// // }
//
// import 'dart:async';
//
// import 'package:flutter/widgets.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
// import '../models/task.dart';
//
// class SqlService {
//   Future<Database>? database;
//
//   initDB() async {
//     database = openDatabase(
//       // Set the path to the database. Note: Using the `join` function from the
//       // `path` package is best practice to ensure the path is correctly
//       // constructed for each platform.
//       join(await getDatabasesPath(), 'doggie_database.db'),
//       // When the database is first created, create a table to store dogs.
//       onCreate: (db, version) {
//         // Run the CREATE TABLE statement on the database.
//         return db.execute(
//           """CREATE TABLE tasks (
//          id TEXT NOT NULL PRIMARY KEY,
//          createdAt TEXT,
//          updatedAt TEXT,
//          title TEXT,
//          description TEXT,
//          isCompleted INTEGER
//      );""",
//         );
//       },
//       // Set the version. This executes the onCreate function and provides a
//       // path to perform database upgrades and downgrades.
//       version: 1,
//     );
//   }
//
//   Future<void> insertTask(Task task) async {
//     // Get a reference to the database.
//     final Database db = await database!;
//
//     // Insert the Task into the correct table. Also specify the
//     // `conflictAlgorithm`. In this case, if the same task is inserted
//     // multiple times, it replaces the previous data.
//     await db.insert(
//       'tasks',
//       task.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }
//
//   Future<List<Task>> tasks() async {
//     // Get a reference to the database.
//     final Database db = await database!;
//
//     // Query the table for all The Tasks.
//     final List<Map<String, dynamic>> maps = await db.query('tasks');
//
//     // Convert the List<Map<String, dynamic> into a List<Task>.
//     return List.generate(maps.length, (i) {
//       return Task(
//         maps[i]['id'],
//         maps[i]['createdAt'],
//         maps[i]['updatedAt'],
//         maps[i]['title'],
//         maps[i]['description'],
//         maps[i]['isCompleted'] == 1 ? true : false,
//       );
//     });
//   }
//
//   Future<void> updateTask(Task task) async {
//     // Get a reference to the database.
//     final db = await database!;
//
//     // Update the given Task.
//     await db.update(
//       'tasks',
//       task.toMap(),
//       // Ensure that the Task has a matching id.
//       where: "id = ?",
//       // Pass the Task's id as a whereArg to prevent SQL injection.
//       whereArgs: [task.id],
//     );
//   }
//
//   Future<void> deleteTask(String id) async {
//     // Get a reference to the database.
//     final db = await database!;
//
//     // Remove the Task from the database.
//     await db.delete(
//       'tasks',
//       // Use a `where` clause to delete a specific task.
//       where: "id = ?",
//       // Pass the Task's id as a whereArg to prevent SQL injection.
//       whereArgs: [id],
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

import '../models/task.dart';

class DatabaseHelper {
  DatabaseHelper._(); // Private constructor to prevent accidental instantiation
  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    io.Directory applicationDirectory =
        await getApplicationDocumentsDirectory();

    String dbPathEnglish =
        path.join(applicationDirectory.path, "englishDictionary.db");
    print("dbPathEnglish : $dbPathEnglish");

    bool dbExistsEnglish = await io.File(dbPathEnglish).exists();
    print("dbExistsEnglish : $dbExistsEnglish");

    if (!dbExistsEnglish) {
      // Copy from asset
      ByteData data =
          await rootBundle.load(path.join("assets/db", "eng_dictionary.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await io.File(dbPathEnglish).writeAsBytes(bytes, flush: true);
    }
    int second = Timestamp.now().seconds;
    Timestamp timestamp = Timestamp.fromMillisecondsSinceEpoch(second * 1000);
    print('timestamp : ${timestamp.toDate()}');

    return await openDatabase(
      dbPathEnglish,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE tasks (
          id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
          createdAt INTEGER NOT NULL,
          updatedAt INTEGER NOT NULL,
          title TEXT NOT NULL,
          description TEXT,
          isCompleted INTEGER NOT NULL
      );
        ''');
      },
    );
  }

  Future<void> insertTask(Task task) async {
    final Database db = await database!;

    await db.insert(
      'tasks',
      task.toMapSqlite(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

//
  Future<List<Task>> tasks() async {
//     // Get a reference to the database.
    final Database db = await database!;
//
//     // Query the table for all The Tasks.
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    List<Task> tasks = [];
//
//     // Convert the List<Map<String, dynamic> into a List<Task>.

    for (final map in maps) {
      for (var key in map.keys) {
        print('$key : ${map[key].runtimeType}, value : ${map[key]}');
      }
      Task task = Task(
        map['id'],
        map['createdAt'],
        map['updatedAt'],
        map['title'],
        map['description'],
        map['isCompleted'] == 1 ? true : false,
      );
      tasks.add(task);
    }

    return tasks;
    /*List.generate(maps.length, (i) {
      return Task(
        maps[i]['id'],
        Timestamp.now().seconds,
        Timestamp.now().seconds,
        maps[i]['title'],
        maps[i]['description'],
        maps[i]['isCompleted'] == 1 ? true : false,
      );
    });*/
  }

//
  Future<void> updateTask(Task task) async {
//     // Get a reference to the database.
    final db = await database!;
//
    // Update the given Task.
    await db.update(
      'tasks',
      task.toMapSqlite(),
      // Ensure that the Task has a matching id.
      where: "id = ?",
//       // Pass the Task's id as a whereArg to prevent SQL injection.
      whereArgs: [task.id],
    );
  }

//
  Future<void> deleteTask(int id) async {
//     // Get a reference to the database.
    final db = await database!;
//
//     // Remove the Task from the database.
    await db.delete(
      'tasks',
//       // Use a `where` clause to delete a specific task.
      where: "id = ?",
//       // Pass the Task's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

// Your CRUD operations (e.g., insert, query, update, delete) go here
}
