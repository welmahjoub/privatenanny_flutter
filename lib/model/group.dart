import 'package:private_nanny/model/utilisateur.dart';

class Group {
  int id;
  String groupName;
  //Utilisateur groupOwner;
  List<Utilisateur> members;

  Group.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        groupName = json['groupName'];
}
