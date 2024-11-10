import 'package:flutter/material.dart';
import 'package:projeto1/model/GiraIncident.dart';

class IncidentProvider with ChangeNotifier {
  final Map<String, List<GiraIncident>> _incidents = {};

  Map<String, List<GiraIncident>> get incidents => _incidents;

  void addIncident(String stationId, GiraIncident incident) {
    if (!_incidents.containsKey(stationId)) {
      _incidents[stationId] = [];
    }
    _incidents[stationId]!.add(incident);
    notifyListeners();
  }
}
