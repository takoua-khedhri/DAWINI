import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PaymentDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Details'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('payment').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No payment data found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var paymentData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow('Card Number', paymentData['cardNumber']),
                        _buildDetailRow('Selected Card', paymentData['selectedCard']),
                        _buildDetailRow('Timestamp', _formatTimestamp(paymentData['timestamp'])), // Formater le timestamp avant de l'afficher
                        _buildFutureDetailRow('Patient Name', _fetchPatientName(paymentData['idPatient'])),
                        _buildFutureDetailRow('Doctor Name', _fetchDoctorName(paymentData['idMedecin'])),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildDetailRow(String title, dynamic data) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(data?.toString() ?? 'N/A'), // Afficher 'N/A' si les données sont nulles
        ],
      ),
    );
  }

  Widget _buildFutureDetailRow(String title, Future<String> futureData) {
    return FutureBuilder<String>(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CircularProgressIndicator(),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('Error: ${snapshot.error}'),
              ],
            ),
          );
        } else {
          return _buildDetailRow(title, snapshot.data ?? 'N/A');
        }
      },
    );
  }

  Future<String> _fetchPatientName(String patientId) async {
    var patientQuery = await FirebaseFirestore.instance.collection('patient').where('userId', isEqualTo: patientId).get();
    var patientDoc = patientQuery.docs.first.data();
    var nom = patientDoc['nom'];
    var prenom = patientDoc['prenom'];
    return '$prenom $nom'; // Retourner le nom complet en concaténant le prénom et le nom
  }

 Future<String> _fetchDoctorName(String doctorId) async {
  var doctorQuery = await FirebaseFirestore.instance.collection('prestataire_service')
    .doc('Medecin').collection('Medecin')
    .where('userId', isEqualTo: doctorId).get();

  var doctorDoc = doctorQuery.docs.first.data();
  if (doctorDoc != null) {
    return '${doctorDoc['prenom']} ${doctorDoc['nom']}';
  } else {
    return 'Unknown';
  }
}

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) {
      return 'N/A'; // Retourner 'N/A' si le timestamp est null
    }
    // Utiliser la classe DateFormat pour formater la date et l'heure
    final dateTime = (timestamp as Timestamp).toDate(); // Convertir Timestamp en DateTime
    final formattedDate = DateFormat.yMMMd().add_jm().format(dateTime); // Formater la date et l'heure
    return formattedDate;
  }
}
