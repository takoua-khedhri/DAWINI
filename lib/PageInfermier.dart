import 'package:flutter/material.dart';
import 'NurseListPage.dart';

class NurseSearchPage extends StatefulWidget {
  @override
  _NurseSearchPageState createState() => _NurseSearchPageState();
}

class _NurseSearchPageState extends State<NurseSearchPage> {
  String selectedLocation = '';
  String selectedSpecialty = '';
  String selectedWorkType = '';

  TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nurse Search'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Location:'),
            DropdownButton<String>(
              value: selectedLocation,
              onChanged: (String? newValue) {
                setState(() {
                  selectedLocation = newValue ?? "";
                });
              },
              items: <String>[
                'Tunis',
                'Ariana',
                'Beja',
                'Ben Arous',
                'Bizerte',
                'Sousse',
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
                'Tataouine',
                'Tozeur',
                'Zaghouan',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20.0),
            Text('Specialty:'),
            DropdownButton<String>(
              value: selectedSpecialty,
              onChanged: (String? newValue) {
                setState(() {
                  selectedSpecialty = newValue ?? "";
                });
              },
              items: <String>[
                'Emergency Care',
                'General Care',
                'Geriatric',
                'Pediatric'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20.0),
            Text('Work Type:'),
            DropdownButton<String>(
              value: selectedWorkType,
              onChanged: (String? newValue) {
                setState(() {
                  selectedWorkType = newValue ?? "";
                });
              },
              items: <String>['at home', 'at office']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListNursesPage(
                      location: selectedLocation,
                      specialty: selectedSpecialty,
                      workType: selectedWorkType,
                    ),
                  ),
                );
              },
              child: Text('Search'),
            ),
          ],
        ),
      ),
    );
  }
}
