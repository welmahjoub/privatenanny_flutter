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
  String _password = "";
  String _phone;
  String _username;
  String _name;

  @override
  void initState() {
    super.initState();

    _email = UserService.currentUser.email;
    _phone = UserService.currentUser.phoneNo;
    _username = UserService.currentUser.pseudo;
    _name = UserService.currentUser.displayName;
  }

  void _submitCommand() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      _updateAccountFirebase();
    }
  }

  void _updateAccountFirebase() {
    print("L'utilisateur veut modifier un compte avec $_email et $_password");
    AuthService _authService = AuthService();
    if (_password != "")
      _authService.auth.currentUser
          .updatePassword(_password)
          .then((value) => print("password has changed with succes"));

    _updateAccountBackend();
  }

  void _updateAccountBackend() {
    UserService back = UserService();
    var user = Utilisateur(_email, _name, _phone, _username);
    user.uid = UserService.currentUser.uid;
    back.updateUser(user).then((value) => print(value.statusCode));

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
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Prenom Nom '),
                onSaved: (val) => _name = val,
              ),
              TextFormField(
                initialValue: _username,
                decoration: InputDecoration(labelText: 'User Name'),
                onSaved: (val) => _username = val,
              ),
              TextFormField(
                initialValue: _email,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (val) => !EmailValidator.validate(val, true)
                    ? 'Email invalide.'
                    : null,
                onSaved: (val) => _email = val,
              ),
              TextFormField(
                initialValue: _phone,
                decoration: InputDecoration(labelText: 'Numéro de téléphone'),
                validator: (val) =>
                    val.length < 10 ? 'Numéro de téléphone trop court.' : null,
                onSaved: (val) => _phone = val,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Nouveau Mot de passe'),
                onSaved: (val) => _password = val,
                obscureText: true,
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
