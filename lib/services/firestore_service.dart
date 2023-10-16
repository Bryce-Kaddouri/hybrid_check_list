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

  static void init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  Future<List<Task>> getTasks() async {
    final data = await db.collection('tasks').get();
    List<Task> tasks =
        data.docs.map((doc) => Task.fromMap(doc.data(), doc.id)).toList();
    return tasks;
  }
}
