import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:private_nanny/service/auth.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../main.dart';
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
          actions: [
            Icon(Icons.account_circle_rounded),
            Container(width: 15)
          ],
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
                  Navigator.push(context, MaterialPageRoute( builder: (context) => HomeScreen()));
                },
              ),
              ListTile(
                title: Text('Tâches attribuées'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                  Navigator.push(context, MaterialPageRoute( builder: (context) => HomeScreen()));

                },
              ),
              ListTile(
                title: Text('Mes contacts'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                  Navigator.push(context, MaterialPageRoute( builder: (context) => ContactScreen()));
                },
              ),
              ListTile(
                title: Text('Mes groupes'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                  Navigator.push(context, MaterialPageRoute( builder: (context) => GroupScreen()));
                },
              ),
            ],
          )
        ),
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
        //reverse: true,
        child: Container(
          padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
          child: Text(
            _text,
            style: const TextStyle(
              fontSize: 32.0,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),);
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
    }
  }
}

