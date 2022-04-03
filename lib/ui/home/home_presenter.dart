import 'package:flutter/material.dart';

import '../../main.dart';
import '../../models/info/info_model.dart';
import '../../models/task/task_model.dart';
import '../../models/user/user_model.dart';
import '../../repository/task/task_repository.dart';
import '../../repository/user/user_repository.dart';
import '../helpers/navigation/navigation_arguments.dart';

class HomePresenter {
  final userRepository = UserRepository();
  final taskRepository = TaskRepository();

  UserModel? _currentUser;
  Future<UserModel> get currentUser async {
    if (_currentUser != null) return _currentUser!;
    _currentUser = (await userRepository.getLocalUser())!;
    return _currentUser!;
  }

  Future<InfoModel> getUserInfo() async {
    final token = (await currentUser).token;
    return taskRepository.getTasksInfo(token: token);
  }

  final tasksNotifier = ValueNotifier<List<TaskModel>?>(null);
  Future<void> getUserTasks() async {
    final tasks = await taskRepository.getTasksByToken(token: (await currentUser).token);
    tasks?.sort((t1, t2) => t1.id > t2.id ? 1 : -1);
    tasksNotifier.value = tasks;
  }

  void addOrUpdateTaskOnList(TaskModel task) {
    if (tasksNotifier.value?.map((e) => e.id).contains(task.id) == true) {
      tasksNotifier.value?.removeWhere((element) => element.id == task.id);
      final tasks = [...?tasksNotifier.value, task];
      tasksNotifier.value = tasks..sort((t1, t2) => t1.id > t2.id ? 1 : -1);
    } else {
      final tasks = [...?tasksNotifier.value, task];
      tasksNotifier.value = tasks..sort((t1, t2) => t1.id > t2.id ? 1 : -1);
    }
  }

  final loadintNotifier = ValueNotifier<bool?>(null);
  Future<void> updateTaskCompleted(TaskModel currentTask, bool? completed) async {
    final token = (await currentUser).token;
    final task = await taskRepository.updateTask(
      token: token,
      id: currentTask.id.toString(),
      title: currentTask.title,
      completed: completed,
      description: currentTask.description,
      endDate: currentTask.endDate,
      subtitle: currentTask.subtitle,
    );
    addOrUpdateTaskOnList(task);
  }

  final offAllNavigatorNotifier = ValueNotifier<NavigationArguments?>(null);
  void logout() {
    userRepository.removeLocalUser();
    offAllNavigatorNotifier.value = NavigationArguments(route: AppRoutes.loginPage);
  }

  final toDeleteTaskNotifier = ValueNotifier<TaskModel?>(null);
  void startDeleteTask(TaskModel task) {
    toDeleteTaskNotifier.value = task;
  }

  Future<void> confirmDeleteTask(TaskModel task) async {
    navigatorPopNotifier.value = null;
    final token = (await currentUser).token;
    await taskRepository.deleteTask(token: token, taskId: task.id.toString());
    navigatorPopNotifier.value = true;
    tasksNotifier.value?.removeWhere((element) => element.id == task.id);
    tasksNotifier.value = [...?tasksNotifier.value];
  }

  final currentPageNotifier = ValueNotifier<int>(0);
  void changeCurrentPage(int value) => currentPageNotifier.value = value;

  final navigatorNotifier = ValueNotifier<NavigationArguments?>(null);
  void navigateToTaskDetails([TaskModel? task]) {
    navigatorNotifier.value = null;
    navigatorNotifier.value = NavigationArguments(route: AppRoutes.taskDetailsPage, arguments: task);
  }

  final navigatorPopNotifier = ValueNotifier<bool?>(null);
  void navigatorPop() {
    navigatorPopNotifier.value = true;
  }
}
