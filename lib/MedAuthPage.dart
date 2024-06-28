import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'MedLoginPage.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Med_AuthentificationPage extends StatefulWidget {
  @override
  _AuthentificationPageState createState() => _AuthentificationPageState();
}

class _AuthentificationPageState extends State<Med_AuthentificationPage> {
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
  TextEditingController _lieuController = TextEditingController();
  TextEditingController _IDController = TextEditingController();
  TextEditingController _YearsOfExperienceController = TextEditingController();
  String? _selectedLocation;

  List<String> _locations = [
    'Ariana', 'Beja', 'Ben Arous', 'Bizerte', 'Gabes', 'Gafsa', 'Jendouba',
    'Kairouan', 'Kasserine', 'Kebili', 'Kef', 'Mahdia', 'Manouba', 'Medenine',
    'Monastir', 'Nabeul', 'Sfax', 'Sidi Bouzid', 'Siliana', 'Sousse', 'Tataouine',
    'Tozeur', 'Tunis', 'Zaghouan'
  ];

  List<String> _specialites = [
    'Osteology', 'Cardiology', 'Pulmonology', 'Facial Plastic Surgery', 'Rhinology',
    'Otology', 'Gynecology', 'Dentist', 'Orthopedics', 'Hepatology', 'Ophthalmology',
    'Urology', 'Diabetes'
  ];

  bool isPrivate = false; 
  bool isState = false; 
  List<String> selectedDays = []; 
  Map<String, List<String>> horairesParJour = {};
  String? _userImageUrl = '';
  File? _image;

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  void _signUp() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        String userId = userCredential.user!.uid;
        String imageUrl = '';
        if (_image != null) {
          final Reference storageReference = FirebaseStorage.instance
              .ref()
              .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');
          final UploadTask uploadTask = storageReference.putFile(_image!);
          await uploadTask.whenComplete(() async {
            imageUrl = await storageReference.getDownloadURL();
          });
        }

        Map<String, dynamic> medecinData = {
          'photoUrl': imageUrl,
          'nom': _nomController.text,
          'prenom': _prenomController.text,
          'email': _emailController.text,
          'date_naissance': _dateOfBirthController.text,
          'Adresse': _addressController.text,
          'numero': _phoneNumberController.text,
          'specialite': _specialiteController.text,
          'ID': _IDController.text, // Fetching from controller
          'experience': _YearsOfExperienceController.text, // Fetching from controller
 // Fetching from controller
          'isPrivate': isPrivate,
          'isState': isState,
          'userId': userId,
          'jours_travail': selectedDays,
          'horaires': horairesParJour,
          'lieu': _selectedLocation,
        };

