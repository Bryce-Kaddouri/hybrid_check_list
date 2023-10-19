// import cloud firestore
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hybrid_check_list/models/task.dart';
import 'package:hybrid_check_list/services/sql_service.dart';
import '../firebase_options.dart';

// ...

class FirestoreService {
  static FirebaseFirestore? _db;

  static FirebaseFirestore get db {
    _db ??= FirebaseFirestore.instance;
    return _db!;
  }

  Future<List<Task>> getTasks() async {
    print('getTasks from firestore');
    final data = await db.collection('tasks').get();
    List<Task> tasks = data.docs.map((doc) {
      int id = int.parse(doc.id);
      Timestamp createdAt = doc['createdAt'];
      int createdAtInt = createdAt.millisecondsSinceEpoch;
      Timestamp updatedAt = doc['updatedAt'];
      int updatedAtInt = updatedAt.millisecondsSinceEpoch;
      String title = doc['title'];
      String description = doc['description'];
      bool isCompleted = doc['isCompleted'];
      print('from firestore :');
      print('id : $id');
      print('createdAt : $createdAt');
      print('createdAtInt : $createdAtInt');

      print('updatedAt : $updatedAt');
      print('title : $title');
      print('description : $description');
      print('isCompleted : $isCompleted');

      return Task(
        int.parse(doc.id),
        createdAtInt,
        updatedAtInt,
        doc['title'],
        doc['description'],
        doc['isCompleted'],
      );
    }).toList();
    print('tasks from firestore : $tasks');
    return tasks;
  }

  insertTask(Task task) {
    print('insertTask to firestore');
    db.collection('tasks').doc(task.id.toString()).set(task.toMapFireStore());
  }

  updateTask(Task task) {
    print('updateTask to firestore');
    Map<String, dynamic> taskMap = task.toMapFireStore();
    print('taskMap : $taskMap');
    db.collection('tasks').doc(task.id.toString()).update(taskMap);
  }

  deleteTask(int id) {
    print('deleteTask to firestore');
    db.collection('tasks').doc(id.toString()).delete();
  }
}
