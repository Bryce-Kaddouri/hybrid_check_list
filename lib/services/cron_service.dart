import 'package:style_cron_job/style_cron_job.dart';
import 'connectivity_service.dart';

import 'firestore_service.dart';
import 'sql_service.dart';
import 'secure_storage_service.dart';
import 'dart:async';
import 'sql_service.dart';
import 'firestore_service.dart';

class CronService {
  static void syncTasks() async {
    final tasksFromFireStore = await FirestoreService().getTasks();
    final dataFromFirestore =
        tasksFromFireStore.map((task) => task.toMap()).toList();
/*
    final dataFromSqlite = SqlService.getTasks();
*/
    // check last status of internet that is stored in secure storage
    print('data from firestore : $dataFromFirestore');
/*
    print('data from sqlite : $dataFromSqlite');
*/

    /*String? connectivity =
        await SecureStorageService().readSecureData('connectivity');
    if (connectivity == null) {
      // write connectivity status to secure storage
      if (await ConnectivityService().hasInternet) {
        SecureStorageService().writeSecureData('connectivity', 'connected');
      } else {
        SecureStorageService().writeSecureData('connectivity', 'disconnected');
      }
    } else {
      if (connectivity == 'connected') {
        // sync tasks from sqlite to firestore
        FirestoreService().syncTasks();
      } else {
        // sync tasks from firestore to sqlite
        SqlService().syncTasks();
      }
    }*/

    print('connectivity data : test');
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
