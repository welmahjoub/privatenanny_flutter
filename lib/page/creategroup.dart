import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:private_nanny/model/group.dart';
import 'package:private_nanny/model/utilisateur.dart';
import 'package:private_nanny/page/home.dart';
import 'package:private_nanny/page/widgets.dart';
import 'package:private_nanny/service/UserService.dart';
import 'package:private_nanny/service/auth.dart';
import 'package:private_nanny/service/groups.dart';
import 'package:private_nanny/widget/popover.dart';

class GroupFormPage extends StatefulWidget {
  @override
  State createState() => new _GroupFormPageState();
  GroupFormPage({Key key, this.group, this.editable}) : super(key: key);
  Group group;
  bool editable;

}

class _GroupFormPageState extends State<GroupFormPage> {
  List<Utilisateur> _usersSelected;
  final TextEditingController _nameController = new TextEditingController();
  final _textfieldFormKey = GlobalKey<FormState>();
  final Widgets _widgets = Widgets();
  final AuthService _authService = AuthService();
  final GroupService _groupService = GroupService();
  List _filterContactList;
  bool editable;

  @override
  void dispose() {
    super.dispose();
    _nameController?.dispose();
  }

  @override
  void initState() {
    super.initState();

    _usersSelected = widget.group.groupMembers != null
        ? widget.group.groupMembers
        : _usersSelected = [];
    _filterContactList = UserService.currentUser.contacts;

    // initiate receivers
    _usersSelected = widget.group.groupMembers == null ? [] : widget.group.groupMembers;

    // initiate text controller
    _nameController.text = widget.group.groupName;
    _nameController
        .addListener(() => widget.group.groupName = _nameController.text);
  }

  @override
  Widget build(BuildContext context) {
    String _title;
    if (widget.editable){
      _title = "Modification du groupe";
    } else {
      _title = "Nouveau groupe";
    }
    return Scaffold(
        appBar: _widgets.appBar(context, _title),
        drawer: _widgets.drawer(context, _authService),
        floatingActionButton: _buildRegisterButton(),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 32),
            child: Column(
              children: [
                _buildTextFields(),
                Divider(
                  height: 30,
                  thickness: 1,
                ),
                _buildUsers(),
              ],
            ),
          ),
        ));
  }

  Widget _buildTextFields() {
    return Container(
        child: Form(
          key: _textfieldFormKey,
          child: Column(
            children: [
              Container(
                child: TextFormField(
                  maxLength: 30,
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Il faut au moins l\'intitulé';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    labelText: 'Intitulé',
                  ),
                ),
              ),
            ],
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
        onDeleted:  () {
          setState(() {
            _usersSelected.remove(element);
          });
        },
      ));
    });

    return Container(
      child: Column(
        children: [
          Container(
            child: Align(
              child: Text('Groupe contenant : '),
              alignment: Alignment.centerLeft,
            ),
          ),
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
                                        'Ajouter un contact au groupe',
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
                                            _filterContactList = UserService
                                                .currentUser.contacts
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
                                        child: CircularProgressIndicator(),
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
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        if (_textfieldFormKey.currentState.validate()) {
            _sendGroup(context);
        }
      },
      label: const Text('Enregistrer'),
      icon: const Icon(Icons.save),
      backgroundColor: Colors.green,
    );
  }

  void _sendGroup(BuildContext context) {
    if (!widget.editable) {
      widget.group.groupOwner = UserService.currentUser;
      widget.group.groupMembers = _usersSelected;
      print("nom : " + widget.group.groupName);
      print("Membres : " + widget.group.groupMembers.toString());
      print("Owner : " + widget.group.groupOwner.toString());

      //print(widget.group.toJson().toString());
      _groupService.createGroup(widget.group).then((value) {
        if ([200, 201, 202].contains(value.statusCode)) {
          ScaffoldMessenger.of(context).showSnackBar(
              _buildSnackBar('Le groupe a été bien créé'));
          UserService user = UserService();
          user.updateCurretUser(UserService.currentUser.uid);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        } else
          ScaffoldMessenger.of(context)
              .showSnackBar(_buildSnackBar('Une erreur s\'est produite'));
      }).onError((error, stackTrace) {
        ScaffoldMessenger.of(context)
            .showSnackBar(_buildSnackBar('Une erreur s\'est produite'));
      });
    }
    else{
      print(widget.group);
      _groupService.updateGroup(widget.group).then((value) {
        if ([201, 202, 200].contains(value.statusCode)) {
          ScaffoldMessenger.of(context)
              .showSnackBar(_buildSnackBar('Le groupe a bien été modifié'));
        } else
          ScaffoldMessenger.of(context)
              .showSnackBar(_buildSnackBar('Une erreur s\'est produite'));
      }).onError((error, stackTrace) {
        ScaffoldMessenger.of(context)
            .showSnackBar(_buildSnackBar('Une erreur s\'est produite'));
      });
    }
  }

  Widget _buildSnackBar(text) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(text),
    );
  }
}
