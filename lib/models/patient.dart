import 'dart:core';
class Patient implements Comparable<Patient>{
  late String idpatient;
  late String nom;
  late String prenom;
  late String email;
  late String mdp;
  late String tel;
  late String genre;
  late String profil;


  Patient({
    required this.idpatient,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.mdp,
    required this.tel,
    required this.genre,
    required this.profil
});

  Patient.fromJson(dynamic json){
    this.idpatient = json["idpatient"];
    this.nom = json["nom"];
    this.prenom = json["prenom"];
    this.email = json["email"];
    this.mdp = json["mdp"];
    this.tel = json["tel"];
    this.genre = json["genre"];
    this.profil = json["profil"];
  }

  @override
  int compareTo(Patient other) {
    // TODO: implement compareTo
    throw UnimplementedError();
  }
}