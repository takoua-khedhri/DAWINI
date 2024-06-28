import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class EmrgencyPage extends StatefulWidget {
  @override
  _EmergencyPageState createState() => _EmergencyPageState();
}

class _EmergencyPageState extends State<EmrgencyPage> {
  String _location = 'Fetching location...';
  String _hospitalName = 'Nearest Hospital';
  int _emptyRooms = 0;

  List<Map<String, dynamic>> hospitals = [
    {'name': 'City Hospital', 'emptyRooms': 5},
    {'name': 'Regional Health Center', 'emptyRooms': 3},
    {'name': 'Saint Mary\'s Hospital', 'emptyRooms': 2},
    {'name': 'General Hospital', 'emptyRooms': 7},
  ];

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _location = 'Location services are disabled.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _location = 'Location permissions are denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() => _location = 'Location permissions are permanently denied, we cannot request permissions.');
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() => _location = '${position.latitude}, ${position.longitude}');
    _selectHospital();  
  }

  void _selectHospital() {
    var selectedHospital = hospitals.first;
    setState(() {
      _hospitalName = selectedHospital['name'];
      _emptyRooms = selectedHospital['emptyRooms'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emergency Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Your Location:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(_location, style: TextStyle(fontSize: 16)),
            SizedBox(height: 30),
            Text(
              'Nearest Hospital:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(_hospitalName, style: TextStyle(fontSize: 16)),
            SizedBox(height: 30),
            Text(
              'Empty Rooms Available:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(_emptyRooms.toString(), style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}