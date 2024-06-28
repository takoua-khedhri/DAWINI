import 'package:flutter/material.dart';
import 'MedecinListPage.dart';

class LieuPage extends StatefulWidget {
  final String speciality;
 final String? patientId;

  LieuPage({required this.speciality, this.patientId});

  

  @override
  _LieuPageState createState() => _LieuPageState();
}

class _LieuPageState extends State<LieuPage> {
  String? _selectedLocation;
  List<String> _governorates = [
    'Ariana',
    'Beja',
    'Ben Arous',
    'Bizerte',
    'Gabes',
    'Gafsa',
    'Jendouba',
    'Kairouan',
    'Kasserine',
    'Kebili',
    'Kef',
    'Mahdia',
    'Manouba',
    'Medenine',
    'Monastir',
    'Nabeul',
    'Sfax',
    'Sidi Bouzid',
    'Siliana',
    'Sousse',
    'Tataouine',
    'Tozeur',
    'Tunis',
    'Zaghouan'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Let\'s choose a location ',
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.speciality,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: ListView.builder(
                itemCount: _governorates.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedLocation = _governorates[index];
                      });
                      // Naviguer vers la page MedecinListPage avec les spécialités et le lieu sélectionnés
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MedecinListPage(
      speciality: widget.speciality,
      selectedLocation: _selectedLocation!,
      patientId: widget.patientId,
    ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Color.fromARGB(255, 44, 139, 240)),
                      ),
                      child: Text(
                        _governorates[index],
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
