import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto1/model/GiraStation.dart';
import 'package:projeto1/model/GiraIncident.dart';
import 'package:projeto1/providers/incident_provider.dart';
import 'package:provider/provider.dart';

class GiraStationDetails extends StatefulWidget {
  final GiraStation giraStation;

  const GiraStationDetails({Key? key, required this.giraStation})
      : super(key: key);

  @override
  _GiraStationDetailsState createState() => _GiraStationDetailsState();
}

class _GiraStationDetailsState extends State<GiraStationDetails> {
  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  void _registerIncident(BuildContext context) {
    String description = '';
    String problemType = 'Bicicleta vandalizada';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Registrar Incidente'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: 'Descrição'),
                    minLines: 2,
                    maxLines: 5,
                    onChanged: (value) {
                      setState(() {
                        description = value;
                      });
                    },
                  ),
                  DropdownButton<String>(
                    value: problemType,
                    onChanged: (String? newValue) {
                      setState(() {
                        problemType = newValue!;
                      });
                    },
                    items: <String>[
                      'Bicicleta vandalizada',
                      'Doca não libertou bicicleta',
                      'Outra situação'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (description.length >= 20) {
                      Provider.of<IncidentProvider>(context, listen: false)
                          .addIncident(
                        widget.giraStation.stationId,
                        GiraIncident(
                          stationId: widget.giraStation.stationId,
                          description: description,
                          problemType: problemType,
                          date: DateTime.now(),
                        ),
                      );
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Incidente registrado com sucesso!')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'A descrição deve ter no mínimo 20 caracteres.')),
                      );
                    }
                  },
                  child: const Text('Registrar'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.giraStation.name),
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
                  image: AssetImage('assets/Gira.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Número de docas: ${widget.giraStation.numDocas}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Número de bicicletas: ${widget.giraStation.numBicicletas}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Morada: ${widget.giraStation.name}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Última atualização: ${formatDate(DateTime.parse(widget.giraStation.updateDate))}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            const Text(
              'Incidentes:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Consumer<IncidentProvider>(
                builder: (context, incidentProvider, child) {
                  final incidents = incidentProvider
                          .incidents[widget.giraStation.stationId] ??
                      [];
                  return incidents.isNotEmpty
                      ? ListView.builder(
                          itemCount: incidents.length,
                          itemBuilder: (context, index) {
                            final incident = incidents[index];
                            return Card(
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tipo: ${incident.problemType}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 5),
                                    Text('Data: ${formatDate(incident.date)}'),
                                    const SizedBox(height: 5),
                                    Text('Descrição: ${incident.description}'),
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
                        );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _registerIncident(context),
        child: const Icon(Icons.report_problem),
      ),
    );
  }
}
