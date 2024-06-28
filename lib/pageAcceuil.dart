import 'package:flutter/material.dart';
import 'connexionPage.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Image de fond
        Container(
  width: MediaQuery.of(context).size.width,
  height: MediaQuery.of(context).size.height,
  decoration: BoxDecoration(
    image: DecorationImage(
      image: AssetImage('assets/images/Dawini.png'),
       fit: BoxFit.contain, // Ajoutez cet élément
    ),
  ),
),
          // Alignement de la colonne au centre de la page
          Align(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: SizedBox(),
                ),
                // Texte "Your Health , Our Priority" en gras
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    'Your Health, Our Priority !',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold, // Mettre en gras
                      color: Color.fromARGB(255, 37, 0, 200),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Bouton "Get Started"
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserTypeSelectionPage(),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                    minimumSize: MaterialStateProperty.all<Size>(Size(260, 50)),
                  ),
                  child: Text(
                    'Get Started',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                 SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
