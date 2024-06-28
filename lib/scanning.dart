import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'Doctor_Search_Screen.dart';
import 'userData.dart';

class QRScanScreen extends StatefulWidget {
  @override
  _QRScanScreenState createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  late QRViewController controller;
  String? errorMessage;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    }
    controller.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.red,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text('Barcode Type: ${result!.format}   Data: ${result!.code}')
                  : Text('Scan a code'),
            ),
          ),
          if (errorMessage != null)
            Text(
              errorMessage!,
              style: TextStyle(color: Colors.red),
            ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      _verifyQRCodeData(scanData.code); 
    });
  }

  Future<void> _verifyQRCodeData(String? qrCodeData) async {
    if (qrCodeData == null) return;

    try {
      // Supposez que le code QR contient uniquement l'ID utilisateur
      String userId = qrCodeData;

      UserData userData = UserData(userId: userId);

      _navigateToDoctorSearchScreen(context, userData);

    } catch (e) {
      print("Error verifying QR code data: $e");
      setState(() {
        errorMessage = 'Invalid QR code. Please try again.';
      });
    }
  }

  void _navigateToDoctorSearchScreen(BuildContext context, UserData userData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DoctorSearchScreen(
          userData: userData,
          showNavigationBar: true,
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

