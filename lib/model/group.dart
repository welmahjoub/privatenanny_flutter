import 'package:private_nanny/model/utilisateur.dart';

class Group {
  int id;
  String groupName;
  Utilisateur groupOwner;
  List<Utilisateur> groupMembers;

  Group.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        groupName = json['groupName'],
        groupOwner = json['groupOwner'],
        groupMembers = (json['groupMembers'] as List)
            .map((data) => Utilisateur.fromJson(data))
            .toList();
}
