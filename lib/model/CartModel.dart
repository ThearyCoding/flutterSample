class Cart {
  final String name;
  final double price;
  final String description;
  final String dateTime;
  final List<String> imageUrls;

  Cart({
    required this.name,
    required this.price,
    required this.description,
    required this.dateTime,
    required this.imageUrls,
  });
 factory Cart.fromJson(Map<String, dynamic> json) {
  try {
    return Cart(
      name: json['name'],
      price: double.parse(json['price'].toString()), // Ensure 'price' is a valid number
      description: json['description'],
      dateTime: json['dateTime'],
      imageUrls: List<String>.from(json['imageUrls']),
    );
  } catch (e) {
    // Handle the error, for example, set a default value or log the issue
    print("Error parsing 'price' attribute: $e");
    return Cart(
      name: json['name'],
      price: 0.0, // Set a default value or handle the error accordingly
      description: json['description'],
      dateTime: json['dateTime'],
      imageUrls: List<String>.from(json['imageUrls']),
    );
  }
}


  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'description': description,
      'dateTime': dateTime,
      'imageUrls': imageUrls,
    };
  }

  Cart.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        price = map['price'],
        description = map['description'],
        dateTime = map['dateTime'],
        imageUrls = List<String>.from(map['imageUrls']);


          // Convert Cart to Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'imageUrls': imageUrls,
      'description': description,
      'datetime': dateTime,
    };
  }
}


