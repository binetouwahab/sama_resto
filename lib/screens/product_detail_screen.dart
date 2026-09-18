import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/product_service.dart';
import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          IconButton(
            icon: const Icon(Icons.lock_outline, color: Colors.black87),
            onPressed: () {
              if (!auth.isLoggedIn) Navigator.pushNamed(context, '/login');
            },
          ),
        ],
      ),
      body: FutureBuilder<Product?>(
        future: ProductService().getProductById(productId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final product = snapshot.data;
          if (product == null) {
            return const Center(child: Text('Produit introuvable'));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    imageUrl: product.image,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => Container(
                      height: 220,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.fastfood, size: 60, color: Color(0xFFC0202D)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(product.nom, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text('${product.prix.toStringAsFixed(0)} FCFA',
                    style: const TextStyle(fontSize: 18, color: Color(0xFFC0202D), fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Text(product.description, style: TextStyle(color: Colors.grey.shade700, height: 1.4)),
                const SizedBox(height: 8),
                Text('Vendu par : ${product.vendeurId}',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FutureBuilder<Product?>(
            future: ProductService().getProductById(productId),
            builder: (context, snapshot) {
              final product = snapshot.data;
              return SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: product == null
                      ? null
                      : () {
                          if (!auth.isLoggedIn) {
                            Navigator.pushNamed(context, '/login');
                            return;
                          }
                          context.read<CartProvider>().addToCart(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Ajouté au panier')),
                          );
                        },
                  icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                  label: const Text('Ajouter au panier', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC0202D),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}