import 'package:flutter/material.dart';

class ConfirmOrderActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm Order'),
      ),
      body: Center(
        child: Text('Order Confirmed!'),
      ),
    );
  }
}