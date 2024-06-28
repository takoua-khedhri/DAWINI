import 'package:flutter/material.dart';
import 'authentificationPage.dart';
import 'connecterPage.dart';
import 'MedConnecterPage.dart';
import 'Inf_connecterPage.dart';

class ProfessionalList extends StatelessWidget {
  final List<Map<String, dynamic>> professionalList = [
    {'name': 'Doctor', 'description': 'General practitioner and specialists'},
    {'name': 'Nurse', 'description': 'Qualified nursing staff'},
    {'name': 'Physiotherapy Center', 'description': 'Rehabilitation and therapy services'},
    {'name': 'Emergency Service', 'description': 'Urgent care and emergency assistance'},
    {'name': 'Laboratory', 'description': 'Medical testing and analysis'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: professionalList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _navigateToAuthenticationPage(context, professionalList[index]['name']);
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                    elevation: 3.0,
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                      title: Text(
                        professionalList[index]['name'],
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        professionalList[index]['description'],
                        style: TextStyle(fontSize: 14.0),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToAuthenticationPage(BuildContext context, String userType) {
    switch (userType) {
      case 'Doctor':
        Navigator.push(context, MaterialPageRoute(builder: (context) => Med_ConnecterPage()));
        break;
      case 'Nurse':
        Navigator.push(context, MaterialPageRoute(builder: (context) => Inf_connecterPage()));
        break;
      case 'Physiotherapy Center':
        // Add navigation to the appropriate page for physiotherapy centers here
        break;
      case 'Emergency Service':
        // Add navigation to the appropriate page for emergency services here
        break;
      case 'Laboratory':
        // Add navigation to the appropriate page for laboratories here
        break;
      default:
        break;
    }
  }
}
