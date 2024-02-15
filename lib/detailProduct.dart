import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_image/Provider_Cart.dart';
import 'package:store_image/model/product.dart';

class DetailApp extends StatelessWidget {
  final Product product;

  final CartController cartController = Get.find();

  DetailApp(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        anchor: 0,
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height / 3,
            pinned: true,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.blurBackground,
                StretchMode.zoomBackground,
              ],
              // ignore: unnecessary_null_comparison
              background: product.imageUrls?.isNotEmpty ?? true
                  ? CarouselSlider.builder(
                      options: CarouselOptions(
                        height: MediaQuery.of(context).size.height / 2.2,
                        enlargeCenterPage: true,
                        autoPlay: true,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enableInfiniteScroll: true,
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 800),
                        viewportFraction: 1.0,
                      ),
                      itemCount: product.imageUrls?.length,
                      itemBuilder: (context, index, realIndex) {
                        String imageUrl = product.imageUrls?.isEmpty ?? true
                            ? ""
                            : product.imageUrls?.first ?? "";
                        return CachedNetworkImage(
                          imageUrl: imageUrl,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        );
                      },
                    )
                  : Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            "https://static.vecteezy.com/system/resources/previews/005/337/799/original/icon-image-not-found-free-vector.jpg",
                          ),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
            ),
            leading: Container(
              margin: const EdgeInsets.only(left: 12.0, bottom: 10),
              height: 40.0,
              width: 40.0,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.60),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            leadingWidth: 80.0,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0.0),
              child: Container(
                alignment: Alignment.center,
                height: 32.0,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(32.0),
                    topLeft: Radius.circular(32.0),
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: 40.0,
                  height: 5.0,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            product.name ?? "",
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        width: 100,
                        height: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade500.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(12)),
                        child: Text(
                          '\$${product.price}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Text(
                    'Description:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(16),
                  height: 193.0,
                  child: SingleChildScrollView(
                    child: Text(
                      product.description ?? 'No description available',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 16.0, top: 5),
                  child: Text("Size"),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, top: 6, right: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.brown.shade800,
                        ),
                        width: 100.0,
                        height: 30.0,
                        child: const Text(
                          "S: 34-36",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.brown.shade800,
                        ),
                        width: 100.0,
                        height: 30.0,
                        child: const Text(
                          "M: 38-40",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.brown.shade800,
                        ),
                        width: 100.0,
                        height: 30.0,
                        child: const Text(
                          "L: 42-44",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 16.0, right: 16.0, top: 10),
                  decoration: const BoxDecoration(),
                  child: Text("Post Date : ${product.dateTime}"),
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    cartController.addCartProduct(product);
                    Get.snackbar(
                        "Added to Cart", "${product.name} added to your cart",
                        snackPosition: SnackPosition.BOTTOM);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 50.0,
                    margin:
                        const EdgeInsets.only(left: 16.0, right: 16.0, top: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.brown.shade800,
                    ),
                    child: const Text(
                      "Add to Cart",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
