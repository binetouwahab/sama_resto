import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/product_model.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: CachedNetworkImage(
              imageUrl: product.image,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                width: 70, height: 70, color: Colors.grey.shade200,
              ),
              errorWidget: (_, __, ___) => Container(
                width: 70, height: 70, color: Colors.grey.shade200,
                child: const Icon(Icons.fastfood, color: Color(0xFFC0202D)),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(product.nom, style: const TextStyle(fontSize: 13), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}