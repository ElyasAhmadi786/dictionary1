import 'package:flutter/material.dart';
import 'package:share/share.dart';

class ShareScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.cyanAccent,
        title: Text('Share'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Share.share('Check out this cool dictionary app!');
          },
          child: Text('Share'),
        ),
      ),
    );
  }
}