import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'EmergencyAcceuil.dart';
import 'NurseAcceuil.dart';
import 'laboratoryAcceuilPage.dart';
import 'MedecinListPage.dart';
import 'apointment.dart';
import 'Barre_navPat.dart';
import 'userData.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'AllMedecinPage.dart';

class DoctorSearchScreen extends StatefulWidget {
  final bool showNavigationBar;
  final UserData? userData;

  DoctorSearchScreen({required this.userData, required this.showNavigationBar});

  @override
  _DoctorSearchScreenState createState() => _DoctorSearchScreenState();
}

class _DoctorSearchScreenState extends State<DoctorSearchScreen> {
  String _searchQuery = '';
  String? _selectedSpecialite;
  String? _selectedLieu;
  String? _selectedTypeMedecin;

  Future<void> _requestLocationPermission() async {
    final PermissionStatus status = await Permission.location.request();
    if (status != PermissionStatus.granted) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text("Location Permission Required"),
          content: Text("Please grant location permission to use this feature."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  void _addNotificationCallback(String message) {
    print("Nouvelle notification ajoutée : $message");
  }

  Future<Position?> _getCurrentLocation() async {
    try {
      return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      print("Error getting current location: $e");
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text("Error"),
          content: Text("Failed to get current location. Please try again later."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
      return null;
    }
  }

  Widget _buildDecoratedContainer(Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 236, 234, 239),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12),
      margin: EdgeInsets.only(bottom: 10.0),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              _buildDecoratedContainer(
                FutureBuilder<List<DropdownMenuItem<String>>>(
                  future: _getSpecialitesFromFirestore(context),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else {
                      if (snapshot.hasData) {
                        return DropdownButtonFormField<String>(
                          value: _selectedSpecialite,
                          decoration: InputDecoration(
                            labelText: 'Select medical specialty',
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              color: Color.fromARGB(255, 70, 69, 69),
                            ),
                          ),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedSpecialite = newValue;
                            });
                          },
                          items: snapshot.data!,
                        );
                      } else {
                        return Text('No specialty found.');
                      }
                    }
                  },
                ),
              ),
              SizedBox(height: 7.0),
              _buildDecoratedContainer(
                DropdownButtonFormField<String>(
                  value: _selectedLieu,
                  decoration: InputDecoration(
                    labelText: 'Select a location',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 70, 69, 69),
                    ),
                  ),
                  onChanged: (newValue) async {
                    if (newValue == "Around me") {
                      final PermissionStatus permissionStatus = await Permission.location.status;
                      if (permissionStatus == PermissionStatus.granted) {
                        _getCurrentLocation().then((position) {
                          if (position != null) {
                            print("Latitude: ${position.latitude}, Longitude: ${position.longitude}");
                            // Logique pour rechercher des médecins près de cette position
                          }
                        }).catchError((e) {
                          print("Error getting location: $e");
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: Text("Error"),
                              content: Text("Failed to get current location. Please try again later."),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("OK"),
                                ),
                              ],
                            ),
                          );
                        });
                      } else {
                        await _requestLocationPermission();
                      }
                    } else {
                      setState(() {
                        _selectedLieu = newValue;
                      });
                    }
                  },
                  items: [
                    DropdownMenuItem<String>(
                      value: "Around me",
                      child: Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.black),
                          SizedBox(width: 7),
                          Text('Around me', style: TextStyle(color: Colors.blue)),
                        ],
                      ),
                    ),
                    ...[
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
                      'Zaghouan'
                    ].map((lieu) => DropdownMenuItem<String>(
                      value: lieu,
                      child: Text(lieu),
                    )),
                  ],
                ),
              ),
              SizedBox(height: 7.0),
              _buildDecoratedContainer(
                DropdownButtonFormField<String>(
                  value: _selectedTypeMedecin,
                  decoration: InputDecoration(
                    labelText: 'Select type of doctor',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 70, 69, 69),
                    ),
                  ),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedTypeMedecin = newValue;
                    });
                  },
                  items: [
                    DropdownMenuItem<String>(
                      value: 'private',
                      child: Text('private'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'State doctor',
                      child: Text('State doctor'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 7.0),
              ElevatedButton(
                onPressed: () {
                  if (_selectedSpecialite != null &&
                      _selectedLieu != null &&
                      _selectedTypeMedecin != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MedecinListPage(
                          speciality: _selectedSpecialite!,
                          selectedLocation: _selectedLieu!,
                          patientId: widget.userData?.userId,
                        ),
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Missing Selection"),
                          content: Text("Please choose all search criteria."),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                  minimumSize: MaterialStateProperty.all<Size>(
                      Size(double.infinity, 40)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                child: Text(
                  'Search',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
               SizedBox(height: 7.0),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllMedecinPage(
        speciality: _selectedSpecialite,
        selectedLocation: _selectedLieu,
        patientId: widget.userData?.userId,
      ),
                    ),
                  );
                },
                child: Text(
                  'All',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'What do you Need?',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    GridView.count(
                      crossAxisCount: 3,
                      childAspectRatio: 0.8,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        _buildCard(
                            'Appointment',
                            'assets/images/appointment.png',
                            context,
                            '/appointment'),
                        _buildCard('Nurse', 'assets/images/inférmiere.png',
                            context, '/nurse'),
                        _buildCard(
                            'Emergency Services',
                            'assets/images/ambulance.png',
                            context,
                            '/emergency'),
                        _buildCard('Lab Services', 'assets/images/services.png',
                            context, '/lab'),
                        _buildCard('Hospital', 'assets/images/hopital.png',
                            context, '/hospital'),
                        _buildCard('Pharmacy', 'assets/images/pharmacie.png',
                            context, '/Pharmacy'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar:
          widget.showNavigationBar ? BarreDeNavigation() : null,
    );
  }

  Widget _buildCard(
      String title, String imagePath, BuildContext context, String route) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          if (route == '/appointment') {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      apointment(patientId: widget.userData?.userId)),
            );
          } else if (route == '/nurse') {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      NurseAcceuilPage(patientId: widget.userData?.userId)),
            );
          } else if (route == '/emergency') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EmergencyAcceuilPage()),
            );
          } else if (route == '/lab') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => laboratoryAcceuilPage()),
            );
          } else if (route == '/hospital') {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      NurseAcceuilPage(patientId: widget.userData?.userId)),
            );
          } else if (route == '/Pharmacy') {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      NurseAcceuilPage(patientId: widget.userData?.userId)),
            );
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Image.asset(imagePath, width: 50.0, height: 50.0),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(title,
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<DropdownMenuItem<String>>> _getSpecialitesFromFirestore(
      BuildContext context) async {
    List<DropdownMenuItem<String>> items = [];
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('specialites_medicales')
              .get();
      if (querySnapshot.size == 0) {
        return [DropdownMenuItem<String>(value: 'No Data', child: Text('No data found'))];
      }
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data();
        String titre = data['titre'];
        String imageUrl = data['image_url'] as String;
        items.add(
          DropdownMenuItem<String>(
            value: titre,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 200),
              child: Row(
                children: [
                  CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: 20,
                    height: 20,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  SizedBox(width: 7),
                  Text(titre),
                ],
              ),
            ),
          ),
        );
      });
    } catch (e) {
      print("Error fetching specialties: $e");
    }
    return items;
  }
}
