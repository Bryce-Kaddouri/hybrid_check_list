// viewmodel/task_view_model.dart
import 'package:flutter/foundation.dart';
import 'package:hybrid_check_list/services/connectivity_service.dart';
import 'package:style_cron_job/style_cron_job.dart';
import '../models/task.dart';
import '../services/firestore_service.dart';
import '../services/sql_service.dart';

class TaskViewModel extends ChangeNotifier {
  List<Task> tasks = [];

  // Business logic to fetch tasks, update tasks, etc.
  void fetchTasks() async {
    if (await ConnectivityService().hasInternet) {
      tasks = await FirestoreService().getTasks();
    } else {
      final DatabaseHelper databaseHelper = DatabaseHelper.instance;

      tasks = await databaseHelper.tasks();
    }
/*
    notifyListeners(); // Notify listeners to rebuild the UI
*/
  }

  void toggleTaskCompletion(int index) {
    tasks[index].isCompleted = !tasks[index].isCompleted;
    notifyListeners(); // Notify listeners to rebuild the UI
  }
}
