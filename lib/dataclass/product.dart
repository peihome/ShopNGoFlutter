class Product {
  String id;
  String image;
  String title;
  String description;
  double price;
  String? path;
  int quantity;

  Product({
    required this.id,
    required this.image,
    required this.title,
    required this.description,
    required this.price,
    this.path,
    this.quantity = 0,
  });

  String fetchId() {
    return id;
  }

  String fetchImage() {
    return image;
  }

  double fetchPrice() {
    return price;
  }

  int fetchQuantity() {
    return quantity;
  }

  String fetchTitle() {
    return title;
  }

  String fetchDescription() {
    return description;
  }
}