import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PatientsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List of Patients"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('patient').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Erreur: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final data = snapshot.requireData;

          return ListView.builder(
            itemCount: data.size,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Card(
                  elevation: 4,
                  child: ListTile(
                    leading: Icon(Icons.person),
                    title: Text(
                        "${data.docs[index]['prenom']} ${data.docs[index]['nom']}"),
                    subtitle: Text("Adresse: ${data.docs[index]['Adresse']}"),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        // Afficher une boîte de dialogue pour confirmer la suppression
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Text(
                                  "Are you sure you want to delete??"),
                              actions: [
                                TextButton(
                                  child: Text("cancel"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text("delete"),
                                  onPressed: () {
                                    // Supprimer le patient de la base de données
                                    FirebaseFirestore.instance
                                        .collection('patient')
                                        .doc(data.docs[index].id)
                                        .delete();
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    onTap: () {
                      // Ajouter des actions supplémentaires lorsqu'on clique sur un patient
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
