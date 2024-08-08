import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductDetailActivity extends StatefulWidget {
  @override
  _ProductDetailActivityState createState() => _ProductDetailActivityState();
}

class _ProductDetailActivityState extends State<ProductDetailActivity> {
  final _auth = FirebaseAuth.instance;
  late String userId;
  late String title, description, productId;
  late double price;
  late String image;
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    userId = _auth.currentUser?.uid ?? '';
    final args = ModalRoute.of(context)?.settings.arguments as Map;
    title = args['title'];
    description = args['description'];
    price = args['price'];
    productId = args['id'];
    image = args['image'];
  }

  void openCartPage() {
    Navigator.pushNamed(context, '/cart');
  }

  void handleQuantityChange(String type) {
    setState(() {
      if (type == "addButton") {
        quantity = 1;
      } else if (type == "increaseQuantity") {
        quantity++;
      } else if (type == "reduceQuantity" && quantity > 1) {
        quantity--;
      }

      if (quantity > 20) {
        quantity = 20;
        Fluttertoast.showToast(msg: "Reached maximum limit!");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Detail'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: openCartPage,
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(description),
            Text("Now: \$${price.toStringAsFixed(2)} /lb"),
            Image.network(image),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    handleQuantityChange("addButton");
                  },
                  child: Text('Add to Cart'),
                ),
                SizedBox(width: 10),
                Visibility(
                  visible: quantity > 1,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          handleQuantityChange("reduceQuantity");
                        },
                      ),
                      Text(quantity.toString(), style: TextStyle(fontSize: 18)),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          handleQuantityChange("increaseQuantity");
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Utils {
  static void handleMenuClick(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  static void addHomeIconNavigation(BuildContext context) {
    Navigator.pop(context);
  }

  static void getMapDataFromRealTimeDataBase(String path, OnGetDataListener listener) {
    // Simulate a database call
    listener.onSuccess({"exampleProductId": 2});
  }

  static void setProductQuantityForUser(String userId, String productId, bool isIncrease, Object object) {
    // Simulate setting product quantity for user
  }
}

abstract class OnGetDataListener {
  void onSuccess(Map<String, dynamic> dataMap);
  void onFailure(Exception e);
}