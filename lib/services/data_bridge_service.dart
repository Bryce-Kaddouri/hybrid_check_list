import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hybrid_check_list/services/firestore_service.dart';
import 'package:hybrid_check_list/services/sql_service.dart';

import '../models/task.dart';

class DataBridge {
  final FirestoreService firestoreDataProvider;
  final DatabaseHelper sqfliteDataProvider;

  DataBridge(this.firestoreDataProvider, this.sqfliteDataProvider);

  Future<List<Task>> fetchTodoItems() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      print('fetchTodoItems from firestore');
      // If there's an internet connection, fetch data from Firestore
      return firestoreDataProvider.getTasks();
    } else {
      print('fetchTodoItems from sqflite');
      // If there's no internet connection, fetch data from Sqflite
      return sqfliteDataProvider.tasks();
    }
  }

  Future<void> insertTask(Task task) async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      // If there's an internet connection, insert data to Firestore
      firestoreDataProvider.insertTask(task);
    } else {
      // If there's no internet connection, insert data to Sqflite
      sqfliteDataProvider.insertTask(task);
    }
  }

  Future<void> updateTask(Task task) async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      // If there's an internet connection, update data to Firestore
      firestoreDataProvider.updateTask(task);
    } else {
      // If there's no internet connection, update data to Sqflite
      sqfliteDataProvider.updateTask(task);
    }
  }

  Future<void> deleteTask(Task task) async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      // If there's an internet connection, delete data from Firestore
      firestoreDataProvider.deleteTask(task.id);
    } else {
      // If there's no internet connection, delete data from Sqflite
      sqfliteDataProvider.deleteTask(task.id);
    }
  }
}
