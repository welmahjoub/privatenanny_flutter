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
        title: Text('Email validation example'),
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
                    ? 'Not a valid email.'
                    : null,
                onSaved: (val) => _email = val,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                validator: (val) =>
                    val.length < 4 ? 'Password too short..' : null,
                onSaved: (val) => _password = val,
                obscureText: true,
              ),
              RaisedButton(
                onPressed: _submitCommand,
                child: Text('Sign in'),
              ),
              new FlatButton(
                child: new Text('Dont have an account? Tap here to register.'),
                onPressed: _redirectToRegisterPage,
              ),
              new FlatButton(
                child: new Text('Forgot Password?'),
                onPressed: _passwordReset,
              )
            ],
          ),
        ),
      ),
    );
  }

  void _loginPressed() {
    _service.login(_email, _password).then((value) => {
          if (value != null) {loginRedirect()}
        });
  }

  Future<void> loginRedirect() async {
    UserService service = UserService();
    await service.updateCurretUser(_service.auth.currentUser.uid);

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  void _passwordReset() {
    print("The user wants a password reset request sent to $_email");
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ForgotPwd()));
  }

  void _redirectToRegisterPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => RegisterPage()));
  }
}
