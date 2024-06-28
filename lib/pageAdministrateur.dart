import 'package:flutter/material.dart';
import 'PatientsList.dart';
import 'DoctorsList.dart';
import 'ClaimsPage.dart';
import 'StatisticsPage.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Administrator Dashboard'),
        centerTitle: true,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(16.0),
        childAspectRatio: 8.0 / 9.0,
        children: [
  _buildCard('Patients', Icons.group, context, '/patientsList'),
  _buildCard('Doctors', Icons.local_hospital, context, '/doctorsList'),
  _buildCard('Claims', Icons.report, context, '/claims'),
  _buildCard('Statistics', Icons.bar_chart, context, '/statistics'),
],

      ),
    );
  }

  Widget _buildCard(
      String title, IconData icon, BuildContext context, String route) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          if (route == '/patientsList') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PatientsList()),
            );
          } else if (route == '/doctorsList') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DoctorsList()),
            );
          } else if (route == '/claims') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ClaimsPage()),
            );
          } else if (route == '/statistics') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StatisticsPage()),
            );
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Icon(icon, size: 50.0, color: Colors.blue),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(title, style: TextStyle(fontSize: 16.0)),
            ),
          ],
        ),
      ),
    );
  }
}
