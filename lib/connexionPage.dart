import 'package:flutter/material.dart';
import 'authentificationPage.dart';
import 'Professionellelist.dart';
import 'AdminConnecterPage.dart';
import 'connecterPage.dart';
import 'VisiteurSearchScreen.dart';

class UserTypeSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/stetoo.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 100),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Find your identity :',
                      textAlign: TextAlign
                          .left, // Ajout de cette ligne pour placer le texte à gauche
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 37, 0, 200),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
                SizedBox(height: 100), // Espacement supplémentaire du haut
                Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConnecterPage(),
                          ),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                        minimumSize:
                            MaterialStateProperty.all<Size>(Size(260, 50)),
                      ),
                      icon: Icon(
                        Icons.person,
                        color: Colors.white, // Couleur de l'icône
                      ),
                      label: Text(
                        'Patient',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfessionalList(),
                          ),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                        minimumSize:
                            MaterialStateProperty.all<Size>(Size(260, 50)),
                      ),
                      icon: Icon(
                        Icons.medical_services,
                        color: Colors.white, // Couleur de l'icône
                      ),
                      label: Text(
                        'Healthcare professional',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminConnecterPage(),
                          ),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                        minimumSize:
                            MaterialStateProperty.all<Size>(Size(260, 50)),
                      ),
                      icon: Icon(
                        Icons.admin_panel_settings,
                        color: Colors.white, // Couleur de l'icône
                      ),
                      label: Text(
                        'Administrator',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(height: 28),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VisiteurSearchScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Just Try',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors
                              .blue, // Changement de couleur du texte en bleu
                          fontSize: 20, // Augmentation de la taille du texte
                          fontWeight: FontWeight
                              .bold, // Utilisation d'une police en gras
                          decoration:
                              TextDecoration.underline, // Soulignage du texte
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
