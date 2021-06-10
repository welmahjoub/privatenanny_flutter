import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:private_nanny/model/task.dart';
import 'package:private_nanny/model/utilisateur.dart';
import 'package:private_nanny/page/home.dart';
import 'package:private_nanny/page/widgets.dart';
import 'package:private_nanny/service/UserService.dart';
import 'package:private_nanny/service/auth.dart';
import 'package:private_nanny/service/task.dart';
import 'package:private_nanny/widget/datetime_piker.dart';
import 'package:private_nanny/widget/popover.dart';

class TaskFormPage extends StatefulWidget {
  @override
  State createState() => new _TaskFormPageState();
  TaskFormPage({Key key, this.task, this.editable}) : super(key: key);
  bool editable;
  Task task;
}

class _TaskFormPageState extends State<TaskFormPage> {  DateTime _dateTime;
  bool _switchValue;
  Repeatition _dropdownValue;
  List<Utilisateur> _usersSelected;
  final TextEditingController _titleController = new TextEditingController();
  final TextEditingController _detailController = new TextEditingController();
  final _textfieldFormKey = GlobalKey<FormState>();
  final _datetimeFormKey = GlobalKey<FormState>();
  final Widgets _widgets = Widgets();
  final AuthService _authService = AuthService();
  final TaskService _taskService = TaskService();
  List _filterContactList;

  @override
  void dispose() {
    super.dispose();
    _titleController?.dispose();
    _detailController?.dispose();
  }

