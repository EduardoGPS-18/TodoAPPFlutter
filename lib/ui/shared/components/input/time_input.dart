import 'package:flutter/material.dart';

class TimeInput extends StatefulWidget {
  final void Function(TimeOfDay)? onChangedTime;
  final TimeOfDay? initialTime;
  final InputDecoration? decoration;

  const TimeInput({
    Key? key,
    this.onChangedTime,
    this.initialTime,
    this.decoration,
  }) : super(key: key);

  @override
  State<TimeInput> createState() => _TimeInputState();
}

class _TimeInputState extends State<TimeInput> {
  late final TextEditingController controller;

  String? formatTime(TimeOfDay? time) {
    if (time == null) {
      return null;
    }
    final formattedHour = time.hour > 9 ? time.hour : '0${time.hour}';
    final formattedMinute = time.minute > 9 ? time.minute : '0${time.minute}';
    return '${formattedHour}h$formattedMinute';
  }

  @override
  void initState() {
    super.initState();

    final defaultTime = widget.initialTime;
    controller = TextEditingController(text: formatTime(defaultTime));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        FocusScope.of(context).unfocus();
        final selectedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
          initialEntryMode: TimePickerEntryMode.dial,
          confirmText: 'CONFIRMAR',
          cancelText: 'CANCELAR',
          hourLabelText: 'HORA',
          minuteLabelText: 'MINUTO',
          helpText: 'SELECIONE A HORA FINAL',
        );
        if (selectedTime != null) {
          widget.onChangedTime?.call(selectedTime);
          controller.value = TextEditingValue(text: formatTime(selectedTime) ?? '');
        }
      },
      child: Container(
        color: Colors.transparent,
        child: IgnorePointer(
          child: TextField(
            controller: controller,
            textAlign: TextAlign.center,
            decoration: widget.decoration ?? const InputDecoration(),
          ),
        ),
      ),
    );
  }
}
