import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'MedLoginPage.dart';
import 'package:intl/intl.dart'; 
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Emg_AuthPage extends StatefulWidget {
  @override
  Emg_AuthPageState createState() => Emg_AuthPageState();
}

class Emg_AuthPageState extends State<Emg_AuthPage> {
  
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nomController = TextEditingController();
  TextEditingController _prenomController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _dateOfBirthController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _specialiteController = TextEditingController();
  TextEditingController _tarifController = TextEditingController();
  TextEditingController _experienceController = TextEditingController();
  TextEditingController _lieuController = TextEditingController();
  TextEditingController _photoController = TextEditingController(); 
  TextEditingController _IDController = TextEditingController(); 
  TextEditingController _YearsOfExperienceController = TextEditingController(); 
  String? _selectedLocation;
   bool workAtHome = false;
  bool workInOffice = false;
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
    'Tunis',
    'Zaghouan'
  ];
  List<String> _specialites = [
   'Pediatrics',
    'Geriatrics',
    'Intensive Care',
    
  ];
  

  List<String> selectedDays = []; // Jours de travail sélectionnés
  Map<String, List<String>> horairesParJour = {};
  

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

        // Préparer les données du médecin
        Map<String, dynamic> infermierData = {
          'nom': _nomController.text,
          'prenom': _prenomController.text,
          'email': _emailController.text,
          'date_naissance': _dateOfBirthController.text,
          'Adresse': _addressController.text,
          'numero': _phoneNumberController.text,
          'specialite': _specialiteController.text,
          'tarif': _tarifController.text,
          'experience': _experienceController.text,
          'workAtHome': workAtHome,
          'workInOffice': workInOffice,
          'userId': userId, // Ajouter l'identifiant utilisateur à vos données
          'jours_travail': selectedDays,
          'horaires': horairesParJour,
          'lieu': _selectedLocation,
          
          
        };

        // Ajouter le médecin à la collection "medecin"
        await FirebaseFirestore.instance.collection('prestataire_service').doc('Infermiere').collection('Infermiere').add(infermierData);

        // Afficher un message de confirmation
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Médecin ajouté avec succès !'),
          ),
        );

        // Rediriger vers la page LoginPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Med_LoginPage()),
        );
      }
    } catch (e) {
      print('Erreur lors de l\'ajout du médecin : $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Une erreur est survenue. Veuillez réessayer.'),
        ),
      );
    }
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
        _dateOfBirthController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }
late Widget _userImage = CircleAvatar(
  radius: 50.0,
  child: Icon(Icons.person),
);

   Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _userImage = CircleAvatar(
          radius: 50.0,
 
          backgroundImage: FileImage(File(image.path)),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  // Displaying the user's image
                  _userImage,
                  SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed:
                        _pickImage, // Action to choose a photo from the gallery
                    child: Text('Choose Photo'),
                  ),
                ],
              ),
            ),

                SizedBox(height: 25.0),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: _nomController,
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your Last Name';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: _prenomController,
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your First Name';
                      }
                      return null;
                    },
                  ),
                ),


SizedBox(width: 10),
            Container(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@gmail.com')) {
                      return 'Invalid email format. Only Gmail addresses are allowed';
                    }
                    return null;
                  },
                ),
              ),
SizedBox(width: 10),
            Container(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: _dateOfBirthController,
                  decoration: InputDecoration(
                    labelText: 'Date of Birth',
                    suffixIcon: GestureDetector(
                      onTap: () => _selectDate(context),
                      child: Icon(Icons.calendar_today),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your Date of Birth';
                    }
                    return null;
                  },
                ),
              ),
SizedBox(width: 10),
          Container(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty || value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
              ),
SizedBox(width: 10),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon: Icon(Icons.lock),
                    
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
              ),
SizedBox(width: 10),
             Container(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: _phoneNumberController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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
                

SizedBox(width: 10),
                Container(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: DropdownButtonFormField<String>(
                  value: _selectedLocation,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedLocation = value!;
                    });
                  },
                  items: _locations.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'lieu',
                    prefixIcon: Icon(Icons.home),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a location';
                    }
                    return null;
                  },
                ),
              ),

              SizedBox(width: 10),

              Container(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    prefixIcon: Icon(Icons.home),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your professional address';
                    }
                    
                    return null;
                  },
                ),
              ),

SizedBox(width: 10),
           Container(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: DropdownButtonFormField<String>(
                    value: _specialiteController.text.isNotEmpty ? _specialiteController.text : null,
                    onChanged: (String? value) {
                      setState(() {
                        _specialiteController.text = value!;
                      });
                    },
                    items: _specialites.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Speciality',
                      prefixIcon: Icon(Icons.medical_services),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a speciality';
                      }
                      return null;
                    },
                  ),
                ),

SizedBox(width: 10),

   Container(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                    controller: _IDController,
                  decoration: InputDecoration(
                    labelText: 'ID Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your ID number';
                    }
                    
                    return null;
                  },
                ),
              ),

SizedBox(width: 10),
               Container(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
              controller: _YearsOfExperienceController,
                  decoration: InputDecoration(
                    labelText: 'Years of experience',
                    prefixIcon: Icon(Icons.book),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your Years of experience';
                    }
                    
                    return null;
                  },
                ),
              ),
               
                // Ajouter un widget pour sélectionner les jours de travail
                SizedBox(width: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Working Days :'),
                    Wrap(
                      children: [
                        for (var day in ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'])
                          Checkbox(
                            value: selectedDays.contains(day),
                            onChanged: (value) {
                              setState(() {
                                if (value!) {
                                  selectedDays.add(day);
                                } else {
                                  selectedDays.remove(day);
                                  // Supprimez également les horaires si le jour est décoché
                                  horairesParJour.remove(day);
                                }
                              });
                            },
                          ),
                      ],
                    ),
                  ],
                ),
                // Ajouter un widget pour sélectionner les horaires de travail
                SizedBox(width: 50),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Working Hours :'),
                    for (var day in selectedDays)
                      Row(
                        children: [
                          Text(day + ' : '),
                          SizedBox(width: 20),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(labelText: 'Beginning time'),
                              onChanged: (value) {
                                // Mettre à jour les horaires dans le map horairesParJour
                                if (horairesParJour.containsKey(day)) {
                                  horairesParJour[day]![0] = value;
                                } else {
                                  horairesParJour[day] = [value, ''];
                                }
                              },
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(labelText: 'Finish time'),
                              
                              onChanged: (value) {
                                // Mettre à jour les horaires dans le map horairesParJour
                                if (horairesParJour.containsKey(day)) {
                                  horairesParJour[day]![1] = value;
                                } else {
                                  horairesParJour[day] = ['', value];
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                 SizedBox(width: 50),
                 CheckboxListTile(
                  title: Text('Work at Home'),
                  value: workAtHome,
                  onChanged: (value) {
                    setState(() {
                      workAtHome = value!;
                      if (value) {
                        workInOffice = false;
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('Work in Office'),
                  value: workInOffice,
                  onChanged: (value) {
                    setState(() {
                      workInOffice = value!;
                      if (value) {
                        workAtHome = false;
                      }
                    });
                  },
                ),
                SizedBox(width: 100),
                Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: ElevatedButton(
                  onPressed: _signUp,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
