import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class InfoPatientMedicale extends StatefulWidget {
  final String patientId;
  const InfoPatientMedicale({Key? key, required this.patientId}) : super(key: key);

  @override
  _InfoPatientMedicaleState createState() => _InfoPatientMedicaleState();
}

class _InfoPatientMedicaleState extends State<InfoPatientMedicale> {
  User? _user;
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
        title: Text('Patient Medical Record'),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 1,
            child: Card(
              margin: EdgeInsets.all(8),
              child: _buildPersonalInfoSection(),
              color: Colors.teal.shade50,
              elevation: 4,
            ),
          ),
          Expanded(
            flex: 2,
            child: Card(
              margin: EdgeInsets.all(8),
              child: _buildMedicalInfoSection(),
              color: Colors.teal.shade100,
              elevation: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('patient')
          .where('userId', isEqualTo: widget.patientId)
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
        var document = snapshot.data!.docs.first;
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InformationTile(
                  icon: Icons.account_circle,
                  title: 'Name',
                  data: document['nom']
                ),
                InformationTile(
                  icon: Icons.account_circle,
                  title: 'First Name',
                  data: document['prenom']
                ),
                InformationTile(
                  icon: Icons.home,
                  title: 'Address',
                  data: document['Adresse']
                ),
                InformationTile(
                  icon: Icons.cake,
                  title: 'Date of Birth',
                  data: document['date_naissance']
                ),
                InformationTile(
                  icon: Icons.email,
                  title: 'Email',
                  data: document['email']
                ),
                InformationTile(
                  icon: Icons.phone,
                  title: 'Phone Number',
                  data: document['numero']
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMedicalInfoSection() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Dossier_medicale')
          .doc(widget.patientId)
          .collection('info_personnelle')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: Text('No medical data found'));
        }
        return ListView(
          children: snapshot.data!.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            return ExpansionTile(
              title: Text(
                'Medical Data',
                style: TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Last modified: ${_formatDateTime(data['modification_date'] ?? Timestamp(0, 0))}'
              ),
              iconColor: Colors.teal,
              children: [
                ListTile(
                  title: Text(
                    'Allergies: ${data['allergies'] ?? 'Not specified'}'
                  )
                ),
                ListTile(
                  title: Text(
                    'Blood Group: ${data['bloodGroup'] ?? 'Not specified'}'
                  )
                ),
                ListTile(
                  title: Text(
                    'Height: ${data['height'] ?? 'Not specified'} cm'
                  )
                ),
                ListTile(
                  title: Text(
                    'Weight: ${data['weight'] ?? 'Not specified'} kg'
                  )
                ),
                ListTile(
                  title: Text(
                    'Doctor: ${data['doctorName'] ?? 'Not specified'}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          }).toList(),
        );
      },
    );
  }

  String _formatDateTime(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('MMMM dd, yyyy - HH:mm:ss').format(dateTime);
  }
}

class InformationTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String data;

  InformationTile({
    required this.icon,
    required this.title,
    required this.data
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text('$title: $data'),
    );
  }
}
