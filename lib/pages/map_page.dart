import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:projeto1/model/ParkingLot.dart';
import 'package:projeto1/model/GiraStation.dart';
import 'package:projeto1/pages/gira_station_details.dart';
import 'package:projeto1/pages/park-details-page.dart';
import 'package:projeto1/services/ListService.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const GoogleMapWidget();
  }
}

class GoogleMapWidget extends StatefulWidget {
  const GoogleMapWidget({Key? key}) : super(key: key);

  @override
  _GoogleMapWidgetState createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(38.71667, -9.13333);

  List<Marker> _markers = [];
  bool _showFirstApi = true;
  String _title = "Mapa de Parques EMEL";

  final ApiService apiService = ApiService();
  final GiraApiService giraApiService = GiraApiService();

  @override
  void initState() {
    super.initState();
    _fetchMarkers();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _fetchMarkers() async {
    List<Marker> markers;
    if (_showFirstApi) {
      final parks = await apiService.fetchParks();
      markers = parks
          .map((park) => Marker(
                markerId: MarkerId(park.parkId),
                position: LatLng(park.latitude, park.longitude),
                infoWindow: InfoWindow(
                  title: park.name,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ParkDetailsPage(parkingLot: park),
                      ),
                    );
                  },
                ),
              ))
          .toList();
    } else {
      final stations = await giraApiService.fetchStations();
      markers = stations
          .map((station) => Marker(
                markerId: MarkerId(station.stationId),
                position: LatLng(station.latitude, station.longitude),
                infoWindow: InfoWindow(
                  title: station.name,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GiraStationDetails(
                          giraStation: station,
                        ),
                      ),
                    );
                  },
                ),
              ))
          .toList();
    }

    setState(() {
      _markers = markers;
      _title = _showFirstApi ? "Mapa de Parques EMEL" : "Mapa de Parques GIRA";
    });
  }

  void _toggleMarkers() {
    setState(() {
      _showFirstApi = !_showFirstApi;
    });
    _fetchMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 13.0,
            ),
            markers: Set<Marker>.of(_markers),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: FloatingActionButton(
              onPressed: _toggleMarkers,
              child: const Icon(Icons.swap_horiz),
            ),
          ),
        ],
      ),
    );
  }
}
