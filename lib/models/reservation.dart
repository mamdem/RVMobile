import 'package:medicare/models/patient.dart';
import 'package:medicare/models/rv.dart';

class Reservation{
  late int idreservation;
  late String datereservation;
  late RV rv;
  late Patient patient;
  late int status;

  Reservation({
    required this.idreservation,
    required this.datereservation,
    required this.rv,
    required this.patient,
    required this.status
  });

  Reservation.fromJson(Map<String, dynamic> json){
    this.idreservation = json["idreservation"];
    this.datereservation = json["datereservation"];
    this.rv = json["rv"];
    this.patient = json["patient"];
    this.status = json["status"];
  }
}