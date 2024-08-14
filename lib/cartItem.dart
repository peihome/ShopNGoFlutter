import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartItem {
  String name;
  double price;
  int quantity;
  String imageUrl;

  CartItem(
      {required this.name,
        required this.price,
        required this.quantity,
        required this.imageUrl});
}

class CartModel extends ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double get totalPrice => _items.fold(
      0.0, (sum, item) => sum + item.price * item.quantity);

  int get totalItems => _items.fold(0, (sum, item) => sum + item.quantity);

  void addItem(CartItem item) {
    _items.add(item);
    notifyListeners();
  }

  void updateQuantity(CartItem item, int delta) {
    int index = _items.indexOf(item);
    if (index != -1) {
      _items[index].quantity += delta;
      if (_items[index].quantity <= 0) {
        _items.removeAt(index); // Remove item if quantity drops to zero or below
      }
      notifyListeners();
    }
  }

  void removeItem(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}

class CartItemCard extends StatelessWidget {
  final CartItem cartItem;

  CartItemCard({required this.cartItem});

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartModel>(context, listen: false);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12.0), // Rounded corners
        border: Border.all(color: Colors.grey, width: 0.5), // Grey border
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 3), // Shadow position
          ),
        ],
      ),
      child: Card(
        elevation: 0, // Set elevation to 0 to rely on the BoxDecoration shadow
        color: Colors.transparent, // Make the card's background transparent
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), // Match the container's rounded corners
        ),
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: [
              Image.asset(
                cartItem.imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cartItem.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text('\$${cartItem.price.toStringAsFixed(2)}'),
                    SizedBox(height: 5),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Subtotal: ',
                            style: TextStyle(color: Colors.grey),
                          ),
                          TextSpan(
                            text:
                            '\$${(cartItem.price * cartItem.quantity).toStringAsFixed(2)}',
                            style: TextStyle(color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      cart.updateQuantity(cartItem, -1);
                    },
                    icon: Icon(Icons.remove),
                  ),
                  Text(cartItem.quantity.toString()),
                  IconButton(
                    onPressed: () {
                      cart.updateQuantity(cartItem, 1);
                    },
                    icon: Icon(Icons.add),
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