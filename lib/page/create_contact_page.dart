import 'package:flutter/material.dart';
import 'package:private_nanny/model/utilisateur.dart';
import 'package:private_nanny/service/UserService.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class CreatNewContact extends StatefulWidget {
  CreatNewContact({
    Key key,
  }) : super(key: key);

  @override
  _CreatNewContactState createState() => _CreatNewContactState();
}

class _CreatNewContactState extends State<CreatNewContact> {
  Utilisateur selectedValue;

  List<Utilisateur> users;

  @override
  void initState() {
    super.initState();

    setState(() {
      users = [UserService.currentUser];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ajout d'un contact"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SearchableDropdown(
              hint: Text("search"),
              items: users.map((item) {
                return new DropdownMenuItem<Utilisateur>(
                    child: Text(item.displayName), value: item);
              }).toList(),
              isExpanded: true,
              value: selectedValue,
              isCaseSensitiveSearch: true,
              searchHint: new Text(
                'Select ',
                style: new TextStyle(fontSize: 20),
              ),
              onChanged: (value) {
                setState(() {
                  selectedValue = value;
                  print(selectedValue);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
