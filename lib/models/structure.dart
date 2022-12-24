import 'package:medicare/models/imageStructure.dart';

class Structure{
  late int id;
  late String nom;
  late String adresse;
  late double latitude;
  late double longitude;
  late ImageStructure imageStructure;

  Structure({
    required this.id,
    required this.nom,
    required this.adresse,
    required this.latitude,
    required this.longitude,
    required this.imageStructure
  });

  Structure.fromJson(Map<String, dynamic> json){
    this.id=json['id'];
    this.nom=json['nom'];
    this.adresse=json["adresse"];
    this.latitude=json["latitude"];
    this.longitude=json["longitude"];
    this.imageStructure=json["imageStructure"];
  }
}