import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ClaimsPage extends StatelessWidget {
  Future<List<DocumentSnapshot>> getClaims() async {
    var collection = FirebaseFirestore.instance.collection('reclamations');
    var snapshot = await collection.get();
    return snapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Feedback"),
        centerTitle: true,
        backgroundColor: Colors.teal, // Changement de couleur de l'appBar
      ),
      body: FutureBuilder(
        future: getClaims(),
        builder: (BuildContext context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Erreur: ${snapshot.error.toString()}"));
          }

          return ListView.separated(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (context, index) {
              var claim = snapshot.data![index].data() as Map<String, dynamic>;
var feedback = claim['feedback'] as String? ?? "Aucun commentaire";
              var timestamp = claim['timestamp'] as Timestamp?;
var formattedDate = timestamp != null ? DateFormat('dd MMM yyyy à HH:mm').format(timestamp.toDate()) : "Date inconnue";

              return ListTile(
                title: Text(feedback, style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(formattedDate, style: TextStyle(color: Colors.grey[600])),
                leading: CircleAvatar(
                  backgroundColor: Colors.teal,
                  child: Icon(Icons.comment, color: Colors.white),
                ),
                tileColor: index % 2 == 0 ? Colors.teal[50] : Colors.white, // Alternance des couleurs de fond
              );
            },
            separatorBuilder: (context, index) => Divider(), // Ajouter des diviseurs pour séparer les éléments
          );
        },
      ),
    );
  }
}