import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:private_nanny/model/task.dart';
import 'package:private_nanny/page/task_form.dart';
import 'package:private_nanny/page/widgets.dart';
import 'package:private_nanny/service/UserService.dart';
import 'package:private_nanny/service/auth.dart';
import 'package:private_nanny/service/utility.dart';
import 'package:private_nanny/widget/expandable_fab.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  final Widgets _widgets = Widgets();

  List<Task> _userTasksToDo = [];
  List<Task> _userTasksDone = [];

  stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = '';
  var _localeId = '';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    // print(_authService.auth.currentUser.uid);
    // if (UserService.currentUser?.tasks != null) {
    //   _userTasksToDo = UserService.currentUser.tasks
    //       .where((element) => !element.isValidated)
    //       .toList();
    //   _userTasksToDo.sort((a, b) => a.dateTime.compareTo(b.dateTime));

    //   _userTasksDone = UserService.currentUser.tasks
    //       .where((element) => element.isValidated)
    //       .toList();
    //   _userTasksDone.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _widgets.appBar(context, "Accueil"),
        drawer: _widgets.drawer(context, _authService),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: ExpandableFab(
          distance: 100.0,
          children: [
            ActionButton(
              onPressed: _listen,
              icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
            ),
            ActionButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TaskFormPage(
                            task: new Task(),
                            editable: true,
                          ))),
              icon: const Icon(Icons.edit),
            ),
          ],
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          Visibility(
            visible: _text.isNotEmpty && _isListening,
            child: Container(
              padding: const EdgeInsets.only(
                  left: 10, right: 10, bottom: 10, top: 20),
              child: Text(
                _text,
                style: const TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 25, left: 10, right: 10),
            child: Row(
              children: [
                Text(
                  'A Faire',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Container(
                  margin: EdgeInsets.only(left: 5),
                  child: Icon(
                    Icons.check_circle_outline,
                  ),
                ),
                Expanded(
                  child: Divider(
                    thickness: 2,
                    color: Colors.black54,
                    indent: 5,
                  ),
                )
              ],
            ),
          ),
          Container(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _userTasksToDo.length,
                  itemBuilder: (BuildContext context, index) {
                    return Card(
                      child: ListTile(
                        trailing: IconButton(
                            color: Colors.blue,
                            icon: _userTasksToDo[index].isValidated
                                ? Icon(Icons.check_circle_rounded)
                                : Icon(Icons.check_circle_outline),
                            onPressed: () {
                              setState(() {
                                Task task = _userTasksToDo[index];
                                task.isValidated = !task.isValidated;
                                _userTasksToDo.removeAt(index);
                                _userTasksDone.add(task);

                                _userTasksToDo.sort(
                                    (a, b) => a.dateTime.compareTo(b.dateTime));
                                _userTasksDone.sort(
                                    (a, b) => a.dateTime.compareTo(b.dateTime));
                              });
                            }),
                        title: Text(_userTasksToDo[index].title),
                        subtitle: Text(DateFormat('dd/MM/yyyy HH:mm')
                            .format(_userTasksToDo[index].dateTime)),
                        onTap: () => displayTask(_userTasksToDo[index]),
                      ),
                    );
                  })),
          Container(
            padding: EdgeInsets.only(top: 25, left: 10, right: 10),
            child: Row(
              children: [
                Text(
                  'Terminées',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Container(
                  margin: EdgeInsets.only(left: 5),
                  child: Icon(
                    Icons.check_circle,
                  ),
                ),
                Expanded(
                  child: Divider(
                    thickness: 2,
                    color: Colors.black54,
                    indent: 5,
                  ),
                )
              ],
            ),
          ),
          Container(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _userTasksDone.length,
                  itemBuilder: (BuildContext context, index) {
                    return Card(
                      child: ListTile(
                        trailing: IconButton(
                            color: Colors.blue,
                            icon: _userTasksDone[index].isValidated
                                ? Icon(Icons.check_circle_rounded)
                                : Icon(Icons.check_circle_outline),
                            onPressed: () {
                              setState(() {
                                Task task = _userTasksDone[index];
                                task.isValidated = !task.isValidated;
                                _userTasksDone.removeAt(index);
                                _userTasksToDo.add(task);

                                _userTasksToDo.sort(
                                    (a, b) => a.dateTime.compareTo(b.dateTime));
                                _userTasksDone.sort(
                                    (a, b) => a.dateTime.compareTo(b.dateTime));
                              });
                            }),
                        title: Text(_userTasksDone[index].title),
                        subtitle: Text(DateFormat('dd/MM/yyyy HH:mm')
                            .format(_userTasksDone[index].dateTime)),
                        onTap: () => displayTask(_userTasksDone[index]),
                      ),
                    );
                  })),
        ])));
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() {
          _text = '';
          _isListening = true;
        });
        var systemLocale = await _speech.systemLocale();
        _localeId = systemLocale.localeId;
        print(_localeId);
        _speech.listen(
          localeId: _localeId,
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            // print(_text);
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
      print("finish ");
      String textVerification = _text;
      if (textVerification.trim().isNotEmpty) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TaskFormPage(
                      task: Utility.splitSpeechText(_text),
                      editable: true,
                    )));
      } else {
        print("started");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.fixed,
          content: Text(
              'Nous vous n\'avons rien entendu. Veuillez réessayer s\'il vous plait.'),
        ));
      }
    }
  }

  displayTask(Task task) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TaskFormPage(
                  task: task,
                  editable: false,
                )));
  }
}
