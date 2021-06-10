import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:private_nanny/model/group.dart';
import 'package:private_nanny/model/utilisateur.dart';
import 'package:private_nanny/service/UserService.dart';
import 'package:private_nanny/service/auth.dart';
import 'package:private_nanny/page/widgets.dart';
import 'package:private_nanny/widget/popover.dart';

class GroupEditPage extends StatefulWidget {
  @override
  State createState() => new _GroupEditPageState();

  GroupEditPage({Key key, this.group}) : super(key: key);
  Group group;
}

class _GroupEditPageState extends State<GroupEditPage> {
  final AuthService _authService = AuthService();
  final Widgets widgets = Widgets();
  List<Utilisateur> groupMembers = List();
  List _filterContactList;
  List<Utilisateur> _usersSelected;

  @override
  void initState() {
    super.initState();

    groupMembers = widget.group.groupMembers;
    _usersSelected = widget.group.groupMembers != null
        ? widget.group.groupMembers
        : _usersSelected = [];
    _filterContactList = UserService.currentUser.contacts;

    _usersSelected = widget.group.groupMembers == null ? []
    : widget.group.groupMembers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: widgets.appBar(context, widget.group.groupName),
        drawer: widgets.drawer(context, _authService),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          listReceivers(context),
          addContact(context)
        ])));
  }

  Widget listReceivers(BuildContext context) {
    return new ListView.builder(
        shrinkWrap: true,
        itemCount: groupMembers.length,
        itemBuilder: (BuildContext context, index) {
          return Card(
              child: ListTile(
            leading: Text(groupMembers[index].displayName),
            subtitle: Text(groupMembers[index].phoneNo),
            title: Text(groupMembers[index].email),
            trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {});
                }),
          ));
        });
  }

  Widget addContact(BuildContext context) {
    return new IconButton(
      alignment: Alignment.center,
      icon:
          Icon(Icons.add_circle_outline_rounded, color: Colors.green),
      onPressed: () {
        showModalBottomSheet(
            context: context,
            // ignore: missing_return
            builder: (BuildContext context) {
              return contactList(context);
            });
      },
    );
  }

  StatefulBuilder contactList(BuildContext context) {
    return new StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
      return Popover(
          child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 20),
            child: Text(
              'Ajouter un contact à la tâche',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            margin: EdgeInsets.only(bottom: 10),
            child: TextField(
              onChanged: (value) {
                setModalState(() {
                  // Fixme correction du filtre
                  _filterContactList = UserService.currentUser.contacts
                      .where((user) =>
                          user.displayName.toLowerCase().contains(value))
                      .toList();
                });
              },
              decoration: InputDecoration(
                  filled: true,
                  labelText: 'Contact',
                  hintText: 'nom ou prénom'),
            ),
          ),
          Container(
            height: 400,
            child: _filterContactList.length > 0
                ? ListView.builder(
                    itemCount: _filterContactList.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return CheckboxListTile(
                        title: Text(_filterContactList[index].displayName),
                        subtitle: Text(_filterContactList[index].phoneNo),
                        onChanged: (value) {
                          setState(() {
                            if (!_usersSelected
                                .contains(_filterContactList[index]))
                              _usersSelected.add(_filterContactList[index]);
                            else
                              _usersSelected.remove(_filterContactList[index]);
                          });
                          setModalState(() {
                            _usersSelected = _usersSelected;
                          });
                        },
                        value:
                            _usersSelected.contains(_filterContactList[index]),
                      );
                    },
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
        ],
      ));
    });
  }
}
