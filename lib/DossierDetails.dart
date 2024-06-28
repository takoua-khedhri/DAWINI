import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'informationPatientMedicale.dart';
import 'ScannerMedicale.dart';
import 'Consultations.dart';
import 'RapportLaboratoire.dart';

class DossierDetails extends StatefulWidget {
  final String patientId;

  DossierDetails({required this.patientId});
  @override
  _DossierDetailsState createState() => _DossierDetailsState();
}

class _DossierDetailsState extends State<DossierDetails> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getUserData(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final user = snapshot.data;
          return DefaultTabController(
            length: 4,
            child: Scaffold(
              appBar: AppBar(
                title: user != null
                    ? StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('patient')
                            .where('userId', isEqualTo: user.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData &&
                              snapshot.data!.docs.isNotEmpty) {
                            var userDoc = snapshot.data!.docs.first.data()
                                as Map<String, dynamic>;
                            return Text(
                              'Medical Records of ${userDoc['nom']} ${userDoc['prenom']}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(
                                    0xFFFF5733), // Une couleur vive personnalisée (orange vif)
                              ),
                            );
                          }
                          return Text("User not found");
                        },
                      )
                    : Text(
                        "Loading..."), // Display "Loading..." while waiting for data
                bottom: TabBar(
                  tabs: [
                    Tab(
                        icon: Icon(Icons.person),
                        text: "Personal informations"),
                    Tab(icon: Icon(Icons.image), text: "Imaging"),
                    Tab(icon: Icon(Icons.science), text: "Lab Reports"),
                    Tab(icon: Icon(Icons.assignment), text: "Consultations"),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
            PersonalInformations(patientId: widget.patientId),
                  ImagingSection(user: user),
                  LabReportsSection(patientId: widget.patientId),
                  ConsultationsSection(patientId: widget.patientId),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Future<User?> _getUserData() async {
    return FirebaseAuth.instance.currentUser;
  }
}

class PersonalInformations extends StatelessWidget {
  final String patientId;
  PersonalInformations({Key? key, required this.patientId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: Icon(Icons.person),
          title: Text('Personnal Informations'),
         onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InfoPatientMedicale(patientId: patientId),
              ),
            );
          },
        ),
        // Add more imaging types here
      ],
    );
  }
}

class ImagingSection extends StatelessWidget {
  final User? user;
  ImagingSection({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: Icon(Icons.scanner),
          title: Text('Scanner'),
          onTap: () {
            if (user != null) {
              final userId = user!.uid;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ScannerMedicale(userId: userId),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}

class LabReportsSection extends StatelessWidget {
  final String patientId;
  LabReportsSection({Key? key, required this.patientId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: Icon(Icons.scanner),
          title: Text('lab_report'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RapportMedicale( userId: this.patientId),
              ),
            );
          },
        ),
      ],
    );
  }
}

class ConsultationsSection extends StatelessWidget {
   final String patientId;
  ConsultationsSection({Key? key, required this.patientId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: Icon(Icons.note_add),
          title: Text('Consultation'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ConsultationsPage(
                    userId: this.patientId), // Utilisez userId ici
              ),
            );
          },
        ),
        // Add more consultation details here
      ],
    );
  }
}
