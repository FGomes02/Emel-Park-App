import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:projeto1/model/ParkingLot.dart';
//import 'package:projeto1/repository/parks_repository.dart';
import 'package:projeto1/pages/park-details-page.dart';
import 'package:provider/provider.dart';
import 'package:projeto1/providers/ParkingLotProvider.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          child: Center(
            child: SvgPicture.asset(
              'assets/emel-logo.svg',
              height: 45,
            ),
          ),
        ),
      ),
      body: Consumer<ParkingLotProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.parks.isEmpty) {
            return const Center(child: Text('No parks found.'));
          }

          ParkingLot closestParkingLot = _getClosestParkingLot(provider.parks);
          List<ParkingLot> favoriteParkingLots =
              _getFavoriteParkingLots(provider.parks);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                _buildSectionTitle('Parque mais próximo:'),
                _buildParkingLotCard(context, closestParkingLot),
                const SizedBox(height: 35),
                _buildFavoritesSection(context, favoriteParkingLots),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildParkingLotCard(BuildContext context, ParkingLot parkingLot) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Image.asset(
          'assets/parque-image.jpg',
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
        title: Text(parkingLot.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Capacidade: ${parkingLot.occupation}/${parkingLot.maxCapacity}'),
            Text('Tipo: ${parkingLot.parkType}'),
            const Text(
                'Distancia: 200m'), // You may want to update this based on actual data
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ParkDetailsPage(parkingLot: parkingLot),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFavoritesSection(
      BuildContext context, List<ParkingLot> favoriteParkingLots) {
    if (favoriteParkingLots.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Favoritos:'),
          Column(
            children: favoriteParkingLots
                .map((parkingLot) => _buildParkingLotCard(context, parkingLot))
                .toList(),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Favoritos:'),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Center(
              child: Text(
                'Adicione parques aos seus favoritos',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ],
      );
    }
  }

  ParkingLot _getClosestParkingLot(List<ParkingLot> parks) {
    // Implement your logic to find the closest parking lot
    return parks.first;
  }

  List<ParkingLot> _getFavoriteParkingLots(List<ParkingLot> parks) {
    return parks.where((parkingLot) => parkingLot.isFavorite).toList();
  }
}
