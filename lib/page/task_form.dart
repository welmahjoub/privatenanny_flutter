
import 'package:flutter/material.dart';
import 'package:private_nanny/widget/datetime_piker.dart';



class TaskFormPage extends StatefulWidget {
  @override
  State createState() => new _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  bool _switchValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nouvelle tâche'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
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
              child:  Container(
                padding: EdgeInsets.only(left: 7),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: DatetimePickerWidget(),
                  )
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
              decoration: InputDecoration(
                labelText: 'Intitulé',
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 6),
            child: TextField(
              maxLength: 255,
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