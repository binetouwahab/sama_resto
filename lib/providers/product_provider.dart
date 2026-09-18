import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../services/product_service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _service = ProductService();

  String _selectedCategory = 'Tout';
  String get selectedCategory => _selectedCategory;

  void selectCategory(String categorieId) {
    _selectedCategory = categorieId;
    notifyListeners();
  }

  Stream<List<Product>> get products => _service.getProducts(
        categorieId: _selectedCategory == 'Tout' ? null : _selectedCategory,
      );

  Stream<List<Category>> get categories => _service.getCategories();
}