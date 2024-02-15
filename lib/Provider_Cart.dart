import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:store_image/model/product.dart';

class CartController extends GetxController {
  var _products = <String, Product>{}.obs;
  final _box = GetStorage(); // Initialize GetStorage
  final _productCart = "product_cart";

  get count => _products.length;

  Map<String, Product> get products => _products;

  // get productSubTotal => _products.entries
  //     .map((product) => product.key.price * product.value)
  //     .toList();
  addCartProduct(Product cartProduct) {
    if (_products.containsKey(cartProduct.name)) {
      _products.update(
        cartProduct.name ?? "",
        (value) => Product(
            name: value.name,
            price: value.price,
            description: value.description,
            dateTime: value.dateTime,
            quantity: value.quantity + 1,
            imageUrls: value.imageUrls),
      );
    } else {
      _products.putIfAbsent(
          cartProduct.name ?? "",
          () => Product(
              name: cartProduct.name,
              price: cartProduct.price,
              description: cartProduct.description,
              dateTime: cartProduct.dateTime,
              quantity: cartProduct.quantity ?? 1,
              imageUrls: cartProduct.imageUrls));
    }
    saveData();
  }

  decreaseCartProduct(Product cartProduct) {
    if (_products.containsKey(cartProduct.name)) {
      _products.update(cartProduct.name ?? "", (value) {
        return Product(
            name: value.name,
            price: value.price,
            description: value.description,
            dateTime: value.dateTime,
            quantity: value.quantity - 1,
            imageUrls: value.imageUrls);
      });
    }
    saveData();
  }

  deleteProduct({required Product product}) {
    if (product.quantity < 1) {
      return _products.removeWhere((key, value) => value.name == product.name);
    }
    decreaseCartProduct(product);
  }

  // Load data from GetStorage
  void loadData() {
    // Retrieve the data from GetStorage
    Map<String, dynamic> localStorageProduct =
        _box.read<Map<String, dynamic>>(_productCart) ?? {};
    localStorageProduct.removeWhere((key, value) =>
        value is Product ? value.quantity < 1 : value["quantity"] < 1);
    //sync local storage data and convert Map<dynamic,dynamic> into Map<dynamic,Product> model.
    //Note: when app is restarted then it returns Map<dynamic, dynamic> so needs to convert.
    _products = localStorageProduct
        .map((key, value) =>
            MapEntry(key, value is Product ? value : Product.fromJson(value)))
        .obs;
  }

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  // Save data to GetStorage
  void saveData() => _box.write(_productCart, _products);
}
