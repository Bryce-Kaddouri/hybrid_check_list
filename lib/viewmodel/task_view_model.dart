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
    // check if has internet
    if (await ConnectivityService().hasInternet) {
      // fetch tasks from firestore
      tasks = await FirestoreService().getTasks();
      notifyListeners(); // Notify listeners to rebuild the UI
    } else {
      // fetch tasks from sqlite
      tasks = SqlService.getTasks();
      // notifyListeners(); // Notify listeners to rebuild the UI
    }

    notifyListeners(); // Notify listeners to rebuild the UI
  }

  void toggleTaskCompletion(int index) {
    tasks[index].isCompleted = !tasks[index].isCompleted;
    notifyListeners(); // Notify listeners to rebuild the UI
  }
}
