import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:private_nanny/model/task.dart';
import 'package:private_nanny/page/task_form.dart';
import 'package:private_nanny/page/widgets.dart';
import 'package:private_nanny/service/UserService.dart';
import 'package:private_nanny/service/auth.dart';
import 'package:private_nanny/service/utility.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthService _authService = AuthService();
  UserService back = UserService();
  Widgets widgets = Widgets();

  List<Task> userTasks = List();

  stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Appuyez sur le bouton et commencez à parler';
  var _localeId = '';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    print(_authService.auth.currentUser.uid);
    setState(() {
      userTasks = UserService.currentUser?.tasks;
      if (userTasks == null) {
        userTasks = [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: widgets.appBar(context, "Accueil"),
        drawer: widgets.drawer(context, _authService),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: AvatarGlow(
          animate: _isListening,
          glowColor: Theme.of(context).primaryColor,
          endRadius: 75.0,
          duration: const Duration(milliseconds: 2000),
          repeatPauseDuration: const Duration(milliseconds: 100),
          repeat: true,
          child: FloatingActionButton(
            onPressed: _listen,
            child: Icon(_isListening ? Icons.mic : Icons.mic_none),
          ),
        ),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          Container(
              //color: Colors.amber[600],
              padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 150.0),
              child: ListView.builder(
                  //scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: userTasks.length,
                  itemBuilder: (BuildContext context, index) {
                    return Card(
                      child: ListTile(
                        leading: Text(
                          userTasks[index].dateTime.day.toString() +
                              " / " +
                              userTasks[index].dateTime.month.toString(),
                        ),
                        title: Text("  :    " + userTasks[index].title),
                        onTap: () => displayTask(userTasks[index]),
                        trailing: IconButton(
                            color: Colors.blue,
                            icon: userTasks[index].isValidated
                                ? Icon(Icons.check_circle_rounded)
                                : Icon(Icons.check_circle_outline),
                            onPressed: () {
                              setState(() {
                                userTasks[index].isValidated =
                                    !userTasks[index].isValidated;
                              });
                            }),
                      ),
                    );
                  })),
          Container(
            padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0.0),
            child: Text(
              _text,
              style: const TextStyle(
                fontSize: 30.0,
                //backgroundColor: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ])));
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        var systemLocale = await _speech.systemLocale();
        _localeId = systemLocale.localeId;
        print(_localeId);
        _speech.listen(
          localeId: _localeId,
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            print(_text);
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
      print("finish ");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TaskFormPage(
                    task: Utility.splitSpeechText(_text),
                    editable: true,
                  )));
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
