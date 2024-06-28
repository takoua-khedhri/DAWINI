import 'package:flutter/material.dart';
import 'profilePatient.dart'; // Importez votre écran ProfilePatient ici
import 'notification.dart'; // Importez la page de notification ici

class BarreDeNavigation extends StatefulWidget {

  BarreDeNavigation(); // Modifiez le constructeur

  @override
  _BarreDeNavigationState createState() => _BarreDeNavigationState();
}

class _BarreDeNavigationState extends State<BarreDeNavigation> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Gérez la navigation en fonction de l'index sélectionné
    switch (index) {
      case 0:
        // Afficher la page d'accueil lorsque "Home" est sélectionné
        // Implémentez votre logique pour la page d'accueil ici
        break;
      case 1:
        // Afficher la page de notifications lorsque "Notifications" est sélectionné
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NotificationPage()),
        );
        break;

      case 2:
        // Afficher ProfilePatient lorsque "Profile" est sélectionné
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PatientProfilePage()),
        );
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Notifications',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.blue,
      onTap: _onItemTapped,
    );
  }
}
