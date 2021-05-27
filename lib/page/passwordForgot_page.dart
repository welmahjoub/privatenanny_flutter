import 'package:flutter/material.dart';

// Forgot Password page
class ForgotPwd extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Enter your email to reset password'),
      ),
      body: new Center(
        child: new Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
              child: new TextField(
                decoration: new InputDecoration(labelText: 'Email'),
              ),
            ),

            // Make api call to resend password and take user back to Login Page
            new FlatButton(
                onPressed: () {
                  //api call to reset password or whatever
                  Navigator.of(context).pop();
                },
                child: new Text("Resend Passcode")),
          ],
        ),
      ),
    );
  }
}
