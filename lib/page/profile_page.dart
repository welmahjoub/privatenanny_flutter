import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:private_nanny/model/utilisateur.dart';
import 'package:private_nanny/page/loginPage.dart';
import 'package:private_nanny/service/auth.dart';
import 'package:private_nanny/service/UserService.dart';
import 'home.dart';

class PorfilePage extends StatefulWidget {
  @override
  _PorfilePageState createState() => _PorfilePageState();
}

class _PorfilePageState extends State<PorfilePage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String _email;
  String _password;
  String _phone;
  String _username;

  void _submitCommand() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      _createAccountFirebase();
    }
  }

  void _createAccountFirebase() {
    print("L'utilisateur veut créer un compte avec $_email et $_password");
    AuthService _authService = AuthService();

    _authService
        .create(_email, _password)
        .then((value) => {if (value != null) _createAccountBackend()});
  }

  void _createAccountBackend() {
    UserService back = UserService();
    back
        .createUser(Utilisateur(_email, _email, _phone, _email))
        .then((value) => print(value.statusCode));

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text('profile '),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'User Name'),
                onSaved: (val) => _username = val,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (val) => !EmailValidator.validate(val, true)
                    ? 'Email invalide.'
                    : null,
                onSaved: (val) => _email = val,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Mot de passe'),
                validator: (val) =>
                    val.length < 6 ? 'Mot de passe trop court.' : null,
                onSaved: (val) => _password = val,
                obscureText: true,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Numéro de téléphone'),
                validator: (val) =>
                    val.length < 10 ? 'Numéro de téléphone trop court.' : null,
                onSaved: (val) => _password = val,
              ),
              RaisedButton(
                onPressed: _submitCommand,
                child: Text('Modifer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
