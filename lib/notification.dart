import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pagePaiement.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  User? _user;
  String _userId = '';

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

  Future<Map<String, dynamic>> _fetchDoctorData(String doctorUserId) async {
    var doctorQuery = await FirebaseFirestore.instance
        .collection('prestataire_service')
        .doc('Medecin')
        .collection('Medecin')
        .where('userId', isEqualTo: doctorUserId)
        .limit(1)
        .get();

    if (doctorQuery.docs.isNotEmpty) {
      var data = doctorQuery.docs.first.data();
      return {
        'nom': data['nom'] ?? 'Unknown',
        'prenom': data['prenom'] ?? 'Unknown',
      };
    } else {
      return {'nom': 'Unknown', 'prenom': 'Unknown'};
    }
  }

  Future<List<Widget>> _buildAppointmentList(
      List<QueryDocumentSnapshot> appointmentDocs) async {
    List<Widget> confirmedList = [];
    List<Widget> canceledList = [];
    List<Widget> pendingList = [];

    for (var doc in appointmentDocs) {
      bool? confirmed = (doc.data() as Map?)?.containsKey('confirmed') ?? false ? doc['confirmed'] : null;

      String doctorUserId = doc['id_medecin'];
      String idPatient = doc['id_patient']; // Récupération de l'ID du patient

      var doctorData = await _fetchDoctorData(doctorUserId);
      String doctorName = '${doctorData['prenom']} ${doctorData['nom']}';
      String message;
      IconData icon;
      Color color;

      if (confirmed == true) {
        message = 'Appointment confirmed with Dr. $doctorName';
        icon = Icons.check_circle;
        color = Colors.green;
        confirmedList.add(_buildListItem(message, icon, color, doctorUserId, idPatient, true));
      } else if (confirmed == false) {
        message = 'Appointment canceled with Dr. $doctorName';
        icon = Icons.cancel;
        color = Colors.red;
        canceledList.add(_buildListItem(message, icon, color, doctorUserId, idPatient, false));
      } else {
        message = 'Appointment pending with Dr. $doctorName';
        icon = Icons.hourglass_empty;
        color = Colors.orange;
        pendingList.add(_buildListItem(message, icon, color, doctorUserId, idPatient, false));
      }
    }

    return [
      ListTile(
        title: Text('Confirmed Appointments',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      ...confirmedList,
      ListTile(
        title: Text('Canceled Appointments',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      ...canceledList,
      ListTile(
        title: Text('Pending Appointments',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      ...pendingList,
    ];
  }

  Widget _buildListItem(
      String message, IconData icon, Color color, String idMedecin, String idPatient, bool confirmed) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(message),
        subtitle: Text('Tap for more details'),
        onTap: confirmed
            ? () {
                _redirectToPayment(idMedecin, idPatient);
              }
            : null,
      ),
    );
  }

  void _redirectToPayment(String idMedecin, String idPatient) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => PaymentOptionsPage(
        idMedecin: idMedecin,
        idPatient: idPatient,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Colors.teal,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('rendez_vous')
            .where('id_patient', isEqualTo: _userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No notifications found'));
          }

          return FutureBuilder<List<Widget>>(
            future: _buildAppointmentList(snapshot.data!.docs),
            builder: (context, listSnapshot) {
              if (listSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (listSnapshot.hasError) {
                return Center(child: Text('Error: ${listSnapshot.error}'));
              }
              return ListView(
                children: listSnapshot.data!,
              );
            },
          );
        },
      ),
    );
  }
}
