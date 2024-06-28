import 'package:cloud_firestore/cloud_firestore.dart';

Future<DocumentSnapshot<Map<String, dynamic>>> getPatientData(String userId) async {
  try {
    final snapshot = await FirebaseFirestore.instance.collection('patient').doc(userId).get();
    return snapshot;  // Return the snapshot itself
  } catch (e) {
    print('Error fetching patient data: $e');
    throw Exception('Failed to fetch patient data');
  }
}



