import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AddConsultation extends StatefulWidget {
  final String patientId;

  const AddConsultation({Key? key, required this.patientId}) : super(key: key);

  @override
  _AddConsultationState createState() => _AddConsultationState();
}

class _AddConsultationState extends State<AddConsultation> {
  File? _file;
  final ImagePicker _imagePicker = ImagePicker();
  TextEditingController ordonnanceController = TextEditingController();
  TextEditingController remarksController = TextEditingController();
  TextEditingController consultationDateController = TextEditingController();
  TextEditingController doctorNameController = TextEditingController();
  bool isUploading = false;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null) {
      setState(() {
        _file = File(result.files.single.path!);
      });
    }
  }

  Future<void> saveData() async {
    setState(() {
      isUploading = true;
    });
    String? fileUrl;

    try {
      if (_file != null) {
        String filePath = 'patient_files/${widget.patientId}/files/${DateTime.now().millisecondsSinceEpoch}';
        firebase_storage.UploadTask fileTask = firebase_storage.FirebaseStorage.instance
          .ref(filePath)
          .putFile(_file!);
        fileUrl = await (await fileTask.whenComplete(() => null)).ref.getDownloadURL();
      }

      await FirebaseFirestore.instance
        .collection('Dossier_medicale')
        .doc(widget.patientId)
        .collection('consultation')
        .add({
          'fileUrl': fileUrl,
          'ordonnance': ordonnanceController.text,
          'remarks': remarksController.text,
          'consultationDate': consultationDateController.text,
          'doctorName': doctorNameController.text,
          'modificationDate': DateFormat('yyyy-MM-dd').format(DateTime.now()),
        });

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data saved successfully!")));
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Consultation"),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(
              'Ordonnance:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              icon: Icon(Icons.file_upload),
              label: Text("Upload File"),
              onPressed: _pickFile,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            ),
            if (_file != null) Text('Selected file: ${_file!.path}'),
            SizedBox(height: 20),
            TextField(
              controller: ordonnanceController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Write Ordonnance Manually",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Doctor\'s Remarks:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 10),
            TextField(
              controller: remarksController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Enter remarks here",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Consultation Date:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 10),
            TextField(
              controller: consultationDateController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter consultation date (yyyy-mm-dd)',
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Doctor\'s Name:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 10),
            TextField(
              controller: doctorNameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter doctor\'s name',
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: isUploading ? null : saveData,
              child: Text(isUploading ? "Saving..." : "Save Data"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    ordonnanceController.dispose();
    remarksController.dispose();
    consultationDateController.dispose();
    doctorNameController.dispose();
    super.dispose();
  }
}


