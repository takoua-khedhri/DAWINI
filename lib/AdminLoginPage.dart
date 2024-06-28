import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'pageAdministrateur.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<AdminLoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String errorMessage = '';

  Future<void> signIn() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Query Firestore to check if the email exists in the Administrateur collection
        QuerySnapshot adminSnapshot = await FirebaseFirestore.instance
            .collection('Administrateur')
            .where('email', isEqualTo: _emailController.text.trim())
            .limit(1)
            .get();

        if (adminSnapshot.docs.isNotEmpty) {
          // Email exists, check if the password matches
          var adminData =
              adminSnapshot.docs.first.data() as Map<String, dynamic>;
          var storedPassword = adminData['password'];

          if (storedPassword == _passwordController.text.trim()) {
            // Password matches, authenticate user and navigate to admin page
            print("Authentication successful");
// Navigate to the admin page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdminDashboard()), // Assuming PageAdministrateur is the name of the page
          );
            return;
          } else {
            // Password doesn't match
            setState(() {
              errorMessage = 'Incorrect email or password';
            });
            return;
          }
        } else {
          // Email doesn't exist in the Administrateur collection
          setState(() {
            errorMessage = 'Incorrect email or password';
          });
          return;
        }
      } catch (e) {
        print('Error during sign-in: $e');
        setState(() {
          errorMessage = 'An error occurred. Please try again.';
        });
      }
    }
  }

  void _clearErrorMessage() {
    setState(() {
      errorMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment
                .center, // Ajoutez cette ligne pour centrer verticalement
            children: [
              SizedBox(height: 20),
              Container(
                height: errorMessage.isNotEmpty ? 30 : 0,
                child: Center(
                  child: Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Form(
                    key: _formKey,
                    autovalidateMode:
                        AutovalidateMode.onUserInteraction, // Auto-validation
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: _emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email address';
                            } else if (!value.contains('@gmail.com')) {
                              return 'The email address must contain @gmail.com';
                            }
                            return null;
                          },
                          onChanged: (_) => _clearErrorMessage(),
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            hintText: 'Email',
                            fillColor: Colors.grey[200],
                            filled: true,
                          ),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                          onChanged: (_) => _clearErrorMessage(),
                          obscureText: true,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            hintText: 'Password',
                            fillColor: Colors.grey[200],
                            filled: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: ElevatedButton(
                  onPressed: signIn,
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
              SizedBox(height: 20),
              Container(
                height: errorMessage.isNotEmpty ? 30 : 0,
                child: Center(
                  child: Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
