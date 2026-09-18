class OrderItem {
  final String productId;
  final String nom;
  final double prix;
  final int quantite;

  OrderItem({
    required this.productId,
    required this.nom,
    required this.prix,
    required this.quantite,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['productId'] ?? '',
      nom: map['nom'] ?? '',
      prix: (map['prix'] ?? 0).toDouble(),
      quantite: map['quantite'] ?? 1,
    );
  }

  Map<String, dynamic> toMap() => {
        'productId': productId,
        'nom': nom,
        'prix': prix,
        'quantite': quantite,
      };
}

class OrderModel {
  final String id;
  final String userId;
  final List<OrderItem> produits;
  final String statut; // en attente / validée / livrée
  final DateTime date;
  final double total;

  OrderModel({
    required this.id,
    required this.userId,
    required this.produits,
    required this.statut,
    required this.date,
    required this.total,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map, String id) {
    return OrderModel(
      id: id,
      userId: map['userId'] ?? '',
      produits: (map['produits'] as List<dynamic>? ?? [])
          .map((p) => OrderItem.fromMap(Map<String, dynamic>.from(p)))
          .toList(),
      statut: map['statut'] ?? 'en attente',
      date: DateTime.parse(map['date']),
      total: (map['total'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'produits': produits.map((p) => p.toMap()).toList(),
      'statut': statut,
      'date': date.toIso8601String(),
      'total': total,
    };
  }
}