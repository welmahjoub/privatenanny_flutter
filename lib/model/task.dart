import 'package:private_nanny/model/utilisateur.dart';

class Task {
  int id;
  String detail;
  String title;
  List<Utilisateur> receivers;
  String action;
  bool repeat;
  int repeatitionNumber;
  DateTime createdAt;
  DateTime validatedAt;
  bool isValidated;
  int delayBetweenRepetition;
  DateTime dateTime;

  Utilisateur user;

  Task.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        detail = json['detail'],
        title = json['title'],
        receivers = (json['receivers'] as List).map((data) => Utilisateur.fromJson(data)).toList(),
        action = json['action'],
        repeat = json['repeat'],
        repeatitionNumber = json['repeatitionNumber'],
        createdAt = ((json['createdAt']) != null ? DateTime?.tryParse(json['createdAt']) : null),
        validatedAt = ((json['validatedAt']) != null ? DateTime?.tryParse(json['validatedAt']) : null),
        isValidated = json['isValidated'],
        delayBetweenRepetition = json['delayBetweenRepetition'],
        dateTime = ((json['dateTime']) != null ? DateTime?.tryParse(json['dateTime']) : null);

  Task.withParam(this.title, this.detail, this.dateTime, this.user, this.receivers) {
    this.action = 'NOTIFICATION';
    // Todo ajouter un champ sur l'interface
    this.repeatitionNumber = 1;
    this.delayBetweenRepetition = 0;
    this.isValidated = false;
    this.repeat = false;
  }

  Task() {
    // Todo ajouter un champ sur l'interface
    this.repeatitionNumber = 1;
    this.delayBetweenRepetition = 0;
    this.title = '';
    this.detail = '';
    this.action = 'NOTIFICATION';
    this.isValidated = false;
    this.repeat = false;
  }

  static Repeatition getFromDuration(int duration) {
    switch (duration) {
      case Duration.millisecondsPerHour:
        return Repeatition.hour;
      case Duration.millisecondsPerDay:
        return Repeatition.day;
      case Duration.millisecondsPerDay * 30:
        return Repeatition.month;
      case Duration.millisecondsPerDay * 7:
        return Repeatition.week;
      case Duration.millisecondsPerDay * 365:
        return Repeatition.year;
      default:
        return Repeatition.no;
    }
  }

  @override
  String toString() {
    return 'Task{user: $user, action: $action, detail: $detail, title: $title, receivers: $receivers, repeat: $repeat, repeatitionNumber: $repeatitionNumber, delayBetweenRepetition: $delayBetweenRepetition, dateTime: $dateTime, createdAt: $createdAt, isValidated: $isValidated}';
  }

  Map<String, dynamic>  toJson()  {
    List<Map<String, dynamic>> auxReceivers = receivers?.map((e) => e.toJson())?.toList();
    return {
      'user': user.toJson(),
      'action': action,
      'detail': detail,
      'title': title,
      'repeat': repeat,
      'repeatitionNumber': repeatitionNumber,
      'delayBetweenRepetition': delayBetweenRepetition,
      'dateTime': dateTime?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'isValidated': isValidated,
      'receivers': auxReceivers
    };
  }
}

enum Repeatition {
  no,
  hour,
  day,
  week,
  month,
  year
}

extension RepeatitionExtension on Repeatition {
  String get name {
    switch (this) {
      case Repeatition.hour:
        return 'Toutes les heures';
      case Repeatition.day:
        return 'Tous les jours';
      case Repeatition.month:
        return 'Tous les mois';
      case Repeatition.week:
        return 'Toutes les semaines';
      case Repeatition.year:
        return 'Tous les ans';
      default:
        return 'Ne pas r??p??ter';
    }
  }

  int get duration {
    switch (this) {
      case Repeatition.hour:
        return Duration.millisecondsPerHour;
      case Repeatition.day:
        return Duration.millisecondsPerDay;
      case Repeatition.month:
        return Duration.millisecondsPerDay * 30;
      case Repeatition.week:
        return Duration.millisecondsPerDay * 7;
      case Repeatition.year:
        return Duration.millisecondsPerDay * 365;
      default:
        return 0;
    }
  }
}