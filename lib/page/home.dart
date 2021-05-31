import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:private_nanny/model/task.dart';
import 'package:private_nanny/page/task_form.dart';
import 'package:private_nanny/service/auth.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'contact.dart';
import 'group.dart';

class HomeScreen extends StatefulWidget {
  //HomeScreen({Key key, this.email}) : super(key: key);
  //final String email;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthService _authService = AuthService();

  //TextEditingController _textController = TextEditingController();
  List<String> taskList = [
    "rendez vous medecin",
    "faire les courses",
    "laver le linge",
    "faire à manger"
  ];
  List<DateTime> dateList = [
    DateTime.utc(2021, 05, 27),
    DateTime.utc(2021, 05, 27),
    DateTime.utc(2021, 05, 28),
    DateTime.utc(2021, 05, 28)
  ];

  stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Appuyez sur le bouton et commencez à parler';
  double _confidence = 1.0;
  var _localeId = '';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Accueil"),
          centerTitle: true,
          actions: [Icon(Icons.account_circle_rounded), Container(width: 15)],
        ),
        drawer: Drawer(
            child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Menu'),
            ),
            ListTile(
              title: Text('Mes tâches'),
              onTap: () {
                // Update the state of the app.
                // ...
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
            ),
            ListTile(
              title: Text('Tâches attribuées'),
              onTap: () {
                // Update the state of the app.
                // ...
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
            ),
            ListTile(
              title: Text('Mes contacts'),
              onTap: () {
                // Update the state of the app.
                // ...
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ContactScreen()));
              },
            ),
            ListTile(
              title: Text('Mes groupes'),
              onTap: () {
                // Update the state of the app.
                // ...
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => GroupScreen()));
              },
            ),
          ],
        )),
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
        body: Column(
            //reverse: true,
            //crossAxisCount: 2,
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 150.0),
                  child: ListView.builder(
                      //scrollDirection: Axis.vertical,

                      shrinkWrap: true,
                      itemCount: dateList.length,
                      itemBuilder: (BuildContext context, index) {
                        return ListTile(
                          title: Text(dateList[index].day.toString() +
                              " / " +
                              dateList[index].month.toString() +
                              "  :    " +
                              taskList[index]),
                        );
                      })),
              /*Container(
              color : Colors.pink,
              padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              child: ListView.builder(
                //scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: taskList.length,
                  itemBuilder: (BuildContext context, index) {
                    return ListTile(

                      title: Text(taskList[index]),

                    );
                  })
          ),*/

              Container(
                padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0.0),
                child: Text(
                  _text,
                  style: const TextStyle(
                    fontSize: 30.0,
                    //color: Colors.pink,
                    //backgroundColor: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ]));
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
          listenFor: Duration(minutes: 1),
          onResult: (val) => setState(() {
            _text = val.recognizedWords;

            print(_text);
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
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
              builder: (context) => TaskFormPage(task: new Task(_text))));
    }
  }
}
