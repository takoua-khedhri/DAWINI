import 'package:flutter/material.dart';
import 'authentificationPage.dart';
import 'loginPage.dart';
import 'scanning.dart';

class ConnecterPage extends StatelessWidget {
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
                          builder: (context) => LoginPage(),
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
                    Icons.login,
                  color: Colors.white, // Couleur de l'icône
  ),
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
                          builder: (context) => AuthentificationPage(),
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
                    Icons.person_add,
                     color: Colors.white, // Couleur de l'icône
                  ),
                    label: Text(
                      'Sign up',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),


                  SizedBox(height: 24),
                  // Bouton "Sign Up with CNAM QR Code" avec icône
                  ElevatedButton.icon(
                     onPressed: () {
                       Navigator.push(
                         context,
                       MaterialPageRoute(
                       builder: (context) => QRScanScreen(),
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
                    Icons.qr_code,
                  color: Colors.white, // Couleur de l'icône
  ),
                    label: Text(
                      'Sign in  with CNAM QR Code',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
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
