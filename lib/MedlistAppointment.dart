import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'DossierMedicalPage.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import 'PatientRecordsPage.dart';

class MedlistAppointment extends StatefulWidget {
  @override
  _MedlistAppointmentState createState() => _MedlistAppointmentState();
}

class _MedlistAppointmentState extends State<MedlistAppointment> {
  late User? _user;
  late String _userId = '';
  Map<String, bool> _appointmentConfirmedMap = {};

  @override
  void initState() {
    super.initState();
    _getUserData();
    _loadAppointmentConfirmation();
  }

  Future<void> _getUserData() async {
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      setState(() {
        _userId = _user!.uid;
      });
    }
  }

  void _confirmAppointment(String rendezVousId, String patientId) async {
    FirebaseFirestore.instance
        .collection('rendez_vous')
        .doc(rendezVousId)
        .update({'confirmed': true}).then((_) {
      print('Appointment confirmed');
      setState(() {
        _appointmentConfirmedMap[rendezVousId] = true;
      });
      _saveAppointmentConfirmation(rendezVousId, true);
    }).catchError((error) {
      print('Error confirming appointment: $error');
    });
  }

  void _cancelAppointment(String rendezVousId) async {
    FirebaseFirestore.instance
        .collection('rendez_vous')
        .doc(rendezVousId)
        .update({'confirmed': false}).then((_) {
      print('Appointment canceled');
      setState(() {
        _appointmentConfirmedMap[rendezVousId] = false;
      });
      _saveAppointmentConfirmation(rendezVousId, false);
    }).catchError((error) {
      print('Error canceling appointment: $error');
    });
  }

  void _saveAppointmentConfirmation(String rendezVousId, bool isConfirmed) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(rendezVousId, isConfirmed);
  }

  Future<void> _loadAppointmentConfirmation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _appointmentConfirmedMap = Map.fromIterable(
        prefs.getKeys(),
        key: (key) => key as String,
        value: (key) => prefs.getBool(key) ?? false,
      );
    });
  }

  Future<String> _fetchPatientName(String patientId) async {
    var patientQuery = await FirebaseFirestore.instance.collection('patient').where('userId', isEqualTo: patientId).get();
    var patientDoc = patientQuery.docs.first.data();
    var nom = patientDoc['nom'];
    var prenom = patientDoc['prenom'];
    return '$prenom $nom';
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
            .where('id_medecin', isEqualTo: _userId)
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
              String rendezVousId = snapshot.data!.docs[index].id;
              String jour = snapshot.data!.docs[index]['jour'];
              String heure = snapshot.data!.docs[index]['heure'];
              String patientId = snapshot.data!.docs[index]['id_patient'];
              Timestamp dateCreation = snapshot.data!.docs[index]['date_creation'];

              // Convertir la chaîne de la date 'jour' en objet DateTime
              DateTime jourDateTime = DateTime.parse(jour);
              // Formater la date avec le format désiré
              String formattedJour = DateFormat('yyyy-MM-dd').format(jourDateTime);

              DateTime dateCreationDateTime = dateCreation.toDate();
              String formattedDate = DateFormat('dd-MM-yyyy').format(dateCreationDateTime);

              bool isConfirmed = _appointmentConfirmedMap.containsKey(rendezVousId) ? _appointmentConfirmedMap[rendezVousId]! : false;

              return FutureBuilder<String>(
                future: _fetchPatientName(patientId),
                builder: (context, patientSnapshot) {
                  if (patientSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (patientSnapshot.hasError) {
                    return Center(child: Text('Erreur: ${patientSnapshot.error}'));
                  }
                  String patientName = patientSnapshot.data!;
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.all(8),
                    color: isConfirmed ? Colors.green : Colors.grey[300],
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(' Day: $formattedJour'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Time: $heure'),
                              Text('Patient: $patientName'),
                              Text('Date Created: $formattedDate'),
                            ],
                          ),
                          onTap: isConfirmed
                              ? () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PatientRecordsPage(patientId: patientId),
                                    ),
                                  );
                                }
                              : null,
                        ),
                      ButtonBar(
  children: [
    ElevatedButton(
      onPressed: _appointmentConfirmedMap[rendezVousId] == null ? () {
        _confirmAppointment(rendezVousId, patientId);
        setState(() {
          _appointmentConfirmedMap[rendezVousId] = true;
        });
      } : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: _appointmentConfirmedMap[rendezVousId] != null ? Colors.grey : Colors.blue,
      ),
      child: Text('Confirm'),
    ),
    TextButton(
      onPressed: _appointmentConfirmedMap[rendezVousId] == null ? () {
        _cancelAppointment(rendezVousId);
        setState(() {
          _appointmentConfirmedMap[rendezVousId] = false;
        });
      } : null,
      style: TextButton.styleFrom(
        backgroundColor: _appointmentConfirmedMap[rendezVousId] != null ? Colors.grey : Colors.blue,
      ),
      child: Text('Cancel'),
    ),
  ],
),

                      ],
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
