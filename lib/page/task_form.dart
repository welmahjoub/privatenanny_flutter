
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:private_nanny/model/task.dart';
import 'package:private_nanny/model/utilisateur.dart';
import 'package:private_nanny/service/auth.dart';
import 'package:private_nanny/widget/datetime_piker.dart';
import 'package:private_nanny/widget/popover.dart';

class TaskFormPage extends StatefulWidget {
  @override
  State createState() => new _TaskFormPageState();
  TaskFormPage({Key key, this.task}) : super(key: key);
  Task task;
}

class _TaskFormPageState extends State<TaskFormPage> {
  bool _switchValue;
  Repeatition _dropdownValue;
  final List<Utilisateur> _users = [];
  final TextEditingController _titleController = new TextEditingController();
  final TextEditingController _detailController = new TextEditingController();
  final _textfieldFormKey = GlobalKey<FormState>();
  final _datetimeFormKey = GlobalKey<FormState>();

  AuthService _authService = AuthService();

  @override
  void dispose() {
    super.dispose();
    _titleController?.dispose();
    _detailController?.dispose();
  }

  @override
  void initState() {

    super.initState();

    _switchValue = widget.task.dateTime != null;
    _dropdownValue = Task.getFromDuration(widget.task.delayBetweenRepetition);
    // initiate receivers
    for(var i = 0; i < 10; i++) {
      _users.add(new Utilisateur('koitrin@test.com', 'Koitrin', '09876543', 'Qt-tracker'));
    }

    // initiate text controller
    _titleController.text = widget.task.title;
    _detailController.text = widget.task.detail;
    _detailController.addListener(() => widget.task.detail = _detailController.text);
    _titleController.addListener(() => widget.task.title = _titleController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Nouvelle tâche'),
        ),
        floatingActionButton: _buildRegisterButton(),
        body: SingleChildScrollView(
          child:  Container(
            padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 32),
            child: Column(
              children: [
                _buildTextFields(),
                Divider(
                  height: 30,
                  thickness: 1,
                ),
                _buildUsers(),
                Divider(
                  height: 30,
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
              visible: _switchValue,
              child: Container(
                padding: EdgeInsets.only(left: 7),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: DatetimePickerWidget(task: widget.task, formKey: _datetimeFormKey,),
                    ),
                    _buildRepeatition()
                  ],
                ),
              ),
            )
          ],
        )
    );
  }

  Widget _buildTextFields() {
    return Container(
        child:
        Form(
          key: _textfieldFormKey,
          child: Column(
            children: [
              Container(
                child: TextFormField(
                  maxLength: 30,
                  controller: _titleController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Il faut au moins l\'intitulé';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    labelText: 'Intitulé',
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 6),
                child: TextField(
                  maxLength: 255,
                  controller: _detailController,
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Détail'
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }

  Widget _buildUsers() {
    var userChipList = <Widget>[];

    _users.forEach((element) {
      userChipList.add(new InputChip(
        label: Text(element.displayName),
        deleteIcon: Icon(Icons.remove_circle,),
        onDeleted: () {
          setState(() {
            _users.remove(element);
          });
        },
      ));
    });

    return Container(
      child: Column(
        children: [
          Container(
            child: Align(
              child: Text('Attribué à : '),
              alignment: Alignment.centerLeft,
            ),
          ),
          Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.start,
            spacing: 5,
            children: userChipList,
          ),
          Container(
            child: ElevatedButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) {
                        return Popover(
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 20),
                                  child: Text(
                                    'Ajouter un contact à la tâche',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: TextField(
                                    decoration: InputDecoration(
                                        filled: true,
                                        labelText: 'Contact',
                                        hintText: 'nom ou prénom'
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                    onPressed: () {},
                                    child: Text('Ajouter')
                                )
                              ],
                            )
                        );
                      }
                  );
                },
                icon: Icon(Icons.add, size: 18),
                label: Text('Ajouter un contact')),
          )
        ],
      ),
    );
  }

  Widget _buildRepeatition() {
    return Container(
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 16),
            child: Icon(
              Icons.repeat,
              semanticLabel: 'Répétition',
            ),
          ),
          DropdownButton(
            value: _dropdownValue,
            onChanged: (Repeatition r) {
              setState(() {
                _dropdownValue = r;
              });
            },
            items: Repeatition.values.map((e) => DropdownMenuItem(
                value: e,
                child: Text(e.name)
            )).toList(),
          )
        ],
      ),
    );
  }

  Widget _buildRegisterButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        if(_textfieldFormKey.currentState.validate()) {
          if (_switchValue) {
            if (_datetimeFormKey.currentState.validate())
              _sendTask();
          } else {
            _sendTask();
          }
        }
      },
      label: const Text('Enregistrer'),
      icon: const Icon(Icons.save),
      backgroundColor: Colors.green,
    );
  }

  void _sendTask() {
    widget.task.receivers = _users;
    widget.task.user = new Utilisateur('email', 'displayName', 'phoneNo', 'pseudo');
    print(widget.task.toJson());
  }
}