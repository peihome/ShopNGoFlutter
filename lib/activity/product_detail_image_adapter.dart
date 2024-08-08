import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductDetailImageAdapter extends StatelessWidget {
  final List<String?> productImages;

  ProductDetailImageAdapter({required this.productImages});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: productImages.length,
      itemBuilder: (context, index) {
        return FutureBuilder<String>(
          future: _getDownloadUrl(productImages[index]!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error loading image');
            } else if (!snapshot.hasData) {
              return Text('No image available');
            } else {
              return CachedNetworkImage(
                imageUrl: snapshot.data!,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              );
            }
          },
        );
      },
    );
  }

  Future<String> _getDownloadUrl(String imagePath) async {
    try {
      final ref = FirebaseStorage.instance.ref().child(imagePath);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Failed to load image from Firebase Storage: $e');
      throw e;
    }
  }
}