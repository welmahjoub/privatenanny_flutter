import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:private_nanny/model/task.dart';

class DatetimePickerWidget extends StatefulWidget {
  @override
  _DatetimePickerWidgetState createState() => _DatetimePickerWidgetState();
  DatetimePickerWidget({Key key, this.task, this.formKey});
  Task task;
  GlobalKey<FormState> formKey;
}

class _DatetimePickerWidgetState extends State<DatetimePickerWidget> {
  final TextEditingController _textController = new TextEditingController();
  DateTime _initDate;
  @override
  void initState() {
    _textController.text = _getText(_initDate);
    _initDate = widget.task.dateTime != null ? widget.task.dateTime : DateTime.now();
  }

  String _getText(DateTime dateTime) {
    if (dateTime == null) {
      return '';
    } else {
      return DateFormat('MM/dd/yyyy HH:mm').format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) => Form(
      key: widget.formKey,
      child: TextFormField(
        controller: _textController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Il faut la date de rappel';
          }
          return null;
        },
        decoration: InputDecoration(
          filled: true,
          icon: Icon(Icons.notifications),
          labelText: 'Date et heure',
          suffixIcon: Icon(
            Icons.today,
          ),
        ),
        readOnly: true,
        onTap: () => pickDateTime(context),
      )
  );

  Future pickDateTime(BuildContext context) async {
    final date = await pickDate(context);
    if (date == null) return;

    final time = await pickTime(context);
    if (time == null) return;

    setState(() {
      widget.task.dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
      _textController.text = _getText(widget.task.dateTime);
    });
  }

  Future<DateTime> pickDate(BuildContext context) async {

    final newDate = await showDatePicker(
      context: context,
      initialDate: _initDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (newDate == null) return null;

    return newDate;
  }

  Future<TimeOfDay> pickTime(BuildContext context) async {
    final newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _initDate.hour, minute: _initDate.minute),
    );

    if (newTime == null) return null;

    return newTime;
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }
}
