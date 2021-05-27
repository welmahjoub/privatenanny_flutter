import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatetimePickerWidget extends StatefulWidget {
  @override
  _DatetimePickerWidgetState createState() => _DatetimePickerWidgetState();
}

class _DatetimePickerWidgetState extends State<DatetimePickerWidget> {
  DateTime _dateTime = DateTime.now();
  final TextEditingController _textController = new TextEditingController();
  String _getText() {
    if (_dateTime == null) {
      return '';
    } else {
      return DateFormat('MM/dd/yyyy HH:mm').format(_dateTime);
    }
  }

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: _textController,
    decoration: InputDecoration(
      icon: Icon(Icons.notifications),
      labelText: 'Date et heure',
      suffixIcon: Icon(
        Icons.today,
      ),
    ),
    readOnly: true,
    onTap: () => pickDateTime(context),
  );

  Future pickDateTime(BuildContext context) async {
    final date = await pickDate(context);
    if (date == null) return;

    final time = await pickTime(context);
    if (time == null) return;

    setState(() {
      _dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
      _textController.text = _getText();
    });
  }

  Future<DateTime> pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: _dateTime ?? initialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (newDate == null) return null;

    return newDate;
  }

  Future<TimeOfDay> pickTime(BuildContext context) async {
    final initialTime = TimeOfDay(hour: 9, minute: 0);
    final newTime = await showTimePicker(
      context: context,
      initialTime: _dateTime != null
          ? TimeOfDay(hour: _dateTime.hour, minute: _dateTime.minute)
          : initialTime,
    );

    if (newTime == null) return null;

    return newTime;
  }
}
