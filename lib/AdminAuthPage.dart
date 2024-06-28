//import 'package:flutter/material.dart';
//import 'AdminLoginPage.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

//class AdminAuthPage extends StatefulWidget {
  //@override
//  _AuthentificationPageState createState() => _AuthentificationPageState();
//}

 //class _AuthentificationPageState extends State<AdminAuthPage> {
  
 // final _formKey = GlobalKey<FormState>();

  //TextEditingController _emailController = TextEditingController();

 // TextEditingController _passwordController = TextEditingController();
  //TextEditingController _confirmPasswordController = TextEditingController();

  //void _signUp() async {
   // try {
    //  if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      //  // Créer un nouvel utilisateur dans Firebase Auth
        //UserCredential userCredential =
          //  await FirebaseAuth.instance.createUserWithEmailAndPassword(
          //email: _emailController.text,
          //password: _passwordController.text,
        //);

        // Récupérer l'identifiant utilisateur (UID)
        //String userId = userCredential.user!.uid;

        // Préparer les données du patient
        //Map<String, dynamic> patientData = {
          //'email': _emailController.text,
          //'password' :_passwordController.text,
         // 'userId': userId, // Ajouter l'identifiant utilisateur à vos données
       // };

        // Ajouter le patient à la collection "administrateur"
       // await FirebaseFirestore.instance
          //  .collection('Administrateur')
          //  .add(patientData);


        // Afficher un message de confirmation
      //  ScaffoldMessenger.of(context).showSnackBar(
       //   SnackBar(
     //       content: Text('Administrator added successfully!!'),
       //   ),
        //);

        // Rediriger vers la page LoginPage
       // Navigator.pushReplacement(
        //  context,
        //  MaterialPageRoute(builder: (context) => AdminLoginPage()),
       // );
     /// }
   // } catch (e) {
     // print('Erreur lors de l\'ajout du administrateur : $e');
      //ScaffoldMessenger.of(context).showSnackBar(
        //SnackBar(
         // content: Text('An error occurred. Please try again.'),
       // ),
      //);
   // }
 // }

  //@override
  //Widget build(BuildContext context) {
   // return Scaffold(
    //  appBar: AppBar(
      //  leading: IconButton(
       //   icon: Icon(Icons.arrow_back),
         // onPressed: () {
          //  Navigator.of(context).pop();
         // },
       // ),
      //),
     // body: Padding(
       // padding: EdgeInsets.all(16.0),
       // child: Form(
        //  key: _formKey,
         // child: ListView(
          //  children: <Widget>[
              // Ajout du champ d'email
            //  Container(
              //  padding: EdgeInsets.symmetric(vertical: 8.0),
              //  decoration: BoxDecoration(),
                //child: TextFormField(
                 // controller: _emailController,
                //  decoration: InputDecoration(
                  //  labelText: 'Email',
                  //  prefixIcon: Icon(Icons.email),
                   // border: OutlineInputBorder(
                   //   borderRadius: BorderRadius.circular(12),
                  //  ),
                  //),
                //  validator: (value) {
                  //  if (value!.isEmpty) {
                    //  return 'Please enter your email';
                    //}
                    //if (!value.contains('@gmail.com')) {
                     // return 'Invalid email format. Only Gmail addresses are allowed';
                    //}
                    //return null;
                  //},
                //),
              //),


              // Ajout du champ de mot de passe
              //Container(
               // decoration: BoxDecoration(),
                //padding: EdgeInsets.symmetric(vertical: 8.0),
                //child: TextFormField(
                 // obscureText: true,
                //  controller: _passwordController,
                 // decoration: InputDecoration(
                  //  labelText: 'Password',
                  //  prefixIcon: Icon(Icons.lock),
                   // border: OutlineInputBorder(
                    //  borderRadius: BorderRadius.circular(12),
                    //),
                  //),
                  //validator: (value) {
                   // if (value!.isEmpty || value.length < 6) {
                    //  return 'Password must be at least 6 characters long';
                    //}
                    //return null;
                 // },
               // ),
              //),

              // Ajout du champ de confirmation de mot de passe
              //Container(
               // padding: EdgeInsets.symmetric(vertical: 8.0),
                //decoration: BoxDecoration(),
                //child: TextFormField(
                 // obscureText: true,
                 // controller: _confirmPasswordController,
                 // decoration: InputDecoration(
                  //  labelText: 'Confirm Password',
                   // prefixIcon: Icon(Icons.lock),
                   // border: OutlineInputBorder(
                     // borderRadius: BorderRadius.circular(12),
                   // ),
                  //),
                  //validator: (value) {
                   // if (value != _passwordController.text) {
                    //  return 'Passwords do not match';
                    //}
                   // return null;
                  //},
                //),
              //),

             //  Container(
               // padding: EdgeInsets.symmetric(vertical: 8.0),
                //decoration: BoxDecoration(),
               // child: ElevatedButton(
                 // onPressed: _signUp,
                 // style: ButtonStyle(
                   // backgroundColor:
                     //   MaterialStateProperty.all<Color>(Colors.blue),
                    //minimumSize: MaterialStateProperty.all<Size>(Size(260, 50)),
                  //  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    //  RoundedRectangleBorder(
                      //  borderRadius: BorderRadius.circular(12),
                      //),
                    //),
                  //),
                  //child: Text(
                    //'Confirm',
                    //style: TextStyle(
                     // color: Colors.white,
                     // fontWeight: FontWeight.bold,
                      //fontSize: 18,
                  //  ),
                  //),
                //),
              //),

             // SizedBox(height: 40),
            //],
          //),
       // ),
      //),
    //);
  //}
//}