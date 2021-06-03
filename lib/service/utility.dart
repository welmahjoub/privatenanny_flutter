import 'package:private_nanny/model/task.dart';
import 'package:private_nanny/model/utilisateur.dart';
import 'package:private_nanny/service/UserService.dart';

class Utility {
  static Task splitSpeechText(String text) {
    text = text.toLowerCase();
    //String text = "prévient thomas de s'habiller à 17H pour le rugby";
    List<String> textes = text.split(" ");

    List<String> Allcontacts =
        UserService.currentUser.contacts.map((e) => e.displayName).toList();
    String dateString = text.replaceAll(new RegExp(r'[^0-9]'), '');
    int date = int.parse("17"); //17

    //if (text.toLowerCase().contains("moi"))

    List<String> receiversName =
        textes.where((item) => Allcontacts.contains(item)).toList(); // thomas

    List<Utilisateur> receivers = UserService.currentUser.contacts
        .where((element) => receiversName.contains(element.displayName))
        .toList();

    Task task = Task.withParam(
        text, text, new DateTime.now(), UserService.currentUser, receivers);

    return task;
  }
}
