class Task {
  String detail;
  String title;
  bool repeat;
  int repeatitionNumber;
  Duration delayBetweenRepetition;
  DateTime dateTime;
  DateTime createdAt;
  bool isValidated;

  Task(this.title);
}