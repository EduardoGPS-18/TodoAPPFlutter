import 'package:flutter/material.dart';

import '../../../models/task/task_model.dart';
import '../../shared/components/cards/task_card.dart';

class TaskListView extends StatelessWidget {
  final bool? isLoading;
  final List<TaskModel>? tasks;
  final void Function(TaskModel task)? onTap;
  final void Function(TaskModel, bool?)? onTaskCompletedClick;

  const TaskListView({
    Key? key,
    this.tasks,
    this.isLoading,
    this.onTap,
    this.onTaskCompletedClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Builder(builder: (context) {
          if (tasks != null) {
            return ListView.builder(
              itemCount: tasks?.length,
              itemBuilder: (ctx, index) => TaskCard(
                task: tasks?[index],
                onTap: () => onTap?.call(tasks![index]),
                onTaskCompletedClick: (completed) => onTaskCompletedClick?.call(tasks![index], completed),
                isLoading: isLoading,
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
      ),
    );
  }
}
