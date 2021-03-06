import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:private_nanny/model/utilisateur.dart';
import 'package:private_nanny/page/loginPage.dart';
import 'package:private_nanny/service/auth.dart';
import 'package:private_nanny/service/UserService.dart';
import 'home.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String _email;
  String _password;
  String _phone;

  void _submitCommand() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      _createAccountFirebase();
    }
  }

  void _redirectToLoginPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
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
    AuthService _authService = AuthService();
    var user = Utilisateur(_email, _email, _phone, _email);
    user.contacts = [];
    user.groups = [];
    user.tasks = [];
    user.uid = _authService.auth.currentUser.uid;

    back.createUser(user).then((value) {
      back.updateCurretUser(_authService.auth.currentUser.uid);
      print(value.statusCode);
      print(UserService.currentUser);
    });

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Inscription '),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
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
                  validator: (val) => val.length < 10
                      ? 'Numéro de téléphone trop court.'
                      : null,
                  onSaved: (val) => _phone = val,
                  keyboardType: TextInputType.number),
              RaisedButton(
                onPressed: _submitCommand,
                child: Text('Inscription'),
              ),
              FlatButton(
                onPressed: _redirectToLoginPage,
                child: Text('Vous avez un compte? Se connecter.'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
