import 'package:flutter/material.dart';
import 'package:projeto1/model/ParkingLot.dart';
import 'package:projeto1/model/Report.dart';
//import 'package:projeto1/repository/parks_repository.dart';
import 'package:collection/collection.dart';
import 'package:provider/provider.dart';
import 'package:projeto1/providers/ParkingLotProvider.dart';

final _formKey = GlobalKey<FormState>();

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  String _selectedItem = 'Combatentes';
  DateTime _selectedDate = DateTime.now();
  double _sliderValue = 3;
  TextEditingController _notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registo de Incidentes"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Consumer<ParkingLotProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            return Form(
              key: _formKey,
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectedItem,
                    onChanged: (value) {
                      setState(() {
                        _selectedItem = value!;
                      });
                    },
                    items: provider.parks
                        .map((parkLot) => DropdownMenuItem<String>(
                              value: parkLot.name,
                              child: Text(parkLot.name),
                            ))
                        .toList(),
                    decoration:
                        const InputDecoration(labelText: 'Local do Incidente'),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Gravidade - 1 a 5',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Slider(
                    value: _sliderValue,
                    min: 1,
                    max: 5,
                    divisions: 4,
                    onChanged: (value) {
                      setState(() {
                        _sliderValue = value;
                      });
                    },
                    label: _sliderValue.toString(),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: Colors.grey,
                      ),
                    ),
                    child: ListTile(
                      title: const Text(
                        'Select Date',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
                      onTap: () {
                        _selectDate(context);
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                      controller: _notesController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter something';
                        }
                        return null;
                      },
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Notas',
                        contentPadding: EdgeInsets.symmetric(vertical: 20.0),
                        border: OutlineInputBorder(),
                      )),
                  const Spacer(),
                  ElevatedButton(
                      onPressed: () => _submitReport(context),
                      child: const Text('Submeter'))
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _submitReport(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      String location = _selectedItem;
      DateTime date = _selectedDate;
      int level = _sliderValue.toInt();
      String? description =
          _notesController.text.isNotEmpty ? _notesController.text : null;

      final provider = Provider.of<ParkingLotProvider>(context, listen: false);
      ParkingLot? selectedParkingLot = provider.parks.firstWhereOrNull(
        (parkLot) => parkLot.name == _selectedItem,
      );

      if (selectedParkingLot != null) {
        Report report = Report(
            location: location,
            date: date,
            level: level,
            description: description);

        provider.addReport(selectedParkingLot, report);

        _formKey.currentState!.reset();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Submetido com sucesso'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Local do Incidente não encontrado'),
          ),
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }
}
