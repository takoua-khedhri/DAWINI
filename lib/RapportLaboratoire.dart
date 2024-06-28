import 'package:dawini/AddRapportlaboratoire.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class RapportMedicale extends StatefulWidget {
  final String userId;

  RapportMedicale({required this.userId});

  @override
  _RapportMedicale createState() => _RapportMedicale();
}

class _RapportMedicale extends State<RapportMedicale> {
  User? _user;
  late String _userId = '';

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      setState(() {
        _userId = _user!.uid;
      });
    } else {
      print("No user is currently signed in.");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Lab Reports"),
          backgroundColor: Colors.teal,
        ),
        body: Center(
          child: Text("Please sign in to view this page."),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Lab Reports"),
        backgroundColor: Colors.teal,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Dossier_medicale')
            .doc(widget.userId)
            .collection('laboratoire')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data?.docs.isEmpty ?? true) {
            return Center(child: Text("No data available"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index].data() as Map<String, dynamic>;
              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  title: Text(
                    doc['typeTest'] ?? "No test type",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Doctor: ${doc['doctorName'] ?? 'Unknown'}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Date: ${_formatDate(doc['dateSample'])}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Result: ${doc['resultTest'] ?? 'No result'}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if ((doc['notes'] ?? '').isNotEmpty)
                        Text(
                          "Notes: ${doc['notes']}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      if (doc['imageUrl'] != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return Scaffold(
                                  appBar: AppBar(),
                                  body: Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Image.network(
                                        doc['imageUrl'],
                                        fit: BoxFit.contain,
                                        width: MediaQuery.of(context).size.width,
                                        height: MediaQuery.of(context).size.height,
                                      ),
                                    ),
                                  ),
                                );
                              }));
                            },
                            child: Image.network(doc['imageUrl'], width: 150, height: 150, fit: BoxFit.cover),
                          ),
                        ),
                      Text(
                        "Modified: ${_formatDate(doc['modificationDate'])}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(dynamic date) {
    if (date is Timestamp) {
      DateTime dateTime = date.toDate();
      return DateFormat('yyyy-MM-dd').format(dateTime);
    } else if (date is String) {
      return date;
    } else {
      return 'Unknown';
    }
  }
}
