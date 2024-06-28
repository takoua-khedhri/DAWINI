import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';

class AddRapportlab extends StatefulWidget {
  final String patientId;

  const AddRapportlab({Key? key, required this.patientId}) : super(key: key);

  @override
  _AddRapportlabState createState() => _AddRapportlabState();
}

class _AddRapportlabState extends State<AddRapportlab> {
  File? _file;
  File? _image;
  final ImagePicker _imagePicker = ImagePicker();
  TextEditingController typeTestController = TextEditingController();
  TextEditingController resultTestController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController dateSampleController = TextEditingController();
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

  Future<void> _pickImage() async {
    final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  Future<void> saveData() async {
    setState(() {
      isUploading = true;
    });
    String? fileUrl;
    String? imageUrl;

    try {
      if (_file != null) {
        String filePath = 'patient_files/${widget.patientId}/files/${DateTime.now().millisecondsSinceEpoch}';
        firebase_storage.UploadTask fileTask = firebase_storage.FirebaseStorage.instance
          .ref(filePath)
          .putFile(_file!);
        fileUrl = await (await fileTask.whenComplete(() => null)).ref.getDownloadURL();
      }

      if (_image != null) {
        String imagePath = 'patient_files/${widget.patientId}/images/${DateTime.now().millisecondsSinceEpoch}';
        firebase_storage.UploadTask imageTask = firebase_storage.FirebaseStorage.instance
          .ref(imagePath)
          .putFile(_image!);
        imageUrl = await (await imageTask.whenComplete(() => null)).ref.getDownloadURL();
      }

      await FirebaseFirestore.instance
        .collection('Dossier_medicale')
        .doc(widget.patientId)
        .collection('laboratoire')
        .add({
          'fileUrl': fileUrl,
          'imageUrl': imageUrl,
          'typeTest': typeTestController.text,
          'resultTest': resultTestController.text,
          'notes': notesController.text,
          'dateSample': dateSampleController.text,
          'doctorName': doctorNameController.text,
          'modificationDate': DateTime.now(),
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
        title: Text("Add Medical Report"),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: typeTestController,
              decoration: InputDecoration(
                labelText: "Type of Test",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: resultTestController,
              decoration: InputDecoration(
                labelText: "Result",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: notesController,
              decoration: InputDecoration(
                labelText: "Notes",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: dateSampleController,
              decoration: InputDecoration(
                labelText: "Date of Sample",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: doctorNameController,
              decoration: InputDecoration(
                labelText: "Doctor's Name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              icon: Icon(Icons.file_upload),
              label: Text("Upload File"),
              onPressed: _pickFile,
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              icon: Icon(Icons.image),
              label: Text("Upload Image"),
              onPressed: _pickImage,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: isUploading ? null : saveData,
              child: Text(isUploading ? "Saving..." : "Save Data"),
            ),
          ],
        ),
      ),
    );
  }
}
