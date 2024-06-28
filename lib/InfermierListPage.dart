import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Med.dart'; // Assurez-vous de remplacer "chemin_vers_votre_fichier" par le chemin réel
import 'profileMed.dart';

class InfermierListPage extends StatefulWidget {
  final String selectedWorkAtHome;
  final String selectedSpecialite; // Correction ici
  final String selectedDestination; // Correction ici
  final String? patientId;

  InfermierListPage({
    required this.selectedSpecialite,
    required this.selectedDestination,
    required this.selectedWorkAtHome, // Correction ici
    this.patientId,
  });
  @override
  _InfListPageState createState() => _InfListPageState();
}

class _InfListPageState extends State<InfermierListPage> {
  late Stream<List<Medecin>> _medecinsStream;

  @override
  void initState() {
    super.initState();
    _medecinsStream = fetchMedecins();
  }

  Stream<List<Medecin>> fetchMedecins() {
    return FirebaseFirestore.instance
        .collection('prestataire_service')
        .doc('Infermiere')
        .collection('Infermiere')
        .where('specialite', isEqualTo: widget.selectedSpecialite)
        .where('lieu', isEqualTo: widget.selectedDestination)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Medecin(
          nom: data['nom'],
          prenom: data['prenom'],
          specialite: data['specialite'],
          adresse: data['Adresse'],
          medecinId: doc.id, // Ajout de l'ID du médecin
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Doctors in ${widget.selectedDestination}',
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder<List<Medecin>>(
        stream: _medecinsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(child: Text('No doctors available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                final medecin = snapshot.data![index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileMed(
                          medecinId: medecin.medecinId,
                          patientId: widget.patientId,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5.0),
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.blue),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${medecin.nom} ${medecin.prenom}',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          'Specialty: ${medecin.specialite}',
                          style: TextStyle(fontSize: 14.0),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          'Address: ${medecin.adresse}',
                          style: TextStyle(fontSize: 14.0),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
