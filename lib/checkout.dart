import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'thankyou.dart';
import 'app_bar.dart';
import 'cartItem.dart';

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();

  String _fullName = '';
  String _addressLine = '';
  String _city = '';
  String _state = '';
  String _postalCode = '';
  String _cardNumber = '';
  String _expiryDate = '';
  String _cvv = '';


// List of Canadian provinces for the dropdown
  final List<String> _provinces = [
    'Alberta',
    'British Columbia',
    'Manitoba',
    'New Brunswick',
    'Newfoundland and Labrador',
    'Nova Scotia',
    'Ontario',
    'Prince Edward Island',
    'Quebec',
    'Saskatchewan',
  ];

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartModel>(context);

    return Scaffold(
      appBar: MyAppBar(),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              // Full Name Field
              TextFormField(
                decoration: InputDecoration(labelText: 'Full Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _fullName = value!;
                },
              ),
              SizedBox(height: 50),

              // Shipping Address Category
              Text('Shipping Address', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(labelText: 'Address Line'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
                onSaved: (value) {
                  _addressLine = value!;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(labelText: 'City'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your city';
                  }
                  return null;
                },
                onSaved: (value) {
                  _city = value!;
                },
              ),
              SizedBox(height: 10),

              // Dropdown for Province Selection
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Province'),
                value: _state.isNotEmpty ? _state : null,
                items: _provinces.map((String province) {
                  return DropdownMenuItem<String>(
                    value: province,
                    child: Text(province),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _state = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your province';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),

              TextFormField(
                decoration: InputDecoration(labelText: 'Postal Code'),
                validator: (value) {
                  if (value == null || value.isEmpty || !RegExp(r'^[A-Za-z]\d[A-Za-z][ -]?\d[A-Za-z]\d$').hasMatch(value)) {
                    return 'Please enter a valid Canadian postal code';
                  }
                  return null;
                },
                onSaved: (value) {
                  _postalCode = value!;
                },
              ),
              SizedBox(height: 50),

              // Payment Details Category
              Text('Payment Details', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(labelText: 'Card Number'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty || value.length != 16) {
                    return 'Please enter a valid 16-digit card number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _cardNumber = value!;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(labelText: 'Expiry Date (MMYY)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty || !RegExp(r'^\d{4}$').hasMatch(value)) {
                    return 'Please enter a valid expiry date (MMYY)';
                  }
                  return null;
                },
                onSaved: (value) {
                  _expiryDate = value!;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(labelText: 'CVV'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty || value.length != 3) {
                    return 'Please enter a valid 3-digit CVV number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _cvv = value!;
                },
              ),
              SizedBox(height: 40),

              // Submit Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    cart.clearCart(); // Clear the cart items
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ThankYouPage()),
                    );
                  }
                },
                child: Text('Submit Order'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Background color
                  foregroundColor: Colors.white, // Text color
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}