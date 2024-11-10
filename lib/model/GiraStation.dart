class GiraStation {
  String stationId;
  String name;
  double latitude;
  double longitude;
  int numDocas;
  int numBicicletas;
  String updateDate;

  GiraStation({
    required this.stationId,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.numDocas,
    required this.numBicicletas,
    required this.updateDate,
  });

  factory GiraStation.fromJson(Map<String, dynamic> json) {
    return GiraStation(
      stationId: json['properties']['id_expl'],
      name: json['properties']['desig_comercial'],
      latitude: json['geometry']['coordinates'][0][1],
      longitude: json['geometry']['coordinates'][0][0],
      numDocas: json['properties']['num_docas'],
      numBicicletas: json['properties']['num_bicicletas'],
      updateDate: json['properties']['update_date'],
    );
  }
}
