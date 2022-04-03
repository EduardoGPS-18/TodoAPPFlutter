import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../models/task/task_model.dart';

class TaskCard extends StatelessWidget {
  final VoidCallback? onTap;
  final TaskModel? task;
  final void Function(bool?)? onTaskCompletedClick;
  final bool? isLoading;

  const TaskCard({
    Key? key,
    this.onTap,
    this.task,
    this.onTaskCompletedClick,
    this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedHour = task!.endDate.hour > 9 ? task?.endDate.hour : '0${task?.endDate.hour}';
    final formattedMinute = task!.endDate.minute > 9 ? task?.endDate.minute : '0${task?.endDate.minute}';
    return Card(
      elevation: 8,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      task?.title ?? '',
                      style: const TextStyle(fontSize: 20, overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        DateFormat('dd MMM yy').format(task?.endDate ?? DateTime.now()),
                        style: const TextStyle(fontSize: 10),
                      ),
                      Text(
                        '${formattedHour}h$formattedMinute',
                        style: const TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      task?.subtitle ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  isLoading == true
                      ? Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                          child: const SizedBox(child: CircularProgressIndicator(), height: 12, width: 12),
                        )
                      : Checkbox(
                          value: task?.completed,
                          onChanged: onTaskCompletedClick,
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
