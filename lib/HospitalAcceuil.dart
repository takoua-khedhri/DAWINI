import 'package:flutter/material.dart';
import 'PageInfermier.dart';

class NurseAcceuilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/nursing.jpg'), // Remplacez 'votre_image.jpg' par le chemin de votre image
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Espace entre la phrase et le schéma de navigation
              SizedBox(height: 20.0),
              // Petit schéma pour naviguer vers une autre page
              GestureDetector(
                onTap: () {
                  // Naviguer vers Emg_connecterPage.dart lors du clic
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NurseSearchPage()),
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
              SizedBox(
                  height:
                      20.0), // Espacement entre le schéma de navigation et le container blanc
              Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Let"s find a nurse',
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                    ),
                    // Ajoutez votre phrase ici
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
