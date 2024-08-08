import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartActivity extends StatefulWidget {
  @override
  _CartActivityState createState() => _CartActivityState();
}

class _CartActivityState extends State<CartActivity> {
  final _auth = FirebaseAuth.instance;
  late String userId;
  List<Product> cartItemsList = [];

  @override
  void initState() {
    super.initState();
    userId = _auth.currentUser!.uid;
    // Load cart items
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            Navigator.pushNamed(context, '/home');
          },
        ),
      ),
      body: ListView.builder(
        itemCount: cartItemsList.length,
        itemBuilder: (context, index) {
          final product = cartItemsList[index];
          return ListTile(
            title: Text(product.title),
            subtitle: Text(product.description),
            trailing: Text('\$${product.price}'),
            onTap: () {
              Navigator.pushNamed(context, '/productDetail', arguments: product);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/confirmOrder');
        },
        child: Icon(Icons.payment),
      ),
    );
  }
}

class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String image;

  Product({required this.id, required this.title, required this.description, required this.price, required this.image});
}