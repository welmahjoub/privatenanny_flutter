import 'package:flutter/material.dart';
import 'package:private_nanny/model/group.dart';
import 'package:private_nanny/service/UserService.dart';

class CreatNewContact extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('création nouveau contact'),
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 30.0),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: 10.0),
                  // TextFormField(
                  //   decoration: InputDecoration(
                  //       labelText: 'Nom', border: OutlineInputBorder()),
                  // ),
                  // SizedBox(height: 10.0),
                  // TextFormField(
                  //   decoration: InputDecoration(
                  //       labelText: 'Prénom', border: OutlineInputBorder()),
                  // ),
                  // SizedBox(height: 10.0),
                  // TextFormField(
                  //   decoration: InputDecoration(
                  //       labelText: 'Téléphone', border: OutlineInputBorder()),
                  // ),
                  // SizedBox(height: 10.0),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Email', border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 20.0),
                  _buildGroups(),
                  SizedBox(height: 200.0),
                  FlatButton(
                    onPressed: () {
                      addContact();
                    },
                    color: Colors.green,
                    child: Text('Enregistrer'),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                  )
                ],
              ),
            )),
      ),
    );
  }

  void addContact() {
    UserService service = UserService();
    service.findUserByEmail("email@gmail.com").then((user) {
      service
          .addUserToContact(UserService.currentUser.uid, user)
          .then((response) => print(response.statusCode));
      service
          .addUserToGroup(UserService.currentUser.uid, new Group("GROUPE"))
          .then((value) => print(value.statusCode));
    });
  }

  Widget _buildGroups() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [MyStatefulWidget()],
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  String dropdownValue = 'Groupe';

  List<String> groups = [];

  @override
  void initState() {
    super.initState();

    setState(() {
      groups =
          UserService.currentUser?.groups?.map((e) => e.groupName)?.toList();
      groups.add('Groupe');
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.blue,
      ),
      iconSize: 30,
      elevation: 10000,
      style: const TextStyle(color: Colors.blue, fontSize: 15),
      underline: Container(
        height: 2,
        color: Colors.blue,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
          // call api methode
        });
      },
      items: groups.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
