import 'package:flutter/material.dart';

import '../../../models/info/info_model.dart';
import '../../../models/user/user_model.dart';
import '../../shared/components/texts/title_text.dart';

class ProfileView extends StatelessWidget {
  final UserModel currentUser;
  final InfoModel? infoModel;

  const ProfileView({
    Key? key,
    required this.currentUser,
    required this.infoModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TitleText(
            text: currentUser.name,
            fontSize: 32,
          ),
          const SizedBox(height: 32),
          CircleAvatar(
            child: Text(
              currentUser.name[0].toUpperCase(),
              style: const TextStyle(fontSize: 36),
            ),
            minRadius: 50,
          ),
          const SizedBox(height: 32),
          TitleText(
            text: currentUser.email,
            fontSize: 28,
          ),
          const SizedBox(height: 42),
          Text(
            infoModel == null
                ? 'Carregando...'
                : '${infoModel?.totalTasks ?? 0}/${infoModel?.completedTasks ?? 0} TAREFAS',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 20,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 42),
        ],
      ),
    );
  }
}
