import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/order_model.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, int> _quantites = {}; // productId -> quantité
  final Map<String, Product> _produits = {}; // productId -> Product

  Map<String, int> get quantites => _quantites;

  void addToCart(Product product) {
    _produits[product.id] = product;
    _quantites[product.id] = (_quantites[product.id] ?? 0) + 1;
    notifyListeners();
  }

  void removeOne(String productId) {
    if (!_quantites.containsKey(productId)) return;
    if (_quantites[productId]! <= 1) {
      _quantites.remove(productId);
      _produits.remove(productId);
    } else {
      _quantites[productId] = _quantites[productId]! - 1;
    }
    notifyListeners();
  }

  void clear() {
    _quantites.clear();
    _produits.clear();
    notifyListeners();
  }

  int get itemCount => _quantites.values.fold(0, (a, b) => a + b);

  double get total {
    double t = 0;
    _quantites.forEach((id, qte) {
      t += (_produits[id]?.prix ?? 0) * qte;
    });
    return t;
  }

  List<OrderItem> toOrderItems() {
    return _quantites.entries.map((e) {
      final p = _produits[e.key]!;
      return OrderItem(productId: p.id, nom: p.nom, prix: p.prix, quantite: e.value);
    }).toList();
  }
}