import 'package:flutter/material.dart';

class ThankyouActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thank You'),
      ),
      body: Center(
        child: Text('Thank you for your order!'),
      ),
    );
  }
}