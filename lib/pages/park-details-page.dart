import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto1/model/ParkingLot.dart';
import 'package:projeto1/repository/parks_repository.dart';
import 'package:provider/provider.dart';
import 'package:projeto1/providers/ParkingLotProvider.dart';

class ParkDetailsPage extends StatefulWidget {
  final ParkingLot parkingLot;

  const ParkDetailsPage({Key? key, required this.parkingLot}) : super(key: key);

  @override
  _ParkDetailsPageState createState() => _ParkDetailsPageState();
}

class _ParkDetailsPageState extends State<ParkDetailsPage> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.parkingLot.isFavorite;
  }

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.parkingLot.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: const DecorationImage(
                  image: AssetImage('assets/parque-image.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Ocupação: ${widget.parkingLot.occupation}/${widget.parkingLot.maxCapacity}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Tipo de Parque: ${widget.parkingLot.parkType}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Ultima Entrada: ${formatDate(widget.parkingLot.occupationDate)}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            const Text(
              'Incidentes:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: widget.parkingLot.reportsList != null &&
                      widget.parkingLot.reportsList!.isNotEmpty
                  ? ListView.builder(
                      itemCount: widget.parkingLot.reportsList?.length ?? 0,
                      itemBuilder: (context, index) {
                        final incident = widget.parkingLot.reportsList![index];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Local: ${incident.location}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 5),
                                Text('Data: ${formatDate(incident.date)}'),
                                const SizedBox(height: 5),
                                Text('Nível: ${incident.level}'),
                                if (incident.description != null) ...[
                                  const SizedBox(height: 5),
                                  Text('Descrição: ${incident.description}'),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        'Sem incidentes',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _toggleFavoriteStatus(context);
        },
        child: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: isFavorite ? Colors.red : null,
        ),
      ),
    );
  }

  void _toggleFavoriteStatus(BuildContext context) {
    final provider = Provider.of<ParkingLotProvider>(context, listen: false);

    setState(() {
      if (isFavorite) {
        widget.parkingLot.isFavorite = false;
        isFavorite = false;
        provider.updateFavoriteStatus(widget.parkingLot, false);
      } else {
        if (_countFavorites(provider.parks) < 3) {
          widget.parkingLot.isFavorite = true;
          isFavorite = true;
          provider.updateFavoriteStatus(widget.parkingLot, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Só pode ter 3 parques favoritos'),
            ),
          );
        }
      }
    });
  }

  int _countFavorites(List<ParkingLot> parks) {
    return parks.where((park) => park.isFavorite).length;
  }
}
