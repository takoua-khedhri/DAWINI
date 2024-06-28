import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListNursesPage extends StatefulWidget {
  final String location;
  final String specialty;
  final String workType;

  ListNursesPage({required this.location, required this.specialty, required this.workType});

  @override
  _ListNursesPageState createState() => _ListNursesPageState();
}

class _ListNursesPageState extends State<ListNursesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of Nurses'),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('prestataire_service')
            .doc('Infermiere')
            .collection('Infermiere')
            .where('lieu', isEqualTo: widget.location)
            .where('specialite', isEqualTo: widget.specialty)
            .get(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No nurses found with the specified criteria.'),
            );
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              return ListTile(
                title: Text('${data['nom']} ${data['prenom']}'),
                subtitle: Text('Specialty: ${data['specialite']}'),
                // You can add more information to display here
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
