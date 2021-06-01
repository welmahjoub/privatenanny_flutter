class Utilisateur {
  int id;
  String email;
  String displayName;
  String pseudo;
  List<Utilisateur> contacts;
  String phoneNo;

//List<Task> tasks;
//List<Group> groups;

  Utilisateur(this.email, this.displayName, this.phoneNo, this.pseudo);

  Utilisateur.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        email = json['email'],
        pseudo = json['pseudo'],
        displayName = json['displayName'],
        phoneNo = json['phoneNo'];

  Map<String, dynamic> toJson() => {
    'email': email,
    'pseudo': pseudo,
    'displayName': displayName,
    'phoneNo': phoneNo
  };
}