class Category {
  final String id;
  final String nom;
  final String icone; // nom d'icône ou emoji

  Category({required this.id, required this.nom, required this.icone});

  factory Category.fromMap(Map<String, dynamic> map, String id) {
    return Category(id: id, nom: map['nom'] ?? '', icone: map['icone'] ?? '');
  }

  Map<String, dynamic> toMap() => {'nom': nom, 'icone': icone};
}