        await FirebaseFirestore.instance
            .collection('prestataire_service')
            .doc('Medecin')
            .collection('Medecin')
            .add(medecinData);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Médecin ajouté avec succès !'))
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Med_LoginPage())
        );
      } catch (e) {
        print('Erreur lors de l\'ajout du médecin : $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Une erreur est survenue. Veuillez réessayer.'))
        );
      }
    }
  }

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
                      CircleAvatar(
                        radius: 30.0,
                        backgroundImage: _image != null ? FileImage(_image!) : null,
                        child: _image == null ? Icon(Icons.person) : null,
                      ),
                      SizedBox(height: 10.0),
                      ElevatedButton(
                        onPressed: _pickImage,
                        child: Text('Choose Photo'),
                      ),
                    ],
                  ),
                ),

      
                SizedBox(height: 20.0),
                Container(
                 padding: EdgeInsets.symmetric(vertical: 5.0),
                  child: TextFormField(
  controller: _prenomController,
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
      return 'First name should not contain numbers';
    }
    return null;
  },
 ),
              ),
                SizedBox(height: 8.0),
                Container(
                 padding: EdgeInsets.symmetric(vertical: 5.0),
                  child: TextFormField(
  controller: _nomController,
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


                SizedBox(width: 8.0),
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


                SizedBox(width: 8.0),
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

                SizedBox(width: 8.0),
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
                      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blue),
      ),
      filled: true,
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
                SizedBox(width: 8.0),
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

                SizedBox(width: 8.0),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: DropdownButtonFormField<String>(
                    value: _selectedLocation,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedLocation = value!;
                      });
                    },
                    items: _locations
                        .map<DropdownMenuItem<String>>((String value) {
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

                SizedBox(width: 8.0),

                Container(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelText: 'Professional address ',
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
                      if (value!.isEmpty) {
                        return 'Please enter your Professional address ';
                      }

                      return null;
                    },
                  ),
                ),

                SizedBox(width: 8.0),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: DropdownButtonFormField<String>(
                    value: _specialiteController.text.isNotEmpty
                        ? _specialiteController.text
                        : null,
                    onChanged: (String? value) {
                      setState(() {
                        _specialiteController.text = value!;
                      });
                    },
                    items: _specialites
                        .map<DropdownMenuItem<String>>((String value) {
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
                       enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.blue),
    ),
      filled: true, // This is the line you need to add

    fillColor: Colors.grey[200],
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a speciality';
                      }
                      return null;
                    },
                  ),
                ),

                SizedBox(width: 8.0),

                Container(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: _IDController,
                    decoration: InputDecoration(
                      labelText: 'Unique identifier',
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
                        return 'Please enter your Unique identifier';
                      }

                      return null;
                    },
                  ),
                ),
                          SizedBox(width: 8.0),

                          Container(
  padding: EdgeInsets.symmetric(vertical: 5.0),
  child: TextFormField(
    controller: _YearsOfExperienceController,
    decoration: InputDecoration(
      labelText: 'Years of Experience',
      prefixIcon: Icon(Icons.work),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blue),
      ),
      filled: true,
      fillColor: Colors.grey[200],
    ),
    validator: (value) {
      if (value!.isEmpty) {
        return 'Please enter your years of experience';
      }
      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
        return 'Experience must be a valid number';
      }
      return null;
    },
  ),
),
                          SizedBox(width:10),

             Row(
  children: [
    Expanded(
      child: CheckboxListTile(
        title: Text('Private doctor', style: TextStyle(fontWeight: FontWeight.bold)),
        value: isPrivate,
        onChanged: (bool? value) {
          if (value != null) {
            setState(() {
              isPrivate = value;
              isState = !value;
            });
          }
        },
        controlAffinity: ListTileControlAffinity.leading,  // Position the checkbox at the start of the tile
      ),
    ),
    Expanded(
      child: CheckboxListTile(
        title: Text('State doctor', style: TextStyle(fontWeight: FontWeight.bold)),
        value: isState,
        onChanged: (bool? value) {
          if (value != null) {
            setState(() {
              isState = value;
              isPrivate = !value;
            });
          }
        },
        controlAffinity: ListTileControlAffinity.leading,  // Position the checkbox at the start of the tile
      ),
    ),
  ],
),


                SizedBox(width: 8.0),
              Text('Working Days:', style: TextStyle(fontWeight: FontWeight.bold)),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  children: List.generate(7, (index) {
                    String day = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'][index];
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(child: Text(day)),
                        Switch(
                          value: selectedDays.contains(day),
                          onChanged: (bool value) {
                            setState(() {
                              if (value) {
                                selectedDays.add(day);
                                horairesParJour[day] = ['08:00', '17:00']; // default hours
                              } else {
                                selectedDays.remove(day);
                                horairesParJour.remove(day);
                              }
                            });
                          },
                        ),
                      ],
                    );
                  }),
                ),
                SizedBox(width: 8.0),

                Text('Working Hours:', style: TextStyle(fontWeight: FontWeight.bold)),
                Column(
                  children: selectedDays.map((day) {
                    return Row(
                      children: [
                        Text('$day:'),
                        SizedBox(width: 20),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              TimeOfDay? newTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay(hour: int.parse(horairesParJour[day]![0].split(':')[0]), minute: int.parse(horairesParJour[day]![0].split(':')[1])),
                              );
                              if (newTime != null) {
                                setState(() => horairesParJour[day]![0] = newTime.format(context));
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(width: 1)),
                              ),
                              child: Text(horairesParJour[day]![0]),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              TimeOfDay? newTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay(hour: int.parse(horairesParJour[day]![1].split(':')[0]), minute: int.parse(horairesParJour[day]![1].split(':')[1])),
                              );
                              if (newTime != null) {
                                setState(() => horairesParJour[day]![1] = newTime.format(context));
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(width: 1)),
                              ),
                              child: Text(horairesParJour[day]![1]),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
               

                
        
        
              
                SizedBox(width: 80),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: ElevatedButton(
                    onPressed: _signUp,
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                      minimumSize:
                          MaterialStateProperty.all<Size>(Size(250, 40)),
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
