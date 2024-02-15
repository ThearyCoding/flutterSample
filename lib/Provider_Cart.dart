import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:store_image/model/product.dart';

class CartController extends GetxController {
  var _products = {}.obs;
  final _box = GetStorage(); // Initialize GetStorage

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  bool isProductInCart(Product product) {
    return _products.containsKey(product) && _products[product] >= 0;
  }

  get products => _products;
  void addProduct(Product product) {
    if (_products.containsKey(product)) {
      _products[product] += 1;
    } else {
      _products[product] = 1;
    }
    saveData();
  }

  get count => _products.length;

  void removeProduct(Product product) {
    if (_products.containsKey(product) && _products[product] == 1) {
      _products.removeWhere((key, value) => key == product);
    } else {
      _products[product] -= 1;
    }
    // Save data to GetStorage after removing a product
    saveData();
  }

  get productSubTotal => _products.entries
      .map((product) => product.key.price * product.value)
      .toList();

  // Save data to GetStorage
  void saveData() {
    // Convert the _products map to a list of Map entries for GetStorage
    List<Map<String, dynamic>> productList = _products.entries.map((entry) {
      return {
        'product': entry.key.toJson(),
        'quantity': entry.value,
      };
    }).toList();

    // Save the data to GetStorage
    _box.write('cart', productList);
  }

  // Load data from GetStorage
  void loadData() {
    // Retrieve the data from GetStorage
    List<Map<String, dynamic>> productList =
        List<Map<String, dynamic>>.from(_box.read<List>('cart') ?? []);

    // Parse the data to update the _products map
    _products = Map.fromEntries(productList.map((entry) {
      return MapEntry(
        Product.fromJson(entry['product']),
        entry['quantity'],
      );
    })).obs;
  }
}
