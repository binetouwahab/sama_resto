class AppUser {
  final String id;
  final String prenom;
  final String nom;
  final String email;
  final String telephone;
  final String role; // "client" ou "vendeur"

  AppUser({
    required this.id,
    required this.prenom,
    required this.nom,
    required this.email,
    required this.telephone,
    required this.role,
  });

  factory AppUser.fromMap(Map<String, dynamic> map, String id) {
    return AppUser(
      id: id,
      prenom: map['prenom'] ?? '',
      nom: map['nom'] ?? '',
      email: map['email'] ?? '',
      telephone: map['telephone'] ?? '',
      role: map['role'] ?? 'client',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'prenom': prenom,
      'nom': nom,
      'email': email,
      'telephone': telephone,
      'role': role,
    };
  }
}