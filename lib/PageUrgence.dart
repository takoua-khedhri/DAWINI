import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PageUrgence extends StatefulWidget {
  @override
  _PageUrgenceState createState() => _PageUrgenceState();
}

class _PageUrgenceState extends State<PageUrgence> {
late GoogleMapController mapController;
 late  Position currentPosition;
  List<Marker> markers = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _searchEmergencyServices();
  }

  void _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      currentPosition = position;
    });
  }

  void _searchEmergencyServices() {
    // Utilisez une API de géocodage pour rechercher les services d'urgence à proximité de la localisation de l'utilisateur
    // Ajoutez des marqueurs pour chaque service d'urgence trouvé sur la carte
    // Exemple : 
    // markers.add(Marker(
    //   markerId: MarkerId('1'),
    //   position: LatLng(latitude, longitude),
    //   infoWindow: InfoWindow(title: 'Nom du service d\'urgence', snippet: 'Adresse'),
    // ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Services d\'urgence'),
      ),
      body: Stack(
        children: [
          currentPosition != null
              ? GoogleMap(
                  onMapCreated: (controller) {
                    mapController = controller;
                  },
                  initialCameraPosition: CameraPosition(
                    target: LatLng(currentPosition.latitude, currentPosition.longitude),
                    zoom: 12,
                  ),
                  markers: markers.toSet(),
                )
              : Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
