import 'package:flutter/material.dart';
import 'DossierMedecin.dart';

class PatientRecordsPage extends StatefulWidget {
  final String patientId;

  PatientRecordsPage({required this.patientId});

  @override
  _PatientRecordsPageState createState() => _PatientRecordsPageState();
}

class _PatientRecordsPageState extends State<PatientRecordsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DossierMedecin(patientId: widget.patientId),
    );
  }
}
