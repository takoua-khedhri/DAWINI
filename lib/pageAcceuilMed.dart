import 'package:flutter/material.dart';
import 'pageProfileMed.dart';
import 'MedlistAppointment.dart';
import 'PatientRecordsPage.dart';

class PageAcceuilMed extends StatefulWidget {
  @override
  _PageAcceuilMedState createState() => _PageAcceuilMedState();
}

class _PageAcceuilMedState extends State<PageAcceuilMed> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 2) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => PageProfileMed()));
    }
  }

  Widget _buildIconButton(String imagePath, String label, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => label == 'My Appointment' ? MedlistAppointment() :
                                 label == 'Patient Records' ? MedlistAppointment() : Container(),
        ));
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        elevation: 4.0,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Image.asset(imagePath, width: 60, height: 60),
              SizedBox(height: 8),
              Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('What do you need?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Wrap(
                alignment: WrapAlignment.spaceEvenly,
                children: [
                  _buildIconButton('assets/images/appointment.png', 'My Appointment', context),
                  _buildIconButton('assets/images/dossier.png', 'Patient Records', context),
                  _buildIconButton('assets/images/messages.png', 'Messages', context),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
