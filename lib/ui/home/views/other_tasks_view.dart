import 'package:flutter/material.dart';

import '../../../models/task/task_model.dart';
import '../../shared/components/cards/task_card.dart';

class TaskListView extends StatelessWidget {
  final bool? isLoading;
  final List<TaskModel>? tasks;
  final void Function(TaskModel)? onTap;
  final void Function(TaskModel)? onLongPress;
  final void Function(TaskModel, bool)? onDoublePressed;
  final void Function(TaskModel, bool?)? onTaskCompletedClick;

  const TaskListView({
    Key? key,
    this.tasks,
    this.onTap,
    this.isLoading,
    this.onLongPress,
    this.onDoublePressed,
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
                onLongPress: () => onLongPress?.call(tasks![index]),
                onDoubleTap: () => onDoublePressed?.call(tasks![index], !(tasks![index].completed)),
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
