class Report {
  String location;
  DateTime date;
  int level;
  String? description;

  Report(
      {required this.location,
      required this.date,
      required this.level,
      this.description});
}
