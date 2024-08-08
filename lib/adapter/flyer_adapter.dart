import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shopngoflutter/dataclass/flyer.dart';


class FlyerAdapter extends StatelessWidget {
  final List<Flyer> flyersList;

  FlyerAdapter({required this.flyersList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: flyersList.length,
      itemBuilder: (context, position) {
        final flyer = flyersList[position];
        return _buildFlyerItem(context, flyer);
      },
    );
  }

  Widget _buildFlyerItem(BuildContext context, Flyer flyer) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Column(
        children: [
          ListTile(
            title: FutureBuilder<String>(
              future: _getImageUrl(flyer.fetchImage()),
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