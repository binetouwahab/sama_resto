class Seller {
  final String id;
  final String nom;
  final String localisation;
  final String description;

  Seller({
    required this.id,
    required this.nom,
    required this.localisation,
    required this.description,
  });

  factory Seller.fromMap(Map<String, dynamic> map, String id) {
    return Seller(
      id: id,
      nom: map['nom'] ?? '',
      localisation: map['localisation'] ?? '',
      description: map['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        'nom': nom,
        'localisation': localisation,
        'description': description,
      };
}