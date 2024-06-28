import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'informationPatientMedicale.dart';
import 'ScannerMedicale.dart';
import 'RapportLaboratoire.dart';
import 'AddPersonalInformationPage.dart';
import 'AddImagePage.dart';
import 'AddRapportlaboratoire.dart';
import 'AddConsultation.dart';
import 'Consultations.dart';

class DossierMedecin extends StatefulWidget {
  final String patientId;

  DossierMedecin({required this.patientId});

  @override
  _DossierMedecinState createState() => _DossierMedecinState();
}

class _DossierMedecinState extends State<DossierMedecin> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('patient')
                .where('userId', isEqualTo: widget.patientId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                var userDoc =
                    snapshot.data!.docs.first.data() as Map<String, dynamic>;
                return Text('Medical Records of ${userDoc['nom']}');
              }
              return Text("User not found");
            },
          ),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.person), text: "Personal informations"),
              Tab(icon: Icon(Icons.image), text: "Imaging"),
              Tab(icon: Icon(Icons.science), text: "Lab Reports"),
              Tab(icon: Icon(Icons.assignment), text: "Consultations"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PersonalInformations(patientId: widget.patientId),
            ImagingSection(patientId: widget.patientId),
            LabReportsSection(patientId: widget.patientId),
            ConsultationsSection(patientId: widget.patientId),
          ],
        ),
      ),
    );
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
          title: Text('Personal Informations'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InfoPatientMedicale(patientId: patientId),
              ),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.add),
          title: Text('Add Personal Information'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddPersonalInformationPage(patientId: patientId),
              ),
            );
          },
        ),
      ],
    );
  }
}

class ImagingSection extends StatelessWidget {
  final String patientId;
  ImagingSection({Key? key, required this.patientId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: Icon(Icons.scanner),
          title: Text('Scanner'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ScannerMedicale(userId: patientId),
              ),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.add),
          title: Text('Add an image'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddImageAndFilePage(patientId: patientId),
              ),
            );
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
          title: Text('Laboratory Report'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RapportMedicale(userId: patientId),
              ),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.add),
          title: Text('Add Lab Report'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddRapportlab(patientId: patientId),
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
                builder: (context) => ConsultationsPage(userId: patientId),
              ),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.add),
          title: Text('Add Consultation Details'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddConsultation(patientId: patientId),
              ),
            );
          },
        ),
      ],
    );
  }
}
