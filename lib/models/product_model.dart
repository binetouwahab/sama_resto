class Product {
  final String id;
  final String nom;
  final double prix;
  final String categorieId;
  final String image;
  final String description;
  final int stock;
  final String vendeurId;

  Product({
    required this.id,
    required this.nom,
    required this.prix,
    required this.categorieId,
    required this.image,
    required this.description,
    required this.stock,
    required this.vendeurId,
  });

  factory Product.fromMap(Map<String, dynamic> map, String id) {
    return Product(
      id: id,
      nom: map['nom'] ?? '',
      prix: (map['prix'] ?? 0).toDouble(),
      categorieId: map['categorieId'] ?? '',
      image: map['image'] ?? '',
      description: map['description'] ?? '',
      stock: map['stock'] ?? 0,
      vendeurId: map['vendeurId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'prix': prix,
      'categorieId': categorieId,
      'image': image,
      'description': description,
      'stock': stock,
      'vendeurId': vendeurId,
    };
  }
}