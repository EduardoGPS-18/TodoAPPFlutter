import 'package:flutter/material.dart';

import '../../repository/task/task_repository.dart';
import '../../repository/user/user_repository.dart';
import '../helpers/states/button_state.dart';
import '../helpers/validator/min_length_validator.dart';

class TaskDetailsPresenter {
  final taskRepository = TaskRepository();
  final userRepository = UserRepository();

  String? taskId;
  void setTaskId(String taskId) => this.taskId = taskId;

  String title = '';
  final titleErrorNotifier = ValueNotifier<String>('');
  void setTitle(String title) => this.title = title;
  void validateTitle(String title) {
    if (!hasMinLength(value: title, size: 6)) {
      titleErrorNotifier.value = 'Titulo inválido!';
    } else {
      titleErrorNotifier.value = '';
      buttonStateNotifier.value = buttonStateNotifier.value.copyWith(isValid: true);
    }
    this.title = title;
  }

  String subtitle = '';
  void setSubtitle(String subtitle) => this.subtitle = subtitle;

  String description = '';
  void setDescription(String description) => this.description = description;

  DateTime? date;
  void setDate(DateTime date) => this.date = date;

  TimeOfDay? time;
  void setTime(TimeOfDay time) => this.time = time;

  final navigatorPopNotifier = ValueNotifier<dynamic>(null);

  final completedNotifier = ValueNotifier<bool?>(false);
  void switchCompleted(bool? completed) => completedNotifier.value = completed;

  final buttonStateNotifier = ValueNotifier<ButtonState>(ButtonState(isLoading: false, isValid: false));
  Future<void> addOrUpdateTask() async {
    navigatorPopNotifier.value = null;
    buttonStateNotifier.value = buttonStateNotifier.value.copyWith(isLoading: true);
    final user = await userRepository.getLocalUser();
    if (taskId != null) {
      final task = await taskRepository.updateTask(
        id: taskId!,
        token: user?.token ?? '',
        title: title,
        subtitle: subtitle,
        description: description,
        endDate: date,
        completed: completedNotifier.value,
      );
      navigatorPopNotifier.value = task;
    } else {
      final task = await taskRepository.createTask(
        token: user?.token ?? '',
        title: title,
        subtitle: subtitle,
        description: description,
        endDate: date,
        completed: completedNotifier.value,
      );
      navigatorPopNotifier.value = task;
    }
  }
}
