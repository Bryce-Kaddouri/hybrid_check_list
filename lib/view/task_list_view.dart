// view/task_list_view.dart
import 'package:flutter/material.dart';
import 'package:hybrid_check_list/view/widget/task_widget.dart';
import 'package:provider/provider.dart'; // If using the Provider package
import '../viewmodel/task_view_model.dart';

class TaskListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TaskViewModel>(context,
        listen: true); // Use Provider to access the ViewModel
    viewModel.fetchTasks();

    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
      ),
      body: ListView.builder(
        itemCount: viewModel.tasks.length,
        itemBuilder: (context, index) {
          final task = viewModel.tasks[index];
          return TaskWidget(
            task: task,
            index: index,
            viewModel: viewModel,
          );
          /*ListTile(
            title: Text(task.title),
            trailing: Checkbox(
              value: task.isCompleted,
              onChanged: (value) {
                viewModel.toggleTaskCompletion(index);
              },
            ),
          );*/
        },
      ),
    );
  }
}
