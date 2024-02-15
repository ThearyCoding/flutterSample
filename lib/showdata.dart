import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:store_image/allProduct.dart';
import 'package:store_image/carouselSlider.dart';
import 'package:store_image/cartItem.dart';
import 'package:store_image/detailProduct.dart';
import 'package:store_image/model/product.dart';

class Showdata extends StatelessWidget {
   Showdata({super.key});

   List<Product> _convertToProductList(List<QueryDocumentSnapshot> documents) {
    return documents.map((doc) {
      final userData = doc.data() as Map<String, dynamic>;

      return Product(
        name: userData['name'],
        price: userData['price'].toDouble(),
        imageUrls: (userData['imageUrls'] as List<dynamic>)
            .map((imageUrl) => imageUrl.toString())
            .toList(), description: userData['description'].toString(), dateTime: userData['datetime'],
      );
    }).toList();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        return await FirebaseFirestore.instance
            .collection('info')
            .doc(currentUser.email)
            .get();
      } else {
        throw FirebaseAuthException(
          code: 'user-not-authenticated',
          message: 'User is not authenticated',
        );
      }
    } catch (e) {
      print("Error fetching user details: $e");
      throw e;
    }
  }

  // ignore: non_constant_identifier_names
  final CollectionReference _collectionCart =
      FirebaseFirestore.instance.collection('cart');

  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        future: getUserDetails(),
                        builder: ((context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(
                              child: Text("Loading..."),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text("Has error: ${snapshot.error}"),
                            );
                          }
                          Map<String, dynamic>? datauser = snapshot.data!.data();
                          return Row(
                            children: [
                              const Text(
                                "Hello.",
                                style: TextStyle(color: Colors.black,fontSize: 17),
                              ),
                              Text(" ${datauser!['lastname']}!", style: TextStyle(color: Colors.black,fontSize: 17),)
                            ],
                          );
                        })),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _collectionCart.snapshots(),
                        builder: (context, snapshot) {
                          int itemCount =
                              snapshot.hasData ? snapshot.data!.docs.length : 0;
                
                          return Badge(
                            label: Text(itemCount.toString()),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return CartItemList();
                                }));
                              },
                              child: const Icon(
                                Icons.shopping_bag_outlined,
                                color: Colors.black,
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
              const CarouselSliderWithTitles(),
              Container(
                margin: const EdgeInsets.only(left: 12, right: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "New Products",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const allProduct();
                        }));
                      },
                      child: const Text(
                        "See more",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue),
                      ),
                    )
                  ],
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: _collectionRef.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
      
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
      
                  final List<QueryDocumentSnapshot> documents =
                      snapshot.data!.docs;
      
                  return SizedBox(
                    height: 400.0,
                    child: documents.isEmpty
                        ? const Center(
                            child: Text(
                              'No data yet!',
                              style: TextStyle(fontSize: 18),
                            ),
                          )
                        : ListView.builder(
                            itemCount: documents.length,
                            itemBuilder: (context, index) {
                              final Map<String, dynamic> userData =
                                  documents[index].data() as Map<String, dynamic>;
      final product = _convertToProductList(documents)[index];
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailApp(
                                        product,
                                      ),
                                    ),
                                  );
                                },
                                child: SizedBox(
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height / 2.2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Card(
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15)),
                                      ),
                                      color: Colors.white,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CarouselSlider(
                                            options: CarouselOptions(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  3.3,
                                              enlargeCenterPage: true,
                                              autoPlay: true,
                                              autoPlayCurve: Curves.fastOutSlowIn,
                                              enableInfiniteScroll: true,
                                              autoPlayAnimationDuration:
                                                  Duration(milliseconds: 800),
                                              viewportFraction: 1.0,
                                            ),
                                            items: (userData['imageUrls']
                                                    as List<dynamic>)
                                                .map((imageUrl) => ClipRRect(
                                                      borderRadius:
                                                          const BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(15),
                                                        topRight:
                                                            Radius.circular(15),
                                                      ),
                                                      child: CachedNetworkImage(
                                                        imageUrl: imageUrl,
                                                        placeholder: (context,
                                                                url) =>
                                                            const Center(
                                                                child:
                                                                    CircularProgressIndicator()),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Icon(Icons.error),
                                                        width: double.infinity,
                                                        height:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .height /
                                                                3.3,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ))
                                                .toList(),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 10),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  userData['name'],
                                                  style: const TextStyle(
                                                      fontSize: 18),
                                                ),
                                                Text(
                                                  '\$${userData['price'].toString()}',
                                                  style: const TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 18),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
