import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'loginPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Importez le package intl pour formater la date.

class AuthentificationPage extends StatefulWidget {
  @override
  _AuthentificationPageState createState() => _AuthentificationPageState();
}

class _AuthentificationPageState extends State<AuthentificationPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nomController = TextEditingController();
  TextEditingController _prenomController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _dateOfBirthController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  String? _selectedLocation;

  List<String> _locations = [
    'Tunis',
    'Ariana',
    'Beja',
    'Ben Arous',
    'Bizerte',
    'Gabes',
    'Gafsa',
    'Jendouba',
    'Kairouan',
    'Kasserine',
    'Kebili',
    'Kef',
    'Mahdia',
    'Manouba',
    'Medenine',
    'Monastir',
    'Nabeul',
    'Sfax',
    'Sidi Bouzid',
    'Siliana',
    'Sousse',
    'Tataouine',
    'Tozeur',
    'Zaghouan'
  ];
  String generatedQrCode = '';

  void _signUp() async {
    try {
      if (_formKey.currentState != null && _formKey.currentState!.validate()) {
        // Créer un nouvel utilisateur dans Firebase Auth
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // Récupérer l'identifiant utilisateur (UID)
        String userId = userCredential.user!.uid;

        // Préparer les données du patient
        Map<String, dynamic> patientData = {
          'nom': _nomController.text,
          'prenom': _prenomController.text,
          'email': _emailController.text,
          'date_naissance': _dateOfBirthController.text,
          'Adresse': _selectedLocation,
          'numero': _phoneNumberController.text,
          'userId': userId, // Ajouter l'identifiant utilisateur à vos données
        };
// Générer le code QR
        generateQrCode(patientData);

        // Ajouter le patient à la collection "patient"
        await FirebaseFirestore.instance.collection('patient').add(patientData);

        // Enregistrer les données du patient dans la collection "dossier_medicale"
        await FirebaseFirestore.instance
            .collection(
                'Dossier_medicale') 
            .doc(
                userId) 
            .collection(
                'info_personnelle') // Accéder à la sous-collection "info_personnelle"
            .doc('info_pers')
            .set({
          'info_personnelle': patientData,
          // Ajoutez d'autres informations du dossier médical si nécessaire
        });
        
  
        // Afficher un message de confirmation
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Patient added successfully!!'),
          ),
        );
  await Future.delayed(Duration(seconds: 5));

        // Rediriger vers la page LoginPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    } catch (e) {
      print('Erreur lors de l\'ajout du patient : $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again.'),
        ),
      );
    }
  }

