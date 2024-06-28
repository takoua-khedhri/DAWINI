import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'HistoriquePaymPage.dart';
import 'dart:io';
import 'connexionPage.dart';
import 'informationPatient.dart';
import 'reclamationPage.dart';
import 'HistoryAppoPage.dart';
import 'DossierDetails.dart';


class PatientProfilePage extends StatefulWidget {
  @override
  _PatientProfilePageState createState() => _PatientProfilePageState();
}

class _PatientProfilePageState extends State<PatientProfilePage> {
  late User? _user;
  late String _userName = '';
  late String _userEmail = '';
  late Widget _userImage;

  @override
  void initState() {
    super.initState();
    _getUserData();
    _userImage = CircleAvatar(
      radius: 50.0,
      backgroundImage: AssetImage('assets/user_photo.png'),
    );
  }

  Future<void> _getUserData() async {
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      setState(() {
        _userEmail = _user!.email!;
      });

      FirebaseFirestore.instance
          .collection('patient')
          .where('email', isEqualTo: _userEmail)
          .get()
          .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.size > 0) {
          final patientData =
              querySnapshot.docs.first.data() as Map<String, dynamic>;
          setState(() {
            _userName = '${patientData['prenom']} ${patientData['nom']}';
          });
        } else {
          print('No patient found with the email: $_userEmail');
        }
      }).catchError((error) {
        print('Error fetching user data: $error');
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _userImage = CircleAvatar(
          radius: 50.0,
          backgroundImage: FileImage(File(image.path)),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
  padding: const EdgeInsets.only(right: 20.0),
  child: Text(
    'Hello $_userName',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16, // Vous pouvez ajuster la taille du texte en fonction de vos besoins
    ),
  ),
),

        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  _userImage,
                  SizedBox(height: 10.0),
                  Text(_userName,
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold)),
                  Text(_userEmail,
                      style: TextStyle(fontSize: 16.0, color: Colors.grey)),
                  SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text('Choose Photo'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton.icon(
              icon: Icon(Icons.folder_open,
                  size: 24.0,
                  color: Colors
                      .white), // Assurez-vous que la couleur de l'icône est également blanche
              label: Text(
                'View Medical Records',
                style: TextStyle(
                    color: Colors
                        .white), // Définir explicitement la couleur du texte en blanc
              ),
              onPressed: () {
                final userId = _user!.uid;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DossierDetails(patientId: userId),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Color.fromARGB(255, 76, 175, 80), // Background color
                foregroundColor: Colors
                    .white, // Sets the foreground color to white, which includes the icon if not explicitly set
              ),
            ),

            SizedBox(height: 30.0),
            // Second section
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Personal Information'),
                    onTap: () {
                      final userId = _user!.uid;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InformationPatientPage(),
                        ),
                      );
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.lock),
                    title: Text('Payment information'),
                    onTap: () {
                      final userId = _user!.uid;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentDetailsPage(),
                        ),
                      );
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.notifications),
                    title: Text('Notifications'),
                    trailing: Switch(
                      value:
                          true, // Set the value according to the state of notifications
                      onChanged: (bool value) {
                        // Action to toggle notifications on/off
                      },
                    ),
                    onTap: () {
                      // Action to display notifications
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.history),
                    title: Text('Appointment History'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HistoryAppoPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            // Third section "Privacy & Security"
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: Icon(Icons.security),
                    title: Text('Privacy & Security'),
                    onTap: () {
                      // Action to display privacy & security settings
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.lock),
                    title: Text('Change Password'),
                    onTap: () {
                      // Action to change the password
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.privacy_tip),
                    title: Text('Privacy Settings'),
                    onTap: () {
                      // Action to display privacy settings
                    },
                  ),
                  Divider(),
                  ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('Logout'),
                      onTap: () {
                        // Action to logout
                        FirebaseAuth.instance.signOut();
                        // Navigation vers la page de connexion
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserTypeSelectionPage()),
                        );
                      }),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.feedback),
                    title: Text('Feedback'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReclamationsPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
