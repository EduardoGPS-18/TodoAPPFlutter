import 'package:flutter/material.dart';

import '../../models/info/info_model.dart';
import '../../models/task/task_model.dart';
import '../../models/user/user_model.dart';
import 'home_presenter.dart';
import 'views/other_tasks_view.dart';
import 'views/profile_view.dart';

class HomePage extends StatefulWidget {
  final HomePresenter presenter;

  const HomePage({
    Key? key,
    required this.presenter,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    widget.presenter.getUserTasks();
    widget.presenter.offAllNavigatorNotifier.addListener(() async {
      final navArguments = widget.presenter.offAllNavigatorNotifier.value;
      if (navArguments != null && navArguments.route.isNotEmpty == true) {
        Navigator.of(context).pushNamedAndRemoveUntil(navArguments.route, (_) => false);
      }
    });
    widget.presenter.navigatorNotifier.addListener(() async {
      final navArguments = widget.presenter.navigatorNotifier.value;
      if (navArguments != null && navArguments.route.isNotEmpty == true) {
        final result = await Navigator.of(context).pushNamed(navArguments.route, arguments: navArguments.arguments);
        if (result is TaskModel) {
          widget.presenter.addOrUpdateTaskOnList(result);
        }
      }
    });
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<UserModel>(
      future: widget.presenter.currentUser,
      builder: (_, userSnapshot) => ValueListenableBuilder<int>(
        valueListenable: widget.presenter.currentPageNotifier,
        builder: (context, currentPage, child) => Scaffold(
          appBar: AppBar(
            elevation: 8,
            title: Text('Olá, bem vindo ${userSnapshot.data?.name.split(' ')[0].split('@')[0] ?? 'Carregando...'}'),
            bottom: currentPage == 0
                ? TabBar(
                    controller: tabController,
                    tabs: const [
                      Tab(text: 'Tarefas hoje'),
                      Tab(text: 'Outras tarefas'),
                    ],
                  )
                : null,
            actions: [
              IconButton(
                onPressed: widget.presenter.logout,
                icon: const Icon(Icons.exit_to_app),
              ),
            ],
          ),
          body: currentPage == 0
              ? ValueListenableBuilder<List<TaskModel>?>(
                  valueListenable: widget.presenter.tasksNotifier,
                  builder: (ctx, tasks, child) => ValueListenableBuilder<bool?>(
                    valueListenable: widget.presenter.loadintNotifier,
                    builder: (context, loading, child) => TabBarView(
                      controller: tabController,
                      children: [
                        tasks?.where((element) => element.isToday).isEmpty == true
                            ? const Center(
                                child: Text('Você não possui tasks cadastradas para hoje!'),
                              )
                            : TaskListView(
                                tasks: tasks?.where((element) => element.isToday).toList(),
                                onTap: loading == true ? null : widget.presenter.navigateToTaskDetails,
                                onTaskCompletedClick: loading == true ? null : widget.presenter.updateTaskCompleted,
                                isLoading: loading,
                              ),
                        tasks?.where((element) => !element.isToday).isEmpty == true
                            ? const Center(
                                child: Text('Você não possui outras tasks!'),
                              )
                            : TaskListView(
                                tasks: tasks?.where((element) => !element.isToday).toList(),
                                onTap: loading == true ? null : widget.presenter.navigateToTaskDetails,
                                onTaskCompletedClick: loading == true ? null : widget.presenter.updateTaskCompleted,
                                isLoading: loading,
                              ),
                      ],
                    ),
                  ),
                )
              : FutureBuilder<InfoModel?>(
                  future: widget.presenter.getUserInfo(),
                  builder: (ctx, infoSnap) {
                    return ProfileView(
                      currentUser: userSnapshot.data!,
                      infoModel: infoSnap.data,
                    );
                  },
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: widget.presenter.navigateToTaskDetails,
            child: const Icon(Icons.add),
          ),
          bottomNavigationBar: BottomNavigationBar(
            onTap: widget.presenter.changeCurrentPage,
            currentIndex: currentPage,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.task_alt_rounded), label: 'Tarefas'),
              BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Perfil'),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
