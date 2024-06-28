import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DossierMedicalPage extends StatelessWidget {
  final String patientId;

  const DossierMedicalPage({Key? key, required this.patientId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dossier médical du patient'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Dossier_medicale')
            .doc('info_personnelle')
            .collection('info_personnelle')
            .where('userId', isEqualTo: patientId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }
          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Aucun dossier médical trouvé'));
          }
          // Récupérer les données du premier document (devrait être unique)
          final document = snapshot.data!.docs.first;
          // Extraire les données du dossier médical
          final data = document.data() as Map<String, dynamic>;
          // Afficher les détails du dossier médical
          return ListView(
            padding: EdgeInsets.all(16.0),
            children: [
              ListTile(
                title: Text('Nom: ${data['nom']}'),
              ),
              ListTile(
                title: Text('Prénom: ${data['prenom']}'),
              ),
              ListTile(
                title: Text('Date de naissance: ${data['date_naissance']}'),
              ),
              ListTile(
                title: Text('Adresse: ${data['Adresse']}'),
              ),
              ListTile(
                title: Text('Email: ${data['email']}'),
              ),
              ListTile(
                title: Text('Numéro: ${data['numero']}'),
              ),
            ],
          );
        },
      ),
    );
  }
}
