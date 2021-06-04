import 'package:private_nanny/model/group.dart';

class Utilisateur {
  int id;
  String email;
  String uid;
  String displayName;
  String pseudo;
  List<Utilisateur> contacts;
  String phoneNo;

  //List<Task> tasks;
  List<Group> groups;

  Utilisateur(this.email, this.displayName, this.phoneNo, this.pseudo);

  Utilisateur.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        email = json['email'],
        uid = json['uid'],
        pseudo = json['pseudo'],
        displayName = json['displayName'],
        phoneNo = json['phoneNo'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'uid': uid,
    'email': email,
    'pseudo': pseudo,
    'displayName': displayName,
    'phoneNo': phoneNo
  };
}
