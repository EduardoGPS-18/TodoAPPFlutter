import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateInput extends StatefulWidget {
  final void Function(DateTime date)? onChangedDateTime;
  final InputDecoration? decoration;
  final DateTime? initialDate;

  const DateInput({
    Key? key,
    this.onChangedDateTime,
    this.initialDate,
    this.decoration,
  }) : super(key: key);

  @override
  State<DateInput> createState() => _DateInputState();
}

class _DateInputState extends State<DateInput> {
  late final TextEditingController controller;
  String? formatDate(DateTime? date) => date == null ? null : DateFormat('dd/MM/yyyy').format(date);

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: formatDate(widget.initialDate));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        FocusScope.of(context).unfocus();
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(
            const Duration(days: 365 * 2),
          ),
        );
        if (selectedDate != null) {
          widget.onChangedDateTime?.call(selectedDate);
          controller.value = TextEditingValue(text: formatDate(selectedDate)!);
        }
      },
      child: Container(
        color: Colors.transparent,
        child: IgnorePointer(
          child: TextField(
            controller: controller,
            decoration: widget.decoration ?? const InputDecoration(),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
