import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/order_service.dart';
import '../models/order_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (!auth.isLoggedIn) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profil')),
        body: Center(
          child: ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/login'),
            child: const Text('Se connecter'),
          ),
        ),
      );
    }

    final user = auth.appUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text('Mon profil', style: TextStyle(color: Colors.black87)),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: const Color(0xFFC0202D),
            child: Text(
              (user?.prenom.isNotEmpty ?? false) ? user!.prenom[0].toUpperCase() : '?',
              style: const TextStyle(color: Colors.white, fontSize: 28),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text('${user?.prenom ?? ''} ${user?.nom ?? ''}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Center(
            child: Text(user?.email ?? '',
                style: TextStyle(color: Colors.grey.shade600)),
          ),
          const SizedBox(height: 8),
          Center(
            child: Chip(
              label: Text(user?.role == 'vendeur' ? 'Vendeur local' : 'Client'),
              backgroundColor: Colors.red.shade50,
            ),
          ),
          const SizedBox(height: 24),
          const Text('Mes commandes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          StreamBuilder<List<OrderModel>>(
            stream: OrderService().getUserOrders(user!.id),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final orders = snapshot.data!;
              if (orders.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('Aucune commande pour le moment'),
                );
              }
              return Column(
                children: orders.map((o) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: const Icon(Icons.receipt_long, color: Color(0xFFC0202D)),
                      title: Text('${o.produits.length} produit(s) — ${o.total.toStringAsFixed(0)} FCFA'),
                      subtitle: Text('${o.statut} · ${o.date.day}/${o.date.month}/${o.date.year}'),
                    ),
                  );
                }).toList(),
              );
            },
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                await auth.logout();
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                }
              },
              icon: const Icon(Icons.logout, color: Color(0xFFC0202D)),
              label: const Text('Se déconnecter', style: TextStyle(color: Color(0xFFC0202D))),
            ),
          ),
        ],
      ),
    );
  }
}