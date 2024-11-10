import 'package:projeto1/model/Report.dart';

class ParkingLot {
  String parkId;
  String name;
  bool isActive;
  int entityId;
  int maxCapacity;
  int occupation;
  DateTime occupationDate;
  double latitude;
  double longitude;
  String parkType;
  List<Report>? reportsList;
  bool isFavorite;

  ParkingLot({
    required this.parkId,
    required this.name,
    required this.isActive,
    required this.entityId,
    required this.maxCapacity,
    required this.occupation,
    required this.occupationDate,
    required this.latitude,
    required this.longitude,
    required this.parkType,
    this.reportsList,
    this.isFavorite = false,
  });

  factory ParkingLot.fromJson(Map<String, dynamic> json) {
    return ParkingLot(
      parkId: json['id_parque'],
      name: json['nome'],
      isActive: json['activo'] == 1,
      entityId: json['id_entidade'],
      maxCapacity: json['capacidade_max'],
      occupation: json['ocupacao'],
      occupationDate: DateTime.parse(json['data_ocupacao']),
      latitude: double.parse(json['latitude']),
      longitude: double.parse(json['longitude']),
      parkType: json['tipo'],
    );
  }

  void addReport(Report report) {
    if (reportsList == null) {
      reportsList = [report];
    } else {
      reportsList!.add(report);
    }
  }
}
