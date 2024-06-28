import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReclamationsPage extends StatelessWidget {
  final TextEditingController _reclamationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple, // Improved color scheme
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'We value your feedback',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple, // Coordinated text color
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _reclamationController,
              decoration: InputDecoration(
                labelText: 'Your feedback',
                hintText: 'Tell us what we can improve',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepPurple), // Matching focus border color
                ),
              ),
              maxLines: 5, // Set a fixed multiline height
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => submitFeedback(context),
              child: Text('Submit'),
              style: ElevatedButton.styleFrom(
         backgroundColor: Colors.deepPurple, 
             foregroundColor: Colors.white, // Set text color to white
// Updated color property
                padding: EdgeInsets.symmetric(vertical: 15.0), // Better padding for button
              ),
            ),
          ],
        ),
      ),
    );
  }

  void submitFeedback(BuildContext context) {
    String feedbackText = _reclamationController.text.trim();
    if (feedbackText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your feedback')),
      );
    } else if (feedbackText.length > 200) {
      showWarningMessage(context);
    } else {
      saveFeedback(context, feedbackText);
    }
  }

  void saveFeedback(BuildContext context, String feedbackText) {
    FirebaseFirestore.instance.collection('reclamations').add({
      'feedback': feedbackText,
      'timestamp': FieldValue.serverTimestamp(),
    }).then((value) => showSuccessMessage(context))
      .catchError((error) => showErrorMessage(context));
  }

  void showWarningMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Warning'),
        content: Text('Feedback cannot exceed 200 characters.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void showSuccessMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Feedback Submitted'),
        content: Text('Thank you for your feedback!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Closes the dialog
              Navigator.pop(context); // Returns to the previous screen
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void showErrorMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text('Failed to submit feedback. Please try again later.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
