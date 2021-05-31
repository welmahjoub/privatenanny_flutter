class Utilisateur {

  int id;
  String email;
  String displayName;
  String pseudo;
  List<Utilisateur> contacts;
  String phoneNo;

//List<Task> tasks;
//List<Group> groups;

  Utilisateur.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        email = json['email'],
        pseudo = json['pseudo'],
  displayName = json['displayName'],
  phoneNo = json['phoneNo'];

}