  @override
  void initState() {
    super.initState();

    _usersSelected = widget.task.receivers != null
        ? widget.task.receivers
        : _usersSelected = [];
    _filterContactList = UserService.currentUser.contacts != null
        ? UserService.currentUser.contacts
        : [];

    _switchValue = widget.task.dateTime != null;
    _dropdownValue = Task.getFromDuration(widget.task.delayBetweenRepetition);

    _dateTime = widget.task.dateTime;

    // initiate receivers
    _usersSelected = widget.task.receivers == null ? [] : widget.task.receivers;

    // initiate text controller
    _titleController.text = widget.task.title;
    _detailController.text = widget.task.detail;
    _detailController
        .addListener(() => widget.task.detail = _detailController.text);
    _titleController
        .addListener(() => widget.task.title = _titleController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _widgets.appBar(context, "Nouvelle tâche"),
        drawer: _widgets.drawer(context, _authService),
        floatingActionButton: _buildRegisterButton(),
        body: SingleChildScrollView(
          child: Container(
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
        ));
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
                  child: DatetimePickerWidget(
                      task: widget.task, formKey: _datetimeFormKey),
                ),
                _buildRepeatition(context)
              ],
            ),
          ),
        )
      ],
    ));
  }

  Widget _buildTextFields() {
    return Container(
        child: Form(
      key: _textfieldFormKey,
      child: Column(
        children: [
          Container(
            child: TextFormField(
              readOnly: !widget.editable,
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
              readOnly: !widget.editable,
              maxLength: 255,
              controller: _detailController,
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(), labelText: 'Détail'),
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildUsers() {
    final userChipList = <Widget>[];

    _usersSelected?.forEach((element) {
      userChipList.add(InputChip(
        label: Text(element.displayName),
        deleteIcon: Icon(
          Icons.remove_circle,
        ),
        onDeleted: widget.editable
            ? () {
                setState(() {
                  _usersSelected.remove(element);
                });
              }
            : null,
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
          Visibility(
            child: Container(
              child: ElevatedButton.icon(
                  onPressed: () {
                    showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(builder: (BuildContext context,
                              StateSetter setModalState) {
                            return Popover(
                                child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 20),
                                  child: Text(
                                    'Ajouter un contact à la tâche',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: TextField(
                                    onChanged: (value) {
                                      setModalState(() {
                                        List<Utilisateur> contacts =
                                            UserService.currentUser.contacts;
                                        if (contacts != null) {
                                          _filterContactList = UserService
                                              .currentUser.contacts
                                              .where((user) => user.displayName
                                                  .toLowerCase()
                                                  .contains(value))
                                              .toList();
                                        }
                                      });
                                    },
                                    decoration: InputDecoration(
                                        filled: true,
                                        labelText: 'Contact',
                                        hintText: 'nom ou prénom'),
                                  ),
                                ),
                                Container(
                                  height: 400,
                                  child: _filterContactList.length > 0
                                      ? ListView.builder(
                                          itemCount: _filterContactList.length,
                                          scrollDirection: Axis.vertical,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return CheckboxListTile(
                                              title: Text(
                                                  _filterContactList[index]
                                                      .displayName),
                                              subtitle: Text(
                                                  _filterContactList[index]
                                                      .phoneNo),
                                              onChanged: (value) {
                                                setState(() {
                                                  if (!_usersSelected.contains(
                                                      _filterContactList[
                                                          index]))
                                                    _usersSelected.add(
                                                        _filterContactList[
                                                            index]);
                                                  else
                                                    _usersSelected.remove(
                                                        _filterContactList[
                                                            index]);
                                                });
                                                setModalState(() {
                                                  _usersSelected =
                                                      _usersSelected;
                                                });
                                              },
                                              value: _usersSelected.contains(
                                                  _filterContactList[index]),
                                            );
                                          },
                                        )
                                      : Center(
                                          child:
                                              Text('Vous avez aucun contact'),
                                        ),
                                ),
                              ],
                            ));
                          });
                        });
                  },
                  icon: Icon(Icons.add, size: 18),
                  label: Text('Ajouter un contact')),
            ),
            visible: widget.editable,
          ),
        ],
      ),
    );
  }

  Widget _buildRepeatition(BuildContext context) {
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
            items: Repeatition.values
                .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
                .toList(),
          )
        ],
      ),
    );
  }

  Widget _buildRegisterButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        if (_textfieldFormKey.currentState.validate()) {
          if (_switchValue) {
            if (_datetimeFormKey.currentState.validate()) _sendTask(context);
          } else {
            _sendTask(context);
          }
        }
      },
      label: const Text('Enregistrer'),
      icon: const Icon(Icons.save),
      backgroundColor: Colors.green,
    );
  }

  void _sendTask(BuildContext context) {
    if (widget.editable) {
      widget.task.user = UserService.currentUser;

      widget.task.receivers = _usersSelected;
      widget.task.repeat = _dropdownValue != Repeatition.no;
      widget.task.delayBetweenRepetition = _dropdownValue.duration;
      widget.task.createdAt = DateTime.now();
      print(widget.task.toJson().toString());
      _taskService.createTask(widget.task).then((value) {
        if ([201, 202, 200].contains(value.statusCode)) {
          ScaffoldMessenger.of(context)
              .showSnackBar(_buildSnackBar('La tâche a été bien créée'));
          UserService user = UserService();
          user.updateCurretUser(UserService.currentUser.uid);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        } else
          ScaffoldMessenger.of(context)
              .showSnackBar(_buildSnackBar('Une erreur s\'est produite'));
      }).onError((error, stackTrace) {
        ScaffoldMessenger.of(context)
            .showSnackBar(_buildSnackBar('Une erreur s\'est produite'));
      });
    } else {
      print(widget.task.dateTime);
      if (_dateTime.isAtSameMomentAs(widget.task.dateTime)) {
        ScaffoldMessenger.of(context)
            .showSnackBar(_buildSnackBar('Aucune modification identifiée'));
      } else {
        print(widget.task);
        _taskService.updateTask(widget.task).then((value) {
          if ([201, 202, 200].contains(value.statusCode)) {
            ScaffoldMessenger.of(context)
                .showSnackBar(_buildSnackBar('La tâche a été bien modifiée'));
          } else
            ScaffoldMessenger.of(context)
                .showSnackBar(_buildSnackBar('Une erreur s\'est produite'));
        }).onError((error, stackTrace) {
          ScaffoldMessenger.of(context)
              .showSnackBar(_buildSnackBar('Une erreur s\'est produite'));
        });
      }
    }
  }

  Widget _buildSnackBar(text) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(text),
    );
  }
}
