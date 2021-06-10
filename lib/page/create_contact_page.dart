import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:private_nanny/model/group.dart';
import 'package:private_nanny/model/utilisateur.dart';
import 'package:private_nanny/page/contact.dart';
import 'package:private_nanny/page/home.dart';
import 'package:private_nanny/page/widgets.dart';
import 'package:private_nanny/service/UserService.dart';
import 'package:private_nanny/service/auth.dart';
import 'package:private_nanny/service/groups.dart';
import 'package:private_nanny/widget/popover.dart';

class ContactFormPage extends StatefulWidget {
  @override
  State createState() => new _contactFormPageState();
  ContactFormPage({Key key}) : super(key: key);
  Group group;
  bool editable;
}

class _contactFormPageState extends State<ContactFormPage> {
  List<Utilisateur> _usersSelected;
  List<Utilisateur> users;

  final Widgets _widgets = Widgets();
  final AuthService _authService = AuthService();
  List _filterContactList = [];
  bool editable;
  UserService back = UserService();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    // todo : ne pas afficher les users qui sont deja en contacts avec lui
    super.initState();
    back.getAllUser().then((liste) {
      liste.forEach((element) {
        if (!UserService.currentUser.contacts.contains(element))
          _filterContactList.add(element);
      });
    });
    _usersSelected = [];
  }

  @override
  Widget build(BuildContext context) {
    String _title;

    _title = "Nouveau Contact";
    return Scaffold(
        appBar: _widgets.appBar(context, _title),
        drawer: _widgets.drawer(context, _authService),
        floatingActionButton: _buildRegisterButton(),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 32),
            child: Column(
              children: [
                _buildUsers(),
              ],
            ),
          ),
        ));
  }

  Widget _buildUsers() {
    final userChipList = <Widget>[];

    _usersSelected?.forEach((element) {
      userChipList.add(InputChip(
        label: Text(element.displayName),
        deleteIcon: Icon(
          Icons.remove_circle,
        ),
        onDeleted: () {
          setState(() {
            _usersSelected.remove(element);
          });
        },
      ));
    });

    return Container(
      child: Column(
        children: [
          Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.start,
            spacing: 5,
            children: userChipList,
          ),
          Visibility(
            child: Container(
              child: ElevatedButton.icon(
                  onPressed: () {
                    showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(builder: (BuildContext context,
                              StateSetter setModalState) {
                            return Popover(
                                child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 20),
                                  child: Text(
                                    'Ajouter un contact ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: TextField(
                                    onChanged: (value) {
                                      setModalState(() {
                                        // Fixme correction du filtre
                                        _filterContactList = _filterContactList
                                            .where((user) => user.displayName
                                                .toLowerCase()
                                                .contains(value))
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
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return CheckboxListTile(
                                              title: Text(
                                                  _filterContactList[index]
                                                      .displayName),
                                              subtitle: Text(
                                                  _filterContactList[index]
                                                      .phoneNo),
                                              onChanged: (value) {
                                                setState(() {
                                                  if (!_usersSelected.contains(
                                                      _filterContactList[
                                                          index]))
                                                    _usersSelected.add(
                                                        _filterContactList[
                                                            index]);
                                                  else
                                                    _usersSelected.remove(
                                                        _filterContactList[
                                                            index]);
                                                });
                                                setModalState(() {
                                                  _usersSelected =
                                                      _usersSelected;
                                                });
                                              },
                                              value: _usersSelected.contains(
                                                  _filterContactList[index]),
                                            );
                                          },
                                        )
                                      : Center(
                                          child: Text("no users to add "),
                                        ),
                                ),
                              ],
                            ));
                          });
                        });
                  },
                  icon: Icon(Icons.add, size: 18),
                  label: Text('Ajouter un contact')),
            ),
            visible: true,
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        _sendGroup(context);
      },
      label: const Text('Enregistrer'),
      icon: const Icon(Icons.save),
      backgroundColor: Colors.green,
    );
  }

  void _sendGroup(BuildContext context) {
    print(_usersSelected.length);

    _usersSelected.forEach((contact) {
      back.addUserToContact(UserService.currentUser.uid, contact).then((value) {
        print(value.statusCode);
      });
      UserService.currentUser.contacts.add(contact);
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(_buildSnackBar('Les contacts ont été bien crés'));

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ContactScreen()));
  }

  Widget _buildSnackBar(text) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(text),
    );
  }
}
