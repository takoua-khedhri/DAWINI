import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'VisiteurConnexionPage.dart';

class VisiteurProfileMed extends StatelessWidget {
  final String? medecinId;

  VisiteurProfileMed({
    this.medecinId,
  });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('prestataire_service')
            .doc('Medecin')
            .collection('Medecin')
            .doc(medecinId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Error fetching doctor data: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            print('Doctor data not found or does not exist');
            return Center(child: Text('Doctor not found'));
          } else {
            final medecinData = snapshot.data!.data() as Map<String, dynamic>?;
            if (medecinData == null) {
              print('No data returned from Firestore');
              return Text('No data available');
            }
String? adresse = medecinData['Adresse'] as String?;
            if (adresse == null || adresse.isEmpty) {
              print('Adresse field is missing');
              return Text('No address available');
            }
            return FutureBuilder<Widget>(
              future: showProfile(context, medecinData, adresse),
              builder: (context, profileSnapshot) {
                if (profileSnapshot.hasData) {
                  return profileSnapshot.data!;
                } else if (profileSnapshot.hasError) {
                  return Text('Error: ${profileSnapshot.error}');
                } else {
                  return CircularProgressIndicator();
                }
              },
            );
          }
        },
      ),
    );
  }

  Future<Widget> showProfile(BuildContext context, Map<String, dynamic> medecinData, String adresse) async {
     try {
    List<Location> locations = await locationFromAddress(adresse);
    if (locations.isNotEmpty) {
      LatLng doctorLocation = LatLng(locations.first.latitude, locations.first.longitude);
      // Utilisez les coordonnées doctorLocation comme nécessaire
    } else {
      print('Aucun emplacement trouvé pour l’adresse.');
      return Text('Emplacement non disponible');
    }
  } catch (e) {
    print('Échec de la récupération de l\'emplacement : $e');
    return Text('Problème de géolocalisation');
  }
    List<Location> locations = [];
    LatLng? doctorLocation;
    if (adresse != null && adresse.isNotEmpty) {
      locations = await locationFromAddress(adresse);
      if (locations.isNotEmpty) {
        doctorLocation = LatLng(locations.first.latitude, locations.first.longitude);
      }
    }

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      _showRatingDialog(context);
                    },
                   child: Container(
  width: 50,
  height: 50,
  child: Icon(
    Icons.star,
    color: Color.fromARGB(255, 218, 198, 27), // Définit la couleur de l'étoile en jaune
  ),
),
                  ),
                ),
              ],
            ),
            Center(
              child: Column(children: [
       Container(
  padding: EdgeInsets.all(8.0), // Internal spacing
  child: Container(
    width: 150, // Image width
    height: 150, // Image height
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(10.0),
      image: DecorationImage(
        image: NetworkImage(medecinData['photoUrl']), // Load the image from the URL
        fit: BoxFit.cover, // Cover the entire area of the container
      ),
    ),
  ),
),

                SizedBox(height: 10.0),
               RichText(
  text: TextSpan(
    style: TextStyle(fontSize: 20.0, color: Colors.black),
    children: [
      TextSpan(
        text: 'Dr. ${medecinData['prenom']} ${medecinData['nom']}\n',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      WidgetSpan(
        alignment: PlaceholderAlignment.middle, // Pour centrer le WidgetSpan
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 5.0),
            Text(
              '${medecinData['specialite']}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    ],
  ),
),

                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(8.0),
                          child: Icon(Icons.volume_up),
                        ),
                        Text(
                          'Audio',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(8.0),
                          child: Icon(Icons.videocam),
                        ),
                        Text(
                          'Video',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(8.0),
                          child: Icon(Icons.chat),
                        ),
                        Text(
                          'Chat',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Text(
                  'Infos',
                  style: TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.bold,color: Colors.blue,),
                ),
                SizedBox(height: 5.0),
             Text.rich(
  TextSpan(
    children: [
      TextSpan(
        text: 'Experience: ',
        style: TextStyle(fontSize: 14.0,fontWeight: FontWeight.bold),
      ),
      TextSpan(
        text: '${medecinData['experience']}\n',
        style: TextStyle(fontSize: 14.0),
      ),
    ],
  ),
),
SizedBox(height: 4.0),
Text.rich(
  TextSpan(
    children: [
      TextSpan(
        text: 'Address: ',
        style: TextStyle(fontSize: 14.0,fontWeight: FontWeight.bold),
      ),
      TextSpan(
        text: '${medecinData['Adresse']}\n',
        style: TextStyle(fontSize: 14.0),
      ),
    ],
  ),
),

                SizedBox(height: 10.0),
                if (doctorLocation != null) showMap(doctorLocation),
                SizedBox(height: 10.0),
                Text(
                  'Work hours',
                  style: TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.bold,color: Colors.blue),
                ),
                SizedBox(height: 5.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: (medecinData['jours_travail'] as List)
                      .map<Widget>((jour) {
                    final horaires = medecinData['horaires'][jour] as List?;
                    if (horaires != null && horaires.length == 2) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$jour: ${horaires[0]} --> ${horaires[1]}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      );
                    } else {
                      return SizedBox();
                    }
                  }).toList(),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VisiteurConnexionPage(),
                        ),
                      );
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
                    child: Text('Make Appointment',
                     style: TextStyle(
      color: Colors.white, // Texte blanc
      fontWeight: FontWeight.bold, // Texte en gras
    ),
    ),

                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget showMap(LatLng doctorLocation) {
    return Container(
      height: 200,
      child: FlutterMap(
        options: MapOptions(
          center: doctorLocation,
          zoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: doctorLocation,
                child: Icon(Icons.location_on, color: Colors.red, size: 40),
                width: 30,
                height: 30,
              ),
            ],
          ),
        ],
      ),
    );
  }

void _showRatingDialog(BuildContext context) {
  int rating = 0;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            content: Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How was your experience?',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,),
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 1; i <= 5; i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: SizedBox(
                            width: 40.0, // Largeur fixe pour chaque étoile
                            child: IconButton(
                              iconSize: 30.0,
                              icon: Icon(
                                i <= rating ? Icons.star : Icons.star_border,
                                color: i <= rating ? Color.fromARGB(255, 240, 220, 47) : null,
                              ),
                              onPressed: () {
                                setState(() {
                                  rating = i;
                                });
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  saveRatingToDatabase(rating);
                  Navigator.of(context).pop();
                },
                child: Text('Submit'),
              ),
            ],
          );
        },
      );
    },
  );
}



  void saveRatingToDatabase(int rating) {
    if (medecinId != null) {
      FirebaseFirestore.instance
          .collection('evaluations')
          .add({
            'medecinId': medecinId,
            'rating': rating,
          })
          .then((value) {
        print('Rating added successfully');
      }).catchError((error) {
        print('Error adding rating: $error');
      });
    } else {
      print('Error: medecinId is null');
    }
  }
}