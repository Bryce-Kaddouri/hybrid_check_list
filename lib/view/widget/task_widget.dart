import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/task.dart';
import '../../viewmodel/task_view_model.dart';

class TaskWidget extends StatelessWidget {
  int index;
  Task task;
  TaskViewModel viewModel;
  TaskWidget(
      {super.key,
      required this.task,
      required this.index,
      required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
        margin: const EdgeInsets.all(16),
        elevation: 4,
        child: Container(
          height: 80,
          child: Row(
            children: [
              Checkbox(
                value: task.isCompleted,
                onChanged: (value) {
                  print('onChanged value : $value');
                  viewModel.toggleTaskCompletion(index, value!);
                },
              ),
              Expanded(
                child: Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
