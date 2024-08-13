import 'package:flutter/material.dart';
import 'productDetail.dart';
import 'app_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProductsScreen(),
      theme: ThemeData(
        primaryColor: Color(0xFF11823B),
      ),
    );
  }
}

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(),
      body: ListView(
        children: [
          // Flyer Image Slider
          Container(
            height: 300,
            child: PageView(
              children: [
                Image.asset('assets/flyers/fruit.png', fit: BoxFit.cover),
                Image.asset('assets/flyers/juice.png', fit: BoxFit.cover),
                Image.asset('assets/flyers/vegetable.png', fit: BoxFit.cover),
              ],
            ),
          ),
          SizedBox(height: 20),

          // Vegetables Section
          SectionTitle(title: 'Fresh from the farm veggies'),
          SizedBox(
            height: 230, // Increased height to accommodate description and price
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                ProductCard(
                  image: 'assets/images/veggies/carrot.jpeg',
                  name: 'Carrots',
                  description: 'Sweet and crunchy, our carrots are a versatile vegetable that can be enjoyed raw, cooked, or juiced. Packed with beta-carotene and fiber, they\'re a nutritious addition to salads, soups, and snacks.',
                  price: 2.99,
                ),
                ProductCard(
                  image: 'assets/images/veggies/tomato.jpeg',
                  name: 'Tomatoes',
                  description: 'Juicy and flavorful, our tomatoes are a kitchen staple. Whether eaten fresh in salads, roasted in sauces, or cooked in soups and stews, they\'re a versatile ingredient that adds depth and acidity to dishes.',
                  price: 3.49,
                ),
                ProductCard(
                  image: 'assets/images/veggies/brocolli.jpeg',
                  name: 'Broccoli',
                  description: 'Crisp and nutritious, our broccoli is a staple superfood. Packed with vitamins and antioxidants, it\'s perfect for steaming, roasting, or stir-frying to create healthy and delicious meals.',
                  price: 1.99,
                ),
                ProductCard(
                  image: 'assets/images/veggies/beans.jpeg',
                  name: 'Beans',
                  description: 'Tender and flavorful, our beans are a versatile addition to any meal. Packed with nutrients and fiber, they\'re perfect for soups, stir-fries, and salads.',
                  price: 2.99,
                )
              ],
            ),
          ),
          SizedBox(height: 20),

          // Fruits Section
          SectionTitle(title: 'Fresh juicy fruits'),
          SizedBox(
            height: 230, // Increased height to accommodate description and price
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                ProductCard(
                  image: 'assets/images/fruits/apple.jpeg',
                  name: 'Apples',
                  description: 'Crisp and juicy, our apples are handpicked for their sweet flavor and refreshing crunch. Perfect for snacking on-the-go or adding a healthy twist to your favorite recipes.',
                  price: 4.99,
                ),
                ProductCard(
                  image: 'assets/images/fruits/banana.png',
                  name: 'Bananas',
                  description: 'Naturally sweet and creamy, our bananas are a nutrient-packed powerhouse. Whether enjoyed solo, blended into smoothies, or sliced over cereal, they\'re a delicious and convenient way to boost your energy.',
                  price: 1.99,
                ),
                ProductCard(
                  image: 'assets/images/fruits/grapes.jpeg',
                  name: 'Grapes',
                  description: 'Bursting with flavor, our grapes are a delightful treat for any occasion. Whether enjoyed fresh as a snack, frozen for a refreshing treat, or added to salads and desserts, they\'re a versatile fruit that\'s as delicious as it is nutritious.',
                  price: 2.99,
                ),
                ProductCard(
                  image: 'assets/images/fruits/raspberry.jpeg',
                  name: 'Raspberry',
                  description: 'Tart and tangy, our raspberries are bursting with flavor and vibrant color. Whether enjoyed fresh, blended into smoothies, or added to desserts and baked goods, they\'re a versatile fruit that adds a bold and refreshing twist to any recipe.',
                  price: 8.76,
                )
              ],
            ),
          ),
          SizedBox(height: 20),

          // Dairy Section
          SectionTitle(title: 'Fresh dairy products'),
          SizedBox(
            height: 230, // Increased height to accommodate description and price
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                ProductCard(
                  image: 'assets/images/dairy/icecream.jpg',
                  name: 'Icecream',
                  description: 'Chapman\'s premium made in Canada from domestic and imported ingredients French Vanilla Ice Cream.',
                  price: 9.49,
                ),
                ProductCard(
                  image: 'assets/images/dairy/paneer.jpeg',
                  name: 'Paneer',
                  description: 'Mother Dairy Paneer is a high-quality, fresh dairy product made from 100% pure cow\'s milk. It has a firm texture and a slightly sweet taste, making it a versatile addition to any dish. It is rich in protein, calcium, and other essential vitamins and minerals. It can be used to make delicious curries, paneer tikkas, sandwiches, and more.',
                  price: 5.99,
                ),
                ProductCard(
                  image: 'assets/images/dairy/yogurt.jpg',
                  name: 'Yogurt',
                  description: 'Yoplait (a brand of General Mills, Minneapolis) introduced a new Greek yogurt line called Plenti. The yogurt is made with fruit, seeds (flax and pumpkin) and whole grains',
                  price: 3.49,
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String image;
  final String name;
  final String description;
  final double price;

  ProductCard({
    required this.image,
    required this.name,
    required this.description,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate to ProductDetail screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetail(
              image: image,
              name: name,
              description: description,
              price: price,
            ),
          ),
        );
      },
      child: Container(
        width: 150,
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Material(
          elevation: 4.0, // Elevation for shadow effect
          borderRadius: BorderRadius.circular(12.0), // Rounded corners
          color: Color(0xFFF5F5F5), // Background color
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 0.9), // Black border
              borderRadius: BorderRadius.circular(12.0),
            ),
            padding: const EdgeInsets.all(8.0), // Padding inside the card
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0), // Rounded corners for image
                    child: Image.asset(image, fit: BoxFit.cover),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}