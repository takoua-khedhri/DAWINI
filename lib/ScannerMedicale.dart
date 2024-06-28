import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ScannerMedicale extends StatefulWidget {
  final String userId;

  ScannerMedicale({required this.userId});

  @override
  _ScannerMedicale createState() => _ScannerMedicale();
}

class _ScannerMedicale extends State<ScannerMedicale> {
  late User? _user;
  late String _userId = '';

  @override
  void initState() {
    super.initState();
    _userId = widget.userId;
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Dossier_medicale')
            .doc(widget.userId)
            .collection('Scanner')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No scanner data found'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;
              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
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
                              data['imageUrl'],
                              fit: BoxFit.contain,
                              width: MediaQuery.of(context).size.width, // Full width
                              height: MediaQuery.of(context).size.height, // Full height
                            ),
                          ),
                        ),
                      );
                    }));
                  },
                  leading: data['imageUrl'] != null
                      ? Image.network(data['imageUrl'], width: 150, height: 200, fit: BoxFit.cover) // Enlarge the image
                      : Icon(Icons.image_not_supported),
                  title: Text(data['description'] ?? 'No description', style: TextStyle(fontWeight: FontWeight.bold)), // Bold title
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Notes: ${data['notes'] ?? 'No notes'}', style: TextStyle(fontWeight: FontWeight.bold)), // Bold subtitle
                      Text('Doctor: ${data['doctorName'] ?? 'Unknown'}', style: TextStyle(fontWeight: FontWeight.bold)), // Bold subtitle
                      Text('File URL: ${data['fileUrl'] ?? 'No file URL available'}', style: TextStyle(fontWeight: FontWeight.bold)), // Bold subtitle
                      Text('Date: ${_formatDate(data['timestamp'] ?? Timestamp(0, 0))}', style: TextStyle(fontWeight: FontWeight.bold)), // Bold subtitle
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return '${dateTime.year}-${dateTime.month}-${dateTime.day}';
  }
}
