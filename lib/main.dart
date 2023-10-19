import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hybrid_check_list/models/task.dart';
import 'package:hybrid_check_list/services/connectivity_service.dart';
import 'package:hybrid_check_list/services/cron_service.dart';
import 'package:hybrid_check_list/services/secure_storage_service.dart';
import 'package:hybrid_check_list/view/task_list_view.dart';
import 'package:hybrid_check_list/viewmodel/task_view_model.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:sqlite3/sqlite3.dart' as sql;

import 'package:hybrid_check_list/services/firestore_service.dart';
import 'package:hybrid_check_list/services/sql_service.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  ConnectivityService().hasInternetStream.listen((event) async {
    print('hasInternetStream : $event');
    if (await SecureStorageService().readSecureData('connectivity') == null) {
      print('secure storage is null');
      SecureStorageService().writeSecureData('connectivity', 'disconnected');
    } else {
      print('secure storage is not null');
      String? connection =
          await SecureStorageService().readSecureData('connectivity');
      print('connection fron secure storage $connection');
      print('connection from connectivity plus $event');

      if (connection == 'disconnected' && event == true) {
        CronService.syncTasks();
        SecureStorageService().writeSecureData('connectivity', 'connected');
      } else if (connection == 'connected' && event == false) {
        SecureStorageService().writeSecureData('connectivity', 'disconnected');
      }
    }
  });
  DatabaseHelper databaseHelper = DatabaseHelper.instance;
  await databaseHelper.initDatabase();

/*
  SqlService().initDB();
*/

  CronService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskViewModel(), // Provide the TaskViewModel
      child: MaterialApp(
        title: 'Task App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) =>
              TaskListView(), // Set the initial route to TaskListView
        },
      ),
    );
  }
}
