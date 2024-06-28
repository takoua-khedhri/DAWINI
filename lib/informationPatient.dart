import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InformationPatientPage extends StatefulWidget {
  @override
  _InformationPatientPageState createState() => _InformationPatientPageState();
}

class _InformationPatientPageState extends State<InformationPatientPage> {
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
        title: Text('Patient Information'),
        backgroundColor: Colors.teal, // Color for app bar
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('patient')
            .where('userId', isEqualTo: _userId)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data found'));
          }
          return ListView(
            children: snapshot.data!.docs.map((document) {
              return Card(
                margin: EdgeInsets.all(10),
                elevation: 5,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
  InformationTile(icon: Icons.account_circle, title: 'Name', data: document['nom']),
  InformationTile(icon: Icons.account_circle, title: 'First Name', data: document['prenom']),
  InformationTile(icon: Icons.home, title: 'Address', data: document['Adresse']),
  InformationTile(icon: Icons.cake, title: 'Date of Birth', data: document['date_naissance']),
  InformationTile(icon: Icons.email, title: 'Email', data: document['email']),
  InformationTile(icon: Icons.phone, title: 'Phone Number', data: document['numero']),
],

                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class InformationTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String data;

  InformationTile({required this.icon, required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text('$title: $data'),
    );
  }
}
