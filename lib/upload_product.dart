import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:store_image/model/product.dart';

class UploadProduct extends StatefulWidget {
  final PanelController panecontroller;
  const UploadProduct({super.key, required this.panecontroller});

  @override
  State<UploadProduct> createState() => _UploadProductState();
}

class _UploadProductState extends State<UploadProduct> {
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('users');
  final picker = ImagePicker();

  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController descriptionController;

  String? imagePath;
  File? imageFile;
  String imageUrl = '';
  List<String> imageUrlsList = [];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    priceController = TextEditingController();
    descriptionController = TextEditingController();
  }

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path;
        imageFile = File(imagePath!);
        // Add the image URL to the list

        imageUrlsList.add(imagePath!);
      });
    }
  }

  Future<void> showImageSourceDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose Image Source'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text('Camera'),
                  onTap: () {
                    Navigator.pop(context);
                    pickImage(ImageSource.camera);
                  },
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Text('Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  // ... (existing code)

  Future<void> uploadDataAndImage() async {
    if (imageUrlsList.isEmpty) {
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
       DateTime dateTime = DateTime.now();
      String formattedDate = DateFormat('MMM/dd/yyyy').format(dateTime);
      final Product product = Product(
        name: nameController.text,
        price: double.parse(priceController.text),
        description: descriptionController.text,
        imageUrls: imageUrlsList, dateTime: formattedDate,
      );

      // Upload each image in the list
      List<String> uploadedImageUrls = [];
      for (String imagePath in imageUrlsList) {
        final TaskSnapshot uploadTask = await FirebaseStorage.instance
            .ref(
                'Product_images/${product.name}_${DateTime.now().millisecondsSinceEpoch}.jpg')
            .putFile(File(imagePath));

        uploadedImageUrls.add(await uploadTask.ref.getDownloadURL());
      }
     
      // Save Product data to Cloud Firestore with the list of image URLs
      await _collectionRef.add({
        'name': product.name,
        'price': product.price,
        'description': product.description,
        'imageUrls': uploadedImageUrls,
        'datetime': formattedDate,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data and Images uploaded successfully!'),
        ),
      );
    } catch (e) {
      print('Error uploading data and images: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error uploading data and images'),
        ),
      );
    } finally {
      priceController.clear();
      descriptionController.clear();
      nameController.clear();
      setState(() {
        imagePath = null;
        imageFile = null;
        imageUrlsList.clear();
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        widget.panecontroller.close();
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  const Text(
                    "New Product",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  ),
                  TextButton(
                      onPressed: () {
                        uploadDataAndImage();
                      },
                      child: const Text(
                        "Post",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ],
              ),
              const Divider(
                thickness: 1,
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: imageUrlsList.length + 1,
                itemBuilder: (context, index) {
                  return index == 0
                      ? Center(
                          child: IconButton(
                            onPressed: () {
                              showImageSourceDialog();
                            },
                            icon: Icon(Icons.add),
                          ),
                        )
                      : Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            image: DecorationImage(
                              image: FileImage(File(imageUrlsList[index - 1])),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                },
              ),
              TextFormField(
                minLines: 1,
                maxLines: 12,
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
              ),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: descriptionController,
                minLines: 1,
                maxLines: 12,
                maxLength: 2500,
                decoration: InputDecoration(
                  hintText: "description",
                  fillColor: Colors.grey[200],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
