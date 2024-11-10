import 'package:flutter/material.dart';
import 'package:projeto1/model/ParkingLot.dart';
import 'package:projeto1/model/Report.dart';
import 'package:projeto1/services/ListService.dart';

class ParkingLotProvider with ChangeNotifier {
  List<ParkingLot> _parks = [];
  bool _isLoading = false;

  List<ParkingLot> get parks => _parks;
  bool get isLoading => _isLoading;

  final ApiService _apiService = ApiService();

  ParkingLotProvider() {
    fetchParks();
  }

  Future<void> fetchParks() async {
    _isLoading = true;
    notifyListeners();

    try {
      _parks = await _apiService.fetchParks();
    } catch (e) {
      // Handle error
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateFavoriteStatus(ParkingLot parkingLot, bool isFavorite) {
    final index = _parks.indexWhere((p) => p.parkId == parkingLot.parkId);
    if (index != -1) {
      _parks[index].isFavorite = isFavorite;
      notifyListeners();
    }
  }

  void addReport(ParkingLot parkingLot, Report report) {
    final index = _parks.indexWhere((p) => p.parkId == parkingLot.parkId);
    if (index != -1) {
      _parks[index].addReport(report);
      notifyListeners();
    }
  }
}
