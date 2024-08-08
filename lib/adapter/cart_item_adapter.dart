import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shopngoflutter/dataclass/product.dart';
import 'package:shopngoflutter/utils/utils.dart';

class CartItemAdapter extends StatelessWidget {
  final List<Product> cartItemsList;
  final bool showQuantityLayout;
  final Function(int position, String type)? onItemClickListener;

  CartItemAdapter({
    required this.cartItemsList,
    this.showQuantityLayout = true,
    this.onItemClickListener,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cartItemsList.length,
      itemBuilder: (context, position) {
        final product = cartItemsList[position];
        return _buildCartItem(context, product, position);
      },
    );
  }

  Widget _buildCartItem(BuildContext context, Product product, int position) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Column(
        children: [
          ListTile(
            leading: FutureBuilder<String>(
              future: _getImageUrl(product.image),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Icon(Icons.error);
                } else {
                  return CachedNetworkImage(
                    imageUrl: snapshot.data ?? '',
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  );
                }
              },
            ),
            title: Text(product.title),
            subtitle: Text("\$${product.price} /lb"),
            trailing: showQuantityLayout
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("${product.quantity}"),
                Text(
                  "\$${Utils.getSubtotalStr(product.quantity, product.price)} (Subtotal)",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            )
                : null,
          ),
          if (showQuantityLayout)
            ButtonBar(
              alignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () => onItemClickListener?.call(position, 'reduceQuantity'),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => onItemClickListener?.call(position, 'increaseQuantity'),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Future<String> _getImageUrl(String imagePath) async {
    try {
      final ref = FirebaseStorage.instance.ref().child(imagePath);
      return await ref.getDownloadURL();
    } catch (e) {
      print("Failed to load image from Firebase Storage: $e");
      return '';
    }
  }
}