class Medecin {
  final String nom;
  final String prenom;
  final String specialite;
  final String adresse;
  final String medecinId; // Champ medecinId ajouté

  Medecin({
    required this.nom,
    required this.prenom,
    required this.specialite,
    required this.adresse,
    required this.medecinId, // Ajout du champ medecinId au constructeur
  });
}
