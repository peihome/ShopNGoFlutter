import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CardActivity extends StatefulWidget {
  @override
  _CardActivityState createState() => _CardActivityState();
}

class _CardActivityState extends State<CardActivity> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  late String holderName, cardNumber, expiryDate, cvv, userId;

  @override
  void initState() {
    super.initState();
    userId = _auth.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Card Page'),
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            Navigator.pushNamed(context, '/home');
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Holder Name'),
                onSaved: (value) => holderName = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Card Number'),
                onSaved: (value) => cardNumber = value!,
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Expiry Date'),
                onSaved: (value) => expiryDate = value!,
                keyboardType: TextInputType.datetime,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'CVV'),
                onSaved: (value) => cvv = value!,
                keyboardType: TextInputType.number,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState?.save();
                        // Add the card details to the database
                        // Navigate to ConfirmOrderActivity
                      }
                    },
                    child: Text('Continue'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/home');
                    },
                    child: Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}