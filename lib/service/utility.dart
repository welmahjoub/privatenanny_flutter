import 'package:private_nanny/model/task.dart';
import 'package:private_nanny/model/utilisateur.dart';
import 'package:private_nanny/service/UserService.dart';

class Utility {
  static Task splitSpeechText(String text) {
    text = text.toLowerCase();
    //String text = "prévient thomas de s'habiller à 17H pour le rugby";
    List<String> textes = text.split(" ");
    var date = new DateTime.now();
    List<String> Allcontacts = UserService.currentUser.contacts
        .map((e) => e.displayName.toLowerCase())
        .toList();
    String dateString = text.replaceAll(new RegExp(r'[^0-9]'), '');

    if (dateString.isNotEmpty) {
      int hours = int.parse(dateString); //17
      date = new DateTime(date.year, date.month, date.day, hours, 0, 0);
      print(date.toString());
    }

    List<String> receiversName = textes
        .where((item) => Allcontacts.contains(item.toLowerCase()))
        .toList(); // thomas

    print(receiversName.toString());

    List<Utilisateur> receivers = UserService.currentUser.contacts
        .where((element) =>
            receiversName.contains(element.displayName.toLowerCase()))
        .toList();

    if (text.toLowerCase().contains("moi")) {
      receivers.add(UserService.currentUser);
    }

    print(receivers.toString());
    Task task =
        Task.withParam(text, text, date, UserService.currentUser, receivers);

    return task;
  }
}
