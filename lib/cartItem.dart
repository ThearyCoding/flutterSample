import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_image/Provider_Cart.dart';

class CartItemList extends StatelessWidget {
  final CartController controller = Get.find();

  CartItemList({super.key});

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
          visible: controller.products.values.toList().isNotEmpty,
          replacement: const Center(
            child: Text('Your cart is empty'),
          ),
          child: SizedBox(
            height: 600,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: controller.products.values.toList().length,
              itemBuilder: (context, index) {
                var model = controller.products.values.toList()[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: CartProductCard(
                    controller: controller,
                    product: model,
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
  final dynamic product;
  final int index;

  const CartProductCard({
    super.key,
    required this.controller,
    required this.product,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CachedNetworkImage(
          imageUrl: product.imageUrls?.isNotEmpty ?? true
              ? product.imageUrls?.first ?? ""
              : "",
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
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Flexible(
          child: Text(
            product.name ?? "",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 80),
        IconButton(
            onPressed: () => controller.addCartProduct(product),
            icon: const Icon(Icons.add_circle)),
        Text("${product.quantity}"),
        IconButton(
            onPressed: () => controller.deleteProduct(product: product),
            icon: const Icon(Icons.remove_circle)),
      ],
    );
  }
}
