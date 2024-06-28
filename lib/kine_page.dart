import 'package:flutter/material.dart';

class KinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page du Centre de Kiné'),
      ),
      body: Center(
        child: Text('Contenu de la page du Centre de Kiné'),
      ),
    );
  }
}
