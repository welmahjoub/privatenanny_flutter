
import 'package:flutter/material.dart';
import 'package:private_nanny/model/task.dart';
import 'package:private_nanny/widget/datetime_piker.dart';

class TaskFormPage extends StatefulWidget {
  @override
  State createState() => new _TaskFormPageState();
  TaskFormPage({Key key, this.task}) : super(key: key);
  Task task;
}

class _TaskFormPageState extends State<TaskFormPage> {
  bool _switchValue = false;
  @override
  void initState() {
    super.initState();
    _titleController.text = widget.task.title;
    _detailController.text = widget.task.detail;
  }
  final TextEditingController _titleController = new TextEditingController();
  final TextEditingController _detailController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nouvelle tâche'),
      ),
      body: SingleChildScrollView(
        child:  Container(
          padding: EdgeInsets.only(left: 16, right: 16, top: 16 ),
          child: Column(
            children: [
              _buildTextFields(),
              Divider(
                height: 40,
              ),
              _buildReminder()
            ],
          ),
        ),
      )
    );
  }

  Widget _buildReminder() {
    return Container(
        child: Column(
          children: [
            SwitchListTile(
                title: Text('Rappel'),
                value: _switchValue,
                onChanged: (bool value) {
                  setState(() {
                    _switchValue = !_switchValue;
                  });
                }),
            Visibility(
              child: Column(
                children: [
                  Container(
                      padding: EdgeInsets.only(left: 7),
                      child: DatetimePickerWidget()
                  )
                ],
              ),
              visible: _switchValue,
            )
          ],
        )
    );
  }

  Widget _buildTextFields() {
    return Container(
      child: Column(
        children: [
          Container(
            child: TextFormField(
              maxLength: 30,
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Intitulé',
              ),
              onChanged: (String value) {
                widget.task.title = value;
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 6),
            child: TextField(
              maxLength: 255,
              controller: _detailController,
              minLines: 1,
              maxLines: 5,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                  labelText: 'Détail'
              ),
            ),
          ),
        ],
      ),
    );
  }
}