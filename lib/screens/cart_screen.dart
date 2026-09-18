import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import '../services/order_service.dart';
import '../models/order_model.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text('Mon panier', style: TextStyle(color: Colors.black87)),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: cart.quantites.isEmpty
          ? const Center(child: Text('Ton panier est vide'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: cart.quantites.entries.map((e) {
                return ListTile(
                  title: Text(e.key),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline, color: Color(0xFFC0202D)),
                        onPressed: () => cart.removeOne(e.key),
                      ),
                      Text('${e.value}'),
                    ],
                  ),
                );
              }).toList(),
            ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('${cart.total.toStringAsFixed(0)} FCFA',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFC0202D))),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: cart.quantites.isEmpty
                      ? null
                      : () async {
                          final order = OrderModel(
                            id: '',
                            userId: auth.appUser?.id ?? '',
                            produits: cart.toOrderItems(),
                            statut: 'en attente',
                            date: DateTime.now(),
                            total: cart.total,
                          );
                          await OrderService().placeOrder(order);
                          cart.clear();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Commande validée !')),
                            );
                            Navigator.pop(context);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC0202D),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Valider la commande', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}