import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:private_nanny/model/utilisateur.dart';
import 'package:private_nanny/page/loginPage.dart';
import 'package:private_nanny/service/auth.dart';
import 'package:private_nanny/service/serviceBackend.dart';
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
    print('The user wants to create an accoutn with $_email and $_password');
    AuthService _authService = AuthService();

    _authService
        .create(_email, _password)
        .then((value) => {if (value != null) _createAccountBackend()});
  }

  void _createAccountBackend() {
    ServiceBackend back = ServiceBackend();
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
        title: Text('Register Page '),
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
                    val.length < 6 ? 'Password too short..' : null,
                onSaved: (val) => _password = val,
                obscureText: true,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Phone'),
                validator: (val) =>
                    val.length < 10 ? 'Phone number too short..' : null,
                onSaved: (val) => _password = val,
              ),
              RaisedButton(
                onPressed: _submitCommand,
                child: Text('Register'),
              ),
              FlatButton(
                onPressed: _redirectToLoginPage,
                child: Text('Have an account? Click here to login.'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
