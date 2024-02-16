class Product {
  final String? name;
  final double? price;
  final String? description;
  final String? dateTime;
  final dynamic quantity;
  final List<String>? imageUrls;

  Product({
    this.name,
    this.price,
    this.description,
    this.dateTime,
    this.imageUrls,
    this.quantity,
  });
  factory Product.fromJson(Map<String, dynamic> json) {
    try {
      return Product(
        name: json['name'],
        quantity: json['quantity'],
        price: double.parse(
            json['price'].toString()), // Ensure 'price' is a valid number
        description: json['description'],
        dateTime: json['dateTime'],
        imageUrls: List<String>.from(json['imageUrls'] ?? []),
      );
    } catch (e) {
      // Handle the error, for example, set a default value or log the issue
      print("Error parsing 'price' attribute: $e");
      return Product(
        name: json['name'],
        quantity: json['quantity'],
        price: 0.0, // Set a default value or handle the error accordingly
        description: json['description'],
        dateTime: json['dateTime'],
        imageUrls: List<String>.from(json['imageUrls'] ?? []),
      );
    }
  }

  Product.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        price = map['price'],
        quantity = map['quantity'],
        description = map['description'],
        dateTime = map['dateTime'],
        imageUrls = List<String>.from(map['imageUrls'] ?? []);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'description': description,
      'quantity': quantity,
      'dateTime': dateTime,
      'imageUrls': imageUrls,
    };
  }

  // Convert Product to Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'imageUrls': imageUrls,
      'description': description,
      // 'datetime': datetime,
    };
  }
}
