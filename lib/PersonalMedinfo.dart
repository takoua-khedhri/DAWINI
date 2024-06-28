import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PersonalMedinfo extends StatefulWidget {
  @override
  _PersonalMedinfo createState() => _PersonalMedinfo();
}

class _PersonalMedinfo extends State<PersonalMedinfo> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Information Medecin'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Medecin')
            .where('userId', isEqualTo: _userId)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data found'));
          }
         return ListView(
            children: snapshot.data!.docs.map((document) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text('Nom: ${document['nom']}'),
                  ),
                  ListTile(
                    title: Text('Prénom: ${document['prenom']}'),
                  ),
                  ListTile(
                    title: Text('Adresse: ${document['Adresse']}'),
                  ),
                  ListTile(
                    title: Text('Date de Naissance: ${document['date_naissance']}'),
                  ),
                  ListTile(
                    title: Text('Email: ${document['email']}'),
                  ),
                  ListTile(
                    title: Text('Numéro: ${document['numero']}'),
                  ),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}