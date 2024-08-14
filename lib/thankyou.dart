import 'package:flutter/material.dart';
import 'package:shopngofluttergroupproject/products.dart';
import 'dart:async';
import 'main.dart';
import 'app_bar.dart';

class ThankYouPage extends StatefulWidget {
  @override
  _ThankYouPageState createState() => _ThankYouPageState();
}

class _ThankYouPageState extends State<ThankYouPage> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 100,
              ),
              SizedBox(height: 20),
              AnimatedOpacity(
                opacity: _opacity,
                duration: Duration(seconds: 2),
                child: Text(
                  'Thank You for Your Order!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Your order has been placed successfully. We appreciate your business!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  // Navigate back to home or any other screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProductsScreen()),
                  );
                },
                child: Text('Continue Shopping'),
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