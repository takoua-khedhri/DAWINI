import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NurseListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des infirmières'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('infermiere').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              Map<String, dynamic> data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
              return Card(
                child: ListTile(
                  title: Text('${data['Nom']} ${data['Prenom']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Adresse: ${data['Adresse']}'),
                      // Ajoutez ici d'autres informations comme l'email, la localisation, etc.
                    ],
                  ),
                  onTap: () {
                    // Vous pouvez ajouter ici une action à effectuer lorsqu'une infirmière est sélectionnée
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
