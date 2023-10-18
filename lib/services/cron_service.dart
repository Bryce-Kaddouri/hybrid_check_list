import 'package:style_cron_job/style_cron_job.dart';
import '../models/task.dart';
import 'connectivity_service.dart';

import 'firestore_service.dart';
import 'sql_service.dart';
import 'secure_storage_service.dart';
import 'dart:async';
import 'sql_service.dart';
import 'firestore_service.dart';

enum CronStatus { running, stopped }

enum Case {
  insertSqlite,
  updateSqlite,
  deleteSqlite,
  insertFirestore,
  updateFirestore,
  deleteFirestore
}

class CronService {
  static void syncTasks() async {
    final tasksFromFireStore = await FirestoreService().getTasks();

    final DatabaseHelper databaseHelper = DatabaseHelper.instance;
    await databaseHelper.initDatabase();

    final tasksFromSqlite = await databaseHelper.tasks();

    // compare tasks from firestore and sqlite
    List<Task> tasksToBeInsertedToSqlite = [];
    List<Task> tasksToBeUpdatedToSqlite = [];
    List<Task> tasksToBeDeletedFromSqlite = [];

    List<Task> tasksToBeInsertedToFirestore = [];
    List<Task> tasksToBeUpdatedToFirestore = [];
    List<Task> tasksToBeDeletedFromFirestore = [];

    for (Task taskFromFireStore in tasksFromFireStore) {
      bool isTaskFound = false;
      for (Task taskFromSqlite in tasksFromSqlite) {
        if (taskFromFireStore.id == taskFromSqlite.id) {
          isTaskFound = true;
          if (taskFromFireStore.updatedAt > taskFromSqlite.updatedAt) {
            tasksToBeUpdatedToSqlite.add(taskFromFireStore);
          }
          break;
        }
      }
      if (!isTaskFound) {
        tasksToBeInsertedToSqlite.add(taskFromFireStore);
      }
    }

    for (Task taskFromSqlite in tasksFromSqlite) {
      bool isTaskFound = false;
      for (Task taskFromFireStore in tasksFromFireStore) {
        if (taskFromSqlite.id == taskFromFireStore.id) {
          isTaskFound = true;
          if (taskFromSqlite.updatedAt > taskFromFireStore.updatedAt) {
            tasksToBeUpdatedToFirestore.add(taskFromSqlite);
          }
          break;
        }
      }
      if (!isTaskFound) {
        tasksToBeDeletedFromSqlite.add(taskFromSqlite);
      }
    }

    print('tasksToBeInsertedToSqlite : $tasksToBeInsertedToSqlite');
    print('tasksToBeUpdatedToSqlite : $tasksToBeUpdatedToSqlite');
    print('tasksToBeDeletedFromSqlite : $tasksToBeDeletedFromSqlite');

    print('tasksToBeInsertedToFirestore : $tasksToBeInsertedToFirestore');
    print('tasksToBeUpdatedToFirestore : $tasksToBeUpdatedToFirestore');
    print('tasksToBeDeletedFromFirestore : $tasksToBeDeletedFromFirestore');

    // check last status of internet that is stored in secure storage
    print('tasks from firestore : $tasksFromFireStore');
    print('tasks from sqlite : $tasksFromSqlite');

    if (tasksToBeInsertedToSqlite.isNotEmpty) {
      for (Task task in tasksToBeInsertedToSqlite) {
        await databaseHelper.insertTask(task);
      }
    } else if (tasksToBeUpdatedToSqlite.isNotEmpty) {
      for (Task task in tasksToBeUpdatedToSqlite) {
        await databaseHelper.updateTask(task);
      }
    } else if (tasksToBeDeletedFromSqlite.isNotEmpty) {
      for (Task task in tasksToBeDeletedFromSqlite) {
        await databaseHelper.deleteTask(task.id);
      }
    } else if (tasksToBeInsertedToFirestore.isNotEmpty) {
      for (Task task in tasksToBeInsertedToFirestore) {
        await FirestoreService().insertTask(task);
      }
    } else if (tasksToBeUpdatedToFirestore.isNotEmpty) {
      for (Task task in tasksToBeUpdatedToFirestore) {
        await FirestoreService().updateTask(task);
      }
    } else if (tasksToBeDeletedFromFirestore.isNotEmpty) {
      for (Task task in tasksToBeDeletedFromFirestore) {
        await FirestoreService().deleteTask(task.id);
      }
    }
  }

  static void init() async {
    var stream = each.minute.fromNowOn().asStream();
    syncTasks();
// eg starting 00:10:38
    stream.listen((time) {
      syncTasks();
      // Do on each minute on 38. second
      print('cron job running');
    });
  }
}
