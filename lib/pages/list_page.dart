import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto1/model/ParkingLot.dart';
import 'package:projeto1/pages/park-details-page.dart';
import 'package:provider/provider.dart';
import 'package:projeto1/providers/ParkingLotProvider.dart';

class ListPage extends StatelessWidget {
  const ListPage({Key? key}) : super(key: key);

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Parques"),
      ),
      body: Consumer<ParkingLotProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.parks.isEmpty) {
            return const Center(child: Text('No parks found.'));
          }

          return ListView.builder(
            itemCount: provider.parks.length,
            itemBuilder: (context, index) {
              final ParkingLot parkingLot = provider.parks[index];
              bool hasSpotsLeft =
                  parkingLot.occupation < parkingLot.maxCapacity;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ParkDetailsPage(parkingLot: parkingLot),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  child: ListTile(
                    title: Text(parkingLot.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Ocupação: ${parkingLot.occupation}/${parkingLot.maxCapacity}'),
                        Text('Tipo de Parque: ${parkingLot.parkType}'),
                        Text(
                            'Ultima Entrada: ${formatDate(parkingLot.occupationDate)}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          backgroundColor:
                              hasSpotsLeft ? Colors.green : Colors.red,
                          radius: 8,
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
