import 'package:flutter/material.dart';
import 'LieuPage.dart';
import 'VisiteurLieuPage.dart';

class VisiteurAppo extends StatefulWidget {
   

  @override
  _VisiteurAppoState createState() => _VisiteurAppoState();
}

class _VisiteurAppoState extends State<VisiteurAppo> {
  List<String> medicalSpecialties = [
    'Osteology',
    'Cardiology',
    'Pulmonology',
    'Facial Plastic Surgery',
    'Rhinology',
    'Otology',
    'Gynecology',
    'Dentist',
    'Orthopedics',
    'Hepatology',
    'Ophthalmology',
    'Urology',
    'Diabetes',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Let\'s Find Your Specialist',
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: medicalSpecialties.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VisiteurLieuPage(speciality: medicalSpecialties[index])),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: Color.fromARGB(255, 44, 139, 240)),
                ),
                padding: EdgeInsets.all(12.0),
                child: Text(
                  medicalSpecialties[index],
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}