import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';

class AddPersonalInformationPage extends StatefulWidget {
  final String patientId;
  const AddPersonalInformationPage({Key? key, required this.patientId}) : super(key: key);


  @override
  _AddPersonalInformationPageState createState() =>
      _AddPersonalInformationPageState();
}

class _AddPersonalInformationPageState
    extends State<AddPersonalInformationPage> {
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController allergiesController = TextEditingController();
  TextEditingController bloodGroupController = TextEditingController();
  TextEditingController doctorNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Personal Information'),
        backgroundColor: Colors.deepPurple, // Provides a deep purple app bar
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildTextField(weightController, "Weight (kg)", "Enter weight", TextInputType.number, Icons.monitor_weight),
            buildTextField(heightController, "Height (cm)", "Enter height", TextInputType.number, Icons.height),
            buildTextField(allergiesController, "Allergies", "Enter allergies", TextInputType.text, Icons.warning_amber),
            buildTextField(bloodGroupController, "Blood Group", "Enter blood group", TextInputType.text, Icons.bloodtype),
            buildTextField(doctorNameController, "Doctor's Name", "Enter doctor's name", TextInputType.text, Icons.person),
            SizedBox(height: 20),
          ElevatedButton(
  onPressed: _savePersonalInformation,
  child: Text(
    'Save',
    style: TextStyle(color: Colors.white), // Texte en blanc
  ),
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.deepPurple, // Couleur du bouton
  ),
),

          ],
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String label, String hint, TextInputType keyboardType, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.deepPurple),
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }

  Future<void> _savePersonalInformation() async {
    try {
      Map<String, dynamic> data = {
        'weight': weightController.text,
        'height': heightController.text,
        'allergies': allergiesController.text,
        'bloodGroup': bloodGroupController.text,
        'doctorName': doctorNameController.text,
        'modification_date': DateTime.now(),
      };

      // Adding a new document for each set of data
      await FirebaseFirestore.instance
          .collection('Dossier_medicale')
.doc(widget.patientId)         
 .collection('info_personnelle')
          .add(data);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Personal information saved successfully')));
      clearTextFields();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving personal information: $error')));
    }
  }

  void clearTextFields() {
    weightController.clear();
    heightController.clear();
    allergiesController.clear();
    bloodGroupController.clear();
    doctorNameController.clear();
  }
}
