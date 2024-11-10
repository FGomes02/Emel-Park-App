import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projeto1/model/GiraStation.dart';
import 'package:projeto1/model/ParkingLot.dart';

class ApiService {
  final String apiUrl = "https://emel.city-platform.com/opendata/parking/lots";
  final String apiKey = "93600bb4e7fee17750ae478c22182dda";

  Future<List<ParkingLot>> fetchParks() async {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'accept': 'application/json',
        'api_key': apiKey,
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => ParkingLot.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load parks');
    }
  }
}

class GiraApiService {
  final String apiUrl =
      "https://emel.city-platform.com/opendata//gira/station/list";
  final String apiKey = "93600bb4e7fee17750ae478c22182dda";

  Future<List<GiraStation>> fetchStations() async {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'accept': 'application/json',
        'api_key': apiKey,
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['features'];
      return data.map((item) => GiraStation.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load stations');
    }
  }
}
