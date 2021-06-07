import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:private_nanny/page/passwordForgot_page.dart';
import 'package:private_nanny/page/registerPage.dart';
import 'package:private_nanny/service/UserService.dart';
import 'package:private_nanny/service/auth.dart';

import 'home.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  AuthService _service = AuthService();
  bool _success;
  String _email;
  String _password;

  void _submitCommand() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      _loginPressed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Connexion'),
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
                    val.length < 4 ? 'Mot de passe trop court.' : null,
                onSaved: (val) => _password = val,
                obscureText: true,
              ),
              RaisedButton(
                onPressed: _submitCommand,
                child: Text('Connexion'),
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  _success == null
                      ? ''
                      : (_success
                          ? 'Successfully signed in, uid: '
                          : 'Sign in failed'),
                  style: TextStyle(color: Colors.red),
                ),
              ),
              new FlatButton(
                child: new Text('Pas encore de compte ? Créer un compte.'),
                onPressed: _redirectToRegisterPage,
              ),
              new FlatButton(
                child: new Text('Mot de passe oublié ?'),
                onPressed: _passwordReset,
              )
            ],
          ),
        ),
      ),
    );
  }

  void _loginPressed() {
    _service
        .login(_email, _password)
        .then((value) => {
              if (value != null)
                {loginRedirect()}
              else
                {
                  setState(() {
                    _success = false;
                  })
                }
            })
        .onError((error, stackTrace) => null);
  }

  Future<void> loginRedirect() async {
    UserService service = UserService();
    await service.updateCurretUser(_service.auth.currentUser.uid);
    setState(() {
      _success = true;
    });
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  void _passwordReset() {
    print(
        "L'utilisateur souhaite qu'une demande de réinitialisation de mot de passe soit envoyée à $_email");
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ForgotPwd()));
  }

  void _redirectToRegisterPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => RegisterPage()));
  }
}
