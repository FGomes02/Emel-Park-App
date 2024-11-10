class GiraIncident {
  final String stationId;
  final String description;
  final String problemType;
  final DateTime date;

  GiraIncident({
    required this.stationId,
    required this.description,
    required this.problemType,
    required this.date,
  });

  factory GiraIncident.fromJson(Map<String, dynamic> json) {
    return GiraIncident(
      stationId: json['stationId'],
      description: json['description'],
      problemType: json['problemType'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stationId': stationId,
      'description': description,
      'problemType': problemType,
      'date': date.toIso8601String(),
    };
  }
}
