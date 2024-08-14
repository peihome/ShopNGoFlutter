import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cartItem.dart';
import 'app_bar.dart';

class ProductDetail extends StatefulWidget {
  final String image;
  final String name;
  final String description;
  final double price;

  ProductDetail({
    required this.image,
    required this.name,
    required this.description,
    required this.price,
  });

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int _quantity = 1;

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    setState(() {
      if (_quantity > 1) {
        _quantity--;
      }
    });
  }

  String _truncateDescription(String description, int maxLength) {
    if (description.length <= maxLength) {
      return description;
    } else {
      return description.substring(0, maxLength) + '...';
    }
  }

  @override
  Widget build(BuildContext context) {
    const int maxLength = 1000;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_outlined),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(16.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: Colors.grey, width: 0.9),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Now: \$${widget.price.toStringAsFixed(2)} /lb',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Image.asset(
                          widget.image,
                          width: 700,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        _truncateDescription(widget.description, maxLength),
                        style: TextStyle(fontSize: 16),
                      ),
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: _decrementQuantity,
                              color: Colors.black,
                            ),
                            Container(
                              width: 50,
                              height: 40,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _quantity = int.tryParse(value) ?? 1;
                                  });
                                },
                                controller: TextEditingController(text: _quantity.toString()),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: _incrementQuantity,
                              color: Colors.black,
                            ),
                            SizedBox(width: 20),
                            ElevatedButton(
                              onPressed: () {
                                final cartItem = CartItem(
                                  name: widget.name,
                                  price: widget.price,
                                  quantity: _quantity,
                                  imageUrl: widget.image,
                                );

                                Provider.of<CartModel>(context, listen: false).addItem(cartItem);

                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text('${widget.name} added to cart with quantity $_quantity'),
                                ));
                              },
                              child: Text('Add to Cart'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}