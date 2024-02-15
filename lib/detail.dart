import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DetailProduct extends StatelessWidget {
  final Map productDetails;

  DetailProduct(this.productDetails);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(productDetails['name']),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CachedNetworkImage(
              imageUrl: productDetails['imageUrl'],
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Icon(Icons.error),
              width: double.infinity,
              height: 200.0,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productDetails['name'],
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    '\$${productDetails['price'].toString()}',
                    style: const TextStyle(color: Colors.green),
                  ),
                  // Add more details as needed
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
