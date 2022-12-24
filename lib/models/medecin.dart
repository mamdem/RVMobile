import 'package:medicare/models/rv.dart';
import 'package:medicare/models/service.dart';
import 'package:medicare/models/structure.dart';

class Medecin{
  late int idmedecin;
  late String nom;
  late String prenom;
  late String email;
  late String mdp;
  late String tel;
  late String genre;
  late String biographie;
  late String date;
  late String profil;
  late RV rv;
  late Service service;
  late Structure structure;

  Medecin({
    required this.idmedecin,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.mdp,
    required this.tel,
    required this.genre,
    required this.biographie,
    required this.date,
    required this.profil,
    required this.rv,
    required this.service,
    required this.structure
  });

  Medecin.fromJson(Map<String, dynamic> json){
    this.idmedecin = json["idmedecin"];
    this.nom = json["nom"];
    this.prenom = json["prenom"];
    this.email = json["email"];
    this.mdp = json["mdp"];
    this.tel = json["tel"];
    this.genre = json["genre"];
    this.biographie = json["biographie"];
    this.date = json["date"];
    this.profil = json["profil"];
    this.rv = json["rv"];
    this.service = json["service"];
    this.structure = json["structure"];
  }

}