import 'package:medicare/models/medecin.dart';
import 'package:medicare/models/patient.dart';

class RV{
  late int id;
  late String datecreation;
  late String heuredebut;
  late String heurefin;
  late String description;
  late int etat;
  late Medecin medecin;
  late Patient patient;

  RV({
    required this.id,
    required this.datecreation,
    required this.heuredebut,
    required this.heurefin,
    required this.description,
    required this.etat,
    required this.medecin,
    required this.patient
});

  RV.fromJson(Map<String, dynamic> json){
    this.id = json["id"];
    this.datecreation = json["datecreation"];
    this.heuredebut = json["heuredebut"];
    this.heurefin = json["heurefin"];
    this.description = json["description"];
    this.etat = json["etat"];
    this.medecin = json["medecin"];
    this.patient = json["patient"];
  }

}