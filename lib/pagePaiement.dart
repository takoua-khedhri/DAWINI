import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentOptionsPage extends StatefulWidget {
  final String idMedecin;
  final String idPatient;

  PaymentOptionsPage({required this.idMedecin, required this.idPatient});

  @override
  PaymentOptionsPageState createState() => PaymentOptionsPageState();
}


class PaymentOptionsPageState extends State<PaymentOptionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Choose your payment method:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 37, 0, 200),
              ),
            ),
            ElevatedButton.icon(
              icon: Image.asset('assets/images/paiement_cash.png',
                  width: 50, height: 50),
              label: Text('Pay with cash',
                  style: TextStyle(fontSize: 18, color: Colors.white)),
              onPressed: () {
                print('Cash payment selected');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 70, vertical: 25),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Image.asset('assets/images/paiement_card.png',
                  width: 50, height: 50),
              label: Text('Pay with card',
                  style: TextStyle(fontSize: 18, color: Colors.white)),
             onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => CardPaymentPage(
      idMedecin: widget.idMedecin,
      idPatient: widget.idPatient,
    )),
  );
},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 70, vertical: 25),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardPaymentPage extends StatefulWidget {
  final String idMedecin;
  final String idPatient;

  CardPaymentPage({required this.idMedecin, required this.idPatient});

  @override
  CardPaymentPageState createState() => CardPaymentPageState();
}


class CardPaymentPageState extends State<CardPaymentPage> {
  final _formKey = GlobalKey<FormState>();
  String cardNumber = '';
  String expiryDate = '';
  String cvv = '';
  String? selectedCard;

  List<Map<String, dynamic>> cardOptions = [
    {'name': 'Visa', 'image': 'assets/images/visa_card.png'},
    {'name': 'MasterCard', 'image': 'assets/images/mastercard.png'},
    {'name': 'Bank Card', 'image': 'assets/images/bank_card.png'},
    {'name': 'American Express', 'image': 'assets/images/american_express.png'},
    {'name': 'PayPal', 'image': 'assets/images/paypal.png'},
    {'name': 'e-Dinars', 'image': 'assets/images/d17.jpg'},
  ];

  Map<String, List<String>> cardFormFields = {
    'Visa': ['Card Number', 'Expiry Date', 'CVV'],
    'MasterCard': ['Card Number', 'Expiry Date', 'CVV'],
    'Bank Card': ['Card Number', 'Expiry Date', 'CVV'],
    'American Express': ['Card Number', 'Expiry Date', 'CVV'],
    'PayPal': ['PayPal Email'],
    'e-Dinars': ['Card Number', 'Expiry Date', 'CVV'],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Select Payment Method',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.payment),
                ),
                value: selectedCard,
                onChanged: (newValue) {
                  setState(() {
                    selectedCard = newValue;
                  });
                },
                items: cardOptions.map((card) {
                  return DropdownMenuItem<String>(
                    value: card['name'],
                    child: Row(
                      children: [
                        Image.asset(card['image'], width: 40, height: 40),
                        SizedBox(width: 10),
                        Text(card['name']),
                      ],
                    ),
                  );
                }).toList(),
                validator: (value) => value == null || value.isEmpty ? 'Please select a payment method' : null,
              ),
              
              SizedBox(height: 20),
              ..._buildFormFields(selectedCard),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Save the payment data to Firestore
      await _savePaymentData();
      // Optionally handle after save, such as showing a confirmation dialog or popping the context
      Navigator.pop(context); // Pop on successful payment
    }
  },
                child: Text('Submit Payment'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _savePaymentData() async {
  final CollectionReference payment = FirebaseFirestore.instance.collection('payment');

  await payment.add({
    'cardNumber': cardNumber,
    'selectedCard': selectedCard,
    'timestamp': FieldValue.serverTimestamp(),
    'idMedecin': widget.idMedecin,
    'idPatient': widget.idPatient,
  });
}


  List<Widget> _buildFormFields(String? selectedCard) {
    if (selectedCard == null || !cardFormFields.containsKey(selectedCard)) {
      return [];
    }
    List<Widget> formFields = [];
    cardFormFields[selectedCard]!.asMap().forEach((index, field) {
      TextInputType keyboardType = TextInputType.text;
      List<TextInputFormatter>? inputFormatters;
      String? Function(String?)? validator;

      switch (field) {
        case 'Card Number':
          keyboardType = TextInputType.number;
          inputFormatters = [FilteringTextInputFormatter.digitsOnly];
          validator = (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your card number';
            } else if (value.length < 13 || value.length > 19) {
              return 'Card number must be between 13 and 19 digits';
            }
            return null;
          };
          break;
        case 'Expiry Date':
          keyboardType = TextInputType.datetime;
          inputFormatters = [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)];
          validator = (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter expiry date';
            } else if (!RegExp(r'^(0[1-9]|1[0-2])\/?([0-9]{2})$').hasMatch(value)) {
              return 'Invalid expiry date';
            }
            return null;
          };
          break;
        case 'CVV':
          keyboardType = TextInputType.number;
          inputFormatters = [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)];
          validator = (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter CVV';
            } else if (value.length < 3 || value.length > 4) {
              return 'CVV must be 3 or 4 digits';
            }
            return null;
          };
          break;
        case 'PayPal Email':
          keyboardType = TextInputType.emailAddress;
          validator = (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter PayPal email';
            } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$').hasMatch(value)) {
              return 'Invalid email format';
            }
            return null;
          };
          break;
      }

      formFields.add(TextFormField(
        decoration: InputDecoration(
          labelText: field,
          border: OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: validator,
        onSaved: (value) {
          switch (field) {
            case 'Card Number':
              cardNumber = value!;
              break;
            case 'Expiry Date':
              expiryDate = value!;
              break;
            case 'CVV':
              cvv = value!;
              break;
            case 'PayPal Email':
              // Save PayPal email if necessary
              break;
          }
        },
      ));

      // Add a SizedBox widget after each TextFormField, except for the last one
      if (index < cardFormFields[selectedCard]!.length - 1) {
        formFields.add(SizedBox(height: 20));
      }
    });
    return formFields;
  }
}
