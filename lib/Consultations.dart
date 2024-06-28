import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ConsultationsPage extends StatefulWidget {
  final String userId;

  ConsultationsPage({required this.userId});

  @override
  _ConsultationsPageState createState() => _ConsultationsPageState();
}

class _ConsultationsPageState extends State<ConsultationsPage> {
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
      appBar: AppBar(
        title: Text("Consultations"),
        backgroundColor: Colors.teal,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Dossier_medicale')
            .doc(widget.userId)
            .collection('consultation')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No consultations found."));
          }

          final consultations = snapshot.data!.docs;

          return ListView.builder(
            itemCount: consultations.length,
            itemBuilder: (context, index) {
              var consultation = consultations[index].data() as Map<String, dynamic>;
              return Card(
                margin: EdgeInsets.all(10.0),
                child: ListTile(
                  title: Text(
                    "Consultation Date: ${consultation['consultationDate']}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5),
                      RichText(
                        text: TextSpan(
                          text: "Doctor's Name: ",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                          children: [
                            TextSpan(
                              text: consultation['doctorName'],
                              style: TextStyle(fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      RichText(
                        text: TextSpan(
                          text: "Prescription: ",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                          children: [
                            TextSpan(
                              text: consultation['ordonnance'] ?? 'N/A',
                              style: TextStyle(fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      RichText(
                        text: TextSpan(
                          text: "Remarks: ",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                          children: [
                            TextSpan(
                              text: consultation['remarks'],
                              style: TextStyle(fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      if (consultation['fileUrl'] != null && consultation['fileUrl'].isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => Dialog(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.network(consultation['fileUrl']),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Close"),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          child: Image.network(
                            consultation['fileUrl'],
                            height: 100,
                            width: 100,
                          ),
                        ),
                      SizedBox(height: 10),
                      Text(
                        "Modification Date: ${consultation['modificationDate']}",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
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
}
