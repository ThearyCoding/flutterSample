import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class allProduct extends StatefulWidget {
  const allProduct({Key? key}) : super(key: key);

  @override
  State<allProduct> createState() => _allProductState();
}

class _allProductState extends State<allProduct> {
  CollectionReference<Map<String, dynamic>> _collectionRef =
      FirebaseFirestore.instance.collection('users');

  final List<String> ListCatagory = [
    "App products",
    "Keyboard",
    "Mouse",
    "Computer",
    "MotherBoard",
    "Ram"
  ];
  int selectedCategoryIndex = 0;
  List<Map<String, dynamic>> filteredProducts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Products"),
      ),
      body: Column(
        children: [
          Container(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: ListCatagory.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 100,
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                  ),
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedCategoryIndex = index;
                      });
                    },
                    child: Container(
                      width: double.maxFinite,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selectedCategoryIndex == index
                            ? Colors.blue
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "${ListCatagory[index]}",
                        style: TextStyle(
                          color: selectedCategoryIndex == index
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _collectionRef.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final List<QueryDocumentSnapshot<Map<String, dynamic>>>
                    documents = snapshot.data!.docs;

                return documents.isEmpty
                    ? const Center(
                        child: Text(
                          'No data yet!',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                        ),
                        itemCount: filteredProducts.isNotEmpty
                            ? filteredProducts.length
                            : documents.length,
                        itemBuilder: (context, index) {
                          final cartItem = filteredProducts.isNotEmpty
                              ? filteredProducts[index]
                              : documents[index].data()!;

                          return Container(
                            width: 200,
                            height: 300,
                            margin: const EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                            ),
                            // child: Column(
                            //   children: [
                            //     CachedNetworkImage(
                            //       imageUrl: cartItem['imageUrl'],
                            //       width: 100,
                            //       placeholder: (context, url) => Center(
                            //         child: const CircularProgressIndicator(),
                            //       ),
                            //       errorWidget: (context, url, error) =>
                            //           const Icon(Icons.error),
                            //     ),
                            //   ],
                            // ),
                          );
                        },
                      );
              },
            ),
          ),
        ],
      ),
    );
  }

  
}
