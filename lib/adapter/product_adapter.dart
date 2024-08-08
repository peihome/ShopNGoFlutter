import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shopngoflutter/dataclass/product.dart';

class ProductAdapter extends StatelessWidget {
  final List<Product> productList;
  final Function(int position, List<Product> productList, String type)? onItemClickListener;

  ProductAdapter({
    required this.productList,
    this.onItemClickListener,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: productList.length,
      itemBuilder: (context, position) {
        final product = productList[position];
        return _buildProductItem(context, product, position);
      },
    );
  }

  Widget _buildProductItem(BuildContext context, Product product, int position) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Column(
        children: [
          ListTile(
            leading: FutureBuilder<String>(
              future: _getImageUrl(product.fetchImage()),
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
            title: Text(product.fetchTitle()),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("\$${product.fetchPrice()} /lb"),
                Text(product.fetchDescription()),
              ],
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () => onItemClickListener?.call(position, productList, 'reduceQuantity'),
              ),
              Text("${product.fetchQuantity()}"),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => onItemClickListener?.call(position, productList, 'increaseQuantity'),
              ),
              ElevatedButton(
                onPressed: () => onItemClickListener?.call(position, productList, 'addButton'),
                child: Text('Add'),
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