import 'package:dawini/pageAcceuilMed.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'PersonalMedinfo.dart';
import 'reclamationPage.dart';

class PageProfileMed extends StatefulWidget {
  @override
  _PageProfileMedState createState() => _PageProfileMedState();
}

class _PageProfileMedState extends State<PageProfileMed> {
  late User? _user;
  late String _userName = '';
  late String _userEmail = '';
 late Widget _userImage = CircleAvatar(
    radius: 50.0,
    backgroundImage: AssetImage('assets/user_photo.png'),
  );

  @override
  void initState() {
    super.initState();
    _getUserData();
    // Initialize the default image
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // First section
            Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10.0),
                
              ),
              child: Column(
                children: [
                  // Displaying the user's image
                  _userImage,
                  SizedBox(height: 10.0),
                  // Displaying the user's name retrieved from Firestore
                  Text(
                    _userName,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Displaying the user's email retrieved from Firestore
                  Text(
                    _userEmail,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed:
                        _pickImage, // Action to choose a photo from the gallery
                    child: Text('Choose Photo'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
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
                          builder: (context) => PersonalMedinfo(),
                        ),
                      );
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.lock),
                    title: Text('Payment information'),
                    onTap: () {
                      // Action to display payment information
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
                      // Navigate to the login page for example
                    },
                  ),
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
