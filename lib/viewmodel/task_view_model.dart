// viewmodel/task_view_model.dart
import 'package:flutter/foundation.dart';
import 'package:hybrid_check_list/services/connectivity_service.dart';
import 'package:hybrid_check_list/services/data_bridge_service.dart';
import 'package:style_cron_job/style_cron_job.dart';
import '../models/task.dart';
import '../services/firestore_service.dart';
import '../services/sql_service.dart';

class TaskViewModel extends ChangeNotifier {
  List<Task> tasks = [];
  DataBridge dataBridge = DataBridge(
    FirestoreService(),
    DatabaseHelper.instance,
  );

  // Business logic to fetch tasks, update tasks, etc.
  void fetchTasks() async {
    dataBridge.fetchTodoItems().then((value) {
      print('fetchTasks from dataBridge');
      print('value : $value');
      tasks = value;
      notifyListeners(); // Notify listeners to rebuild the UI
    });
  }

  void toggleTaskCompletion(int index, bool isCompleted) {
    print('toooggg');
    Task task = tasks[index];
    task.isCompleted = task.isCompleted = isCompleted;
    print(task.toString());

    dataBridge.updateTask(task);
    notifyListeners(); // Notify listeners to rebuild the UI

    // Notify listeners to rebuild the UI
  }
}
