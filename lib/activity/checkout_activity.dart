import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckoutActivity extends StatefulWidget {
  @override
  _CheckoutActivityState createState() => _CheckoutActivityState();
}

class _CheckoutActivityState extends State<CheckoutActivity> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  late String userId;
  late String firstName, lastName, streetAddress;

  @override
  void initState() {
    super.initState();
    userId = _auth.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
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
                decoration: InputDecoration(labelText: 'First Name'),
                onSaved: (value) => firstName = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Last Name'),
                onSaved: (value) => lastName = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Street Address'),
                onSaved: (value) => streetAddress = value!,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState?.save();
                    // Process the checkout
                  }
                },
                child: Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}