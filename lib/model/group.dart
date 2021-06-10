import 'package:private_nanny/model/utilisateur.dart';

class Group {
  int id;
  String groupName;
  Utilisateur groupOwner;
  List<Utilisateur> groupMembers;

  Group.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        groupName = json['groupName'],
        /*groupOwner = json['groupOwner'],*/
        groupMembers = (json['groupMembers'] as List)
            .map((data) => Utilisateur.fromJson(data))
            .toList();


  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> auxMembers = groupMembers?.map((e) => e.toJson())
        ?.toList();
    return {
      'id': id,
      'groupName': groupName,
      'groupOwner': groupOwner.toJson(),
      'groupMembers': auxMembers
    };
  }
}
