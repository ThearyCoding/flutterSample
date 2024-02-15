import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_image/Provider_Cart.dart';
import 'package:store_image/model/product.dart';

class CartItemList extends StatelessWidget {
  final CartController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    controller.loadData();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_circle_left_outlined,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "My Cart",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Obx(
        () => Visibility(
          visible: controller.products.isNotEmpty,
          replacement: const Center(
            child: Text('Your cart is empty'),
          ),
          child: SizedBox(
            height: 600,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: controller.products.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: CartProductCard(
                    controller: controller,
                    product: controller.products.keys.toList()[index],
                    quantity: controller.products.values.toList()[index],
                    index: index,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class CartProductCard extends StatelessWidget {
  final CartController controller;
  final Product product;
  final int quantity;
  final int index;

  CartProductCard({
    required this.controller,
    required this.product,
    required this.quantity,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CachedNetworkImage(
          imageUrl: product.imageUrls[1],
          imageBuilder: (context, imageProvider) => Container(
            width: 80.0,
            height: 80.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Flexible(
          child: Text(
            "${product.name}",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(width: 80),
        IconButton(
            onPressed: () {
              controller.addProduct(product);
            },
            icon: Icon(Icons.add_circle)),
        Text("${quantity}"),
        IconButton(
            onPressed: () {
              controller.removeProduct(product);
            },
            icon: Icon(Icons.remove_circle)),
      ],
    );
  }
}
