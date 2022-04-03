import 'package:flutter/material.dart';

import '../../models/task/task_model.dart';
import '../helpers/states/button_state.dart';
import '../shared/components/button/primary_button_expanded.dart';
import '../shared/components/input/date_input.dart';
import '../shared/components/input/time_input.dart';
import '../shared/components/texts/title_text.dart';
import 'task_details_presenter.dart';

class TaskDetailsPage extends StatefulWidget {
  final TaskDetailsPresenter presenter;

  const TaskDetailsPage({
    Key? key,
    required this.presenter,
  }) : super(key: key);

  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  TaskModel? initialTaskState;
  @override
  void initState() {
    super.initState();
    widget.presenter.navigatorPopNotifier.addListener(() {
      final task = widget.presenter.navigatorPopNotifier.value;
      Navigator.of(context).pop(task);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final task = ModalRoute.of(context)?.settings.arguments;
    if (task != null && task is TaskModel) {
      initialTaskState = task;
      widget.presenter.setTaskId(task.id.toString());
      widget.presenter.switchCompleted(task.completed);
      widget.presenter.validateTitle(task.title);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detalhes da tarefa'),
        ),
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              fillOverscroll: false,
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const TitleText(text: 'Adicionar Tarefa'),
                    const SizedBox(height: 46),
                    ValueListenableBuilder<String>(
                      valueListenable: widget.presenter.titleErrorNotifier,
                      builder: (ctx, titleError, ch) => TextFormField(
                        onChanged: widget.presenter.validateTitle,
                        initialValue: initialTaskState?.title,
                        decoration: InputDecoration(
                          errorText: titleError.isNotEmpty ? titleError : null,
                          labelText: 'Titulo',
                          hintText: 'Ir no supermercado',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Spacer(),
                        Expanded(
                          flex: 4,
                          child: DateInput(
                            onChangedDateTime: widget.presenter.setDate,
                            initialDate: initialTaskState?.endDate,
                            decoration: const InputDecoration(
                              label: Text('Data'),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Expanded(
                          flex: 3,
                          child: TimeInput(
                            onChangedTime: widget.presenter.setTime,
                            initialTime:
                                initialTaskState != null ? TimeOfDay.fromDateTime(initialTaskState!.endDate) : null,
                            decoration: const InputDecoration(
                              label: Text('Hora'),
                            ),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      onChanged: widget.presenter.setSubtitle,
                      initialValue: initialTaskState?.subtitle,
                      decoration: const InputDecoration(
                        labelText: 'Subtitulo',
                        hintText: 'Comprar os items para almoço e para o jantar.',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      onChanged: widget.presenter.setDescription,
                      initialValue: initialTaskState?.description,
                      decoration: const InputDecoration(
                        labelText: 'Descrição',
                        hintText:
                            'Ir no supermercado comprar arroz, feijão, tomate, e peixe para o almoço, comprar carne moida e molho tomate para o jantar.',
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Row(
                          children: [
                            ValueListenableBuilder<bool?>(
                              valueListenable: widget.presenter.completedNotifier,
                              builder: (ctx, value, ch) => Checkbox(
                                value: value,
                                onChanged: widget.presenter.switchCompleted,
                              ),
                            ),
                            const Text('Completed?'),
                          ],
                        ),
                        const Expanded(child: SizedBox()),
                        Expanded(
                          flex: 4,
                          child: ValueListenableBuilder<ButtonState>(
                            valueListenable: widget.presenter.buttonStateNotifier,
                            builder: (ctx, buttonState, ch) => PrimaryButtonExpanded(
                              text: 'Salvar',
                              isLoading: buttonState.isLoading,
                              onPressed: buttonState.isValid && !buttonState.isLoading
                                  ? widget.presenter.addOrUpdateTask
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
