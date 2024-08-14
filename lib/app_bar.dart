import 'package:flutter/material.dart';
import 'products.dart';
import 'cartPage.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.home,
          color: Colors.white, // Set the home icon color to white
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProductsScreen()), // Adjust the route as needed
          );
        },
      ),
      title: Text(
        'shopNGo',
        style: TextStyle(
          fontSize: 24.0, // Equivalent to 24dp
          fontWeight: FontWeight.bold, // Equivalent to bold
          fontStyle: FontStyle.italic, // Equivalent to italic
          color: Colors.white, // Equivalent to @color/white
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.black,
      actions: [
        IconButton(
          icon: Icon(Icons.shopping_cart),
          color: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CartPage()), // Adjust the route as needed
            );
          },
        ),
      ],
    );
  }
}