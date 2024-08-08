import 'package:flutter/material.dart';

class EmptyCartActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Empty Cart'),
      ),
      body: Center(
        child: Text('Your cart is empty!'),
      ),
    );
  }
}