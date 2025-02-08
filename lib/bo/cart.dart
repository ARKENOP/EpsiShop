import 'package:flutter/foundation.dart';
import 'package:epsi_shop/bo/product.dart';

class Cart with ChangeNotifier {
  final List<Product> _products = [];

  List<Product> get allProducts => _products;

  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }

  void removeProduct(Product product) {
    _products.remove(product);
    notifyListeners();
  }

  void clearCart() {
    _products.clear();
    notifyListeners();
  }

  double get totalHT => _products.fold(0, (sum, item) => sum + item.price);

  double get totalTTC => totalHT * 1.2;

  bool get isEmpty => _products.isEmpty;

}