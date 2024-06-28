import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';

class AddImageAndFilePage extends StatefulWidget {
  final String patientId;

  const AddImageAndFilePage({Key? key, required this.patientId}) : super(key: key);

  @override
  _AddImageAndFilePageState createState() => _AddImageAndFilePageState();
}

class _AddImageAndFilePageState extends State<AddImageAndFilePage> {
  File? _file;
  File? _image;
  TextEditingController _noteController = TextEditingController();
  TextEditingController _doctorNameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

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
        .collection('Scanner')
        .add({
          'fileUrl': fileUrl,
          'imageUrl': imageUrl,
          'notes': _noteController.text,
          'description': _descriptionController.text,
          'doctorName': _doctorNameController.text,
          'timestamp': FieldValue.serverTimestamp(),
        });

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data saved successfully!")));
    } catch (e) {
      print('Error saving data: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error saving data: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Image and File"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: saveData,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              onTap: _pickFile,
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.teal),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: _file == null
                      ? Text('Tap to select a file', style: TextStyle(color: Colors.teal))
                      : Text('File selected: ${_file!.path}', style: TextStyle(color: Colors.teal)),
                ),
              ),
            ),
            SizedBox(height: 16),
            InkWell(
              onTap: _pickImage,
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.teal),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: _image == null
                      ? Text('Tap to select an image', style: TextStyle(color: Colors.teal))
                      : Text('Image selected: ${_image!.path}', style: TextStyle(color: Colors.teal)),
                ),
              ),
            ),
            SizedBox(height: 16),
            buildTextField(_descriptionController, "Description"),
            SizedBox(height: 16),
            buildTextField(_noteController, "Notes"),
            SizedBox(height: 16),
            buildTextField(_doctorNameController, "Doctor's Name"),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        fillColor: Colors.teal.shade50,
        filled: true,
      ),
      maxLines: null,
    );
  }
}
