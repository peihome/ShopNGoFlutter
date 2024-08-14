import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_bar.dart';
import 'cartItem.dart';
import 'checkout.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartModel>(context);

    return Scaffold(
      appBar: MyAppBar(),
      backgroundColor: Colors.white,
      body: cart.items.isEmpty
          ? _buildEmptyCartView()
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                return CartItemCard(cartItem: cart.items[index]);
              },
            ),
          ),
          _buildBottomSection(context, cart),
        ],
      ),
    );
  }

  Widget _buildEmptyCartView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/empty_cart.png',
            width: 230,
            height: 230,
          ),
          SizedBox(height: 20),
          Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Add items to your cart to proceed.',
            style: TextStyle(
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context, CartModel cart) {
    double grandTotal = cart.totalPrice;
    int totalItems = cart.totalItems;

    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: Colors.grey.withOpacity(0.3),
            offset: Offset(0, -3),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Grand Total:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('\$${grandTotal.toStringAsFixed(2)}',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green)),
            ],
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: totalItems > 0
                ? () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CheckoutPage()),
              );
            }
                : null, // Disable the button if no items in the cart
            child: Text('Proceed to Checkout ($totalItems items)'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black, // Light gray background color
              foregroundColor: Colors.white, // Text color
              elevation: 0, // Optional: Remove shadow if you want a flat button
              side: BorderSide(color: Colors.black), // Optional: Add border if needed
            ),
          ),
        ],
      ),
    );
  }
}