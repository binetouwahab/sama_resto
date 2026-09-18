import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';

class ProductService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Product>> getProducts({String? categorieId}) {
    Query query = _db.collection('products');
    if (categorieId != null && categorieId != 'Tout') {
      query = query.where('categorieId', isEqualTo: categorieId);
    }
    return query.snapshots().map((snap) => snap.docs
        .map((d) => Product.fromMap(d.data() as Map<String, dynamic>, d.id))
        .toList());
  }

  Stream<List<Category>> getCategories() {
    return _db.collection('categories').snapshots().map((snap) => snap.docs
        .map((d) => Category.fromMap(d.data(), d.id))
        .toList());
  }

  Future<Product?> getProductById(String id) async {
    final doc = await _db.collection('products').doc(id).get();
    if (!doc.exists) return null;
    return Product.fromMap(doc.data()!, doc.id);
  }

  // Utile pour un vendeur qui ajoute un produit (fonctionnalité optionnelle)
  Future<void> addProduct(Product product) {
    return _db.collection('products').doc().set(product.toMap());
  }
}