// Méthode pour générer le code QR
  void generateQrCode(Map<String, dynamic> patientData) {
    String data = 'Nom: ${patientData['nom']}\n'
        'Prénom: ${patientData['prenom']}\n'
        'Email: ${patientData['email']}\n'
        'Date de naissance: ${patientData['date_naissance']}\n'
        'Adresse: ${patientData['Adresse']}\n'
        'Numéro de téléphone: ${patientData['numero']}';

    setState(() {
      generatedQrCode = data;
    });
  }

  // Méthode pour afficher le sélecteur de date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _dateOfBirthController.text = DateFormat('YYYY-MM-DD').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
     
      body: Padding(
          padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Container(
                 padding: EdgeInsets.symmetric(vertical: 5.0),
  
           child: TextFormField(
  controller: _nomController,
  decoration: InputDecoration(
    labelText: 'Last Name',
    prefixIcon: Icon(Icons.person),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.blue),
    ),
      filled: true, // This is the line you need to add

    fillColor: Colors.grey[200],
  ),
  validator: (value) {
    if (value!.isEmpty) {
      return 'Please enter your last name';
    } else if (value.contains(new RegExp(r'[0-9]'))) {
      return 'Last name should not contain numbers';
    }
    return null;
  },

                ),
              ),

              // Ajout du champ de prénom
              Container(
                 padding: EdgeInsets.symmetric(vertical: 5.0),
                  child: TextFormField(
  controller: _prenomController,
  decoration: InputDecoration(
    labelText: 'First Name',
    prefixIcon: Icon(Icons.person),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.blue),
    ),
      filled: true, // This is the line you need to add

    fillColor: Colors.grey[200],
  ),
  validator: (value) {
    if (value!.isEmpty) {
      return 'Please enter your First name';
    } else if (value.contains(new RegExp(r'[0-9]'))) {
      return 'First name should not contain numbers';
    }
    return null;
  },
 ),
              ),


              // Ajout du champ d'email
              Container(
                 padding: EdgeInsets.symmetric(vertical: 5.0),
  
                child: TextFormField(
  controller: _emailController,
  decoration: InputDecoration(
    labelText: 'Email',
    prefixIcon: Icon(Icons.email),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.blue),
    ),
      filled: true, // This is the line you need to add

    fillColor: Colors.grey[200],
  ),
  validator: (value) {
    if (value!.isEmpty) {
      return 'Please enter your email';
    }
    if (!value.contains('@gmail.com')) {
      return 'Email format should contain @gmail.com';
    }
    return null;
  },
  ),
              ),

              // Ajout du champ de date de naissance
             Container(
  padding: EdgeInsets.symmetric(vertical: 5.0),
  decoration: BoxDecoration(),
  child: TextFormField(
    controller: _dateOfBirthController,
    decoration: InputDecoration(
      labelText: 'Date of Birth',
      helperText: 'Format: YYYY-MM-DD',
      prefixIcon: GestureDetector(
        onTap: () => _selectDate(context),
        child: Icon(Icons.calendar_today),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
       enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.blue),
    ),
      filled: true, // This is the line you need to add

    fillColor: Colors.grey[200],
  ),
    
    validator: (value) {
      if (value!.isEmpty) {
        return 'Please enter your Date of Birth';
      }
      // Vérifier le format de la date
if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
        return 'Invalid date format. Please use YYYY-MM-DD';
      }
      // Vérifier si la date est antérieure à la date actuelle
      DateTime selectedDate = DateTime.parse(value);
      if (selectedDate.isAfter(DateTime.now())) {
        return 'Date of Birth cannot be in the future';
      }
      // Vérifier l'âge minimum (par exemple, 18 ans)
      DateTime minimumAgeDate = DateTime.now().subtract(Duration(days: 18 * 365));
      if (selectedDate.isAfter(minimumAgeDate)) {
        return 'You must be at least 18 years old';
      }
      return null;
    },
    
  ),
),



              // Ajout du champ d'adresse avec une liste déroulante des lieux
              Container(
                 padding: EdgeInsets.symmetric(vertical: 5.0),
  decoration: BoxDecoration(
  ),
                child: DropdownButtonFormField<String>(
                  value: _selectedLocation,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedLocation = value!;
                    });
                  },
                  items:
                      _locations.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Address',
                    prefixIcon: Icon(Icons.home),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                     enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.blue),
    ),
      filled: true, // This is the line you need to add

    fillColor: Colors.grey[200],
  ),
                  
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a location';
                    }
                    return null;
                  },
                ),
              ),

              // Ajout du champ de mot de passe
              Container(
 
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: TextFormField(
                   obscureText: true,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),

                    enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: Colors.blue),
  ),
    filled: true, // This is the line you need to add
    fillColor: Colors.grey[200],

   ),
                  validator: (value) {
                    if (value!.isEmpty || value == null) {
                      return 'Please enter your password';
                    }
                      if (value.length < 6){
                      return 'Password must be at least 6 characters long';
                      }
                    
                    return null;
                  },
                ),
              ),

              // Ajout du champ de confirmation de mot de passe
              Container(
                 padding: EdgeInsets.symmetric(vertical: 5.0),
          child: TextFormField(
                   obscureText: true,
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon: Icon(Icons.lock),
                    
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                     enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.blue),
    ),
      filled: true, // This is the line you need to add

    fillColor: Colors.grey[200],
  
                  ),
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
              ),

              // Ajout du champ de numéro de téléphone
              Container(
                padding: EdgeInsets.symmetric(vertical: 5.0),
  decoration: BoxDecoration(
    
  ),
                child: TextFormField(
                  controller: _phoneNumberController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                     enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.blue),
    ),
      filled: true, // This is the line you need to add

    fillColor: Colors.grey[200],
  
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    if (value.length != 8) {
                      return 'Phone number must be 8 digits long';
                    }
                    return null;
                  },
                ),
              ),
               Padding(
  padding: const EdgeInsets.symmetric(vertical: 16.0),
  child: Center(
    child: generatedQrCode.isEmpty
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.qr_code), // Icône du code QR
              SizedBox(width: 8.0), // Espacement entre l'icône et le texte
              Text(
                'No QR code generated yet',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold, // Mettre le texte en gras
                ),
              ),
            ],
          )
        : QrImageView(
            data: generatedQrCode,
            version: QrVersions.auto,
            size: 200.0,
          ),
  ),
),

              Padding(
                
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                
                child: ElevatedButton(
                  onPressed: _signUp,
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                    minimumSize: MaterialStateProperty.all<Size>(Size(260, 50)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  child: Text(
                    'Confirm',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 40),

            ],
          ),
        ),
      ),
    );
  }
}
