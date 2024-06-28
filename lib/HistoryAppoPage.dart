import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // Importer le package intl pour formater la date

class HistoryAppoPage extends StatefulWidget {
  @override
  _HistoryAppoPageState createState() => _HistoryAppoPageState();
}

class _HistoryAppoPageState extends State<HistoryAppoPage> {
  late User? _user;
  late String _userId = '';

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      setState(() {
        _userId = _user!.uid;
      });
    }
  }

  Future<Map<String, dynamic>> _fetchDoctorData(String doctorId) async {
    var doctorQuery = await FirebaseFirestore.instance
        .collection('prestataire_service')
        .doc('Medecin')
        .collection('Medecin')
        .where('userId', isEqualTo: doctorId)
        .get();

    if (doctorQuery.docs.isNotEmpty) {
      var doctorDoc = doctorQuery.docs.first.data();
      // Récupérer le nom, prénom et spécialité du médecin
      return {
        'nom': doctorDoc['nom'],
        'prenom': doctorDoc['prenom'],
        'specialite': doctorDoc['specialite'],
      };
    } else {
      return {'nom': 'Unknown', 'prenom': 'Unknown', 'specialite': 'Unknown'};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment history'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('rendez_vous')
            .where('id_patient', isEqualTo: _userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Aucun rendez-vous trouvé'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              String jour = snapshot.data!.docs[index]['jour'];
              String heure = snapshot.data!.docs[index]['heure'];
              String doctorId = snapshot.data!.docs[index]['id_medecin'];
              Timestamp dateCreation = snapshot.data!.docs[index]['date_creation'];

              // Convertir la chaîne de la date 'jour' en objet DateTime
              DateTime jourDateTime = DateTime.parse(jour);
              // Formater la date avec le format désiré
              String formattedJour = DateFormat('yyyy-MM-dd').format(jourDateTime);

              DateTime dateCreationDateTime = dateCreation.toDate();
              String formattedDate = DateFormat('dd-MM-yyyy').format(dateCreationDateTime);

              return FutureBuilder<Map<String, dynamic>>(
                future: _fetchDoctorData(doctorId),
                builder: (context, doctorSnapshot) {
                  if (doctorSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (doctorSnapshot.hasError) {
                    return Center(child: Text('Erreur: ${doctorSnapshot.error}'));
                  }
                  var doctorData = doctorSnapshot.data!;
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.all(8),
                    child: ListTile(
                      title: Text('Day: $formattedJour'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Time: $heure'),
                          Text('Doctor: ${doctorData['prenom']} ${doctorData['nom']}'),
                          Text('Specialty: ${doctorData['specialite']}'),
                          Text('Date Created: $formattedDate'), // Ajouter la date de création
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
