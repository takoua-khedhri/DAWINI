import 'package:flutter/material.dart';
import 'Doctor_Search_Screen.dart';
import 'MedLoginPage.dart';
import 'MedAuthPage.dart';
import 'Inf_loginPage.dart';
import 'Inf_AuthPage.dart';

class Inf_connecterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Image de fond
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/stetoo.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Bouton de retour
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          // Contenu central
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Bouton "Sign in" avec icône
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Inf_LoginPage(),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                      minimumSize:
                          MaterialStateProperty.all<Size>(Size(260, 50)),
                    ),
                    icon: Icon(Icons.login),
                    label: Text(
                      'Sign in',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  // Bouton "Sign up" avec icône
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Inf_AuthPage(),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                      minimumSize:
                          MaterialStateProperty.all<Size>(Size(260, 50)),
                    ),
                    icon: Icon(Icons.person_add),
                    label: Text(
                      'Sign up',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),

                  SizedBox(height: 24),
                  // Texte "Just Try" avec GestureDetector pour la navigation
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DoctorSearchScreen(
                            userData: null,
                            showNavigationBar: false,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Just Try',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors
                            .blue, // Changement de couleur du texte en bleu
                        fontSize: 18, // Augmentation de la taille du texte
                        fontWeight:
                            FontWeight.bold, // Utilisation d'une police en gras
                        decoration:
                            TextDecoration.underline, // Soulignage du texte
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
