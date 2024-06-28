import 'package:flutter/material.dart';
import 'EmergencyPage.dart'; // Importez la classe Emg_connecterPage.dart

class EmergencyAcceuilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Emergency.jpg'), // Remplacez 'votre_image.jpg' par le chemin de votre image
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                                   Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Find your emergency doctor',
                          style: TextStyle(fontSize: 16.0, color: Colors.black),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Petit schéma pour naviguer vers une autre page
          Positioned(
            bottom: 10.0,
            right: 10.0,
            child: GestureDetector(
              onTap: () {
                // Naviguer vers Emg_connecterPage.dart lors du clic
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EmrgencyPage()),
                );
              },
              child: Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
