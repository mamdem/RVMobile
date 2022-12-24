import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:medicare/models/patient.dart';
import 'package:medicare/models/utils/global.dart' as global;

class Networking{

  static const String baseUrl = 'http://192.168.1.126:8080/';
  static const String patientBaseUrl = 'patient/';
  static const String rvBaseUrl = 'rendezvous/';
  static const String baseUrlImg = 'http://192.168.1.126/imguploaded/';
  static const String medecinDir = 'medecin/';
  static const String cliniqueDir = 'clinique/';

  static List<dynamic> rvList = [];
  static List<dynamic> structureList = [];

  static Future<int> signup(Patient patient) async {
    EasyLoading.instance.backgroundColor = Colors.black;
    EasyLoading.show(status:  'Inscription en cours...');
    // User user;
    int response = -1;
    await http
        .post(
          Uri.parse(baseUrl + patientBaseUrl+"add"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "prenom": patient.prenom,
            "nom": patient.nom,
            "tel": patient.tel,
            "mdp": patient.mdp,
            "genre": patient.genre
          }),
        )
        .then((value) {
          EasyLoading.dismiss();
      print("CURRENT USER : " + value.statusCode.toString());

      if (value.statusCode == 200) {
        //LoginModel.user = User.fromJson(jsonDecode(value.body));
        print("Votre compte est ouvert avce succès");
        EasyLoading.instance.backgroundColor = Colors.green;
        EasyLoading.showSuccess("Inscription reussi !");
        response=1;
      } else {
        //LoginModel.user = null;
        EasyLoading.instance.backgroundColor = Colors.red;
        EasyLoading.showError("Erreur d'ouverture du compte");
        response=-1;
      }
      response = value.statusCode;
    }).onError((error, stackTrace) {
      print(stackTrace);
      //LoginModel.user = null;
      EasyLoading.instance.backgroundColor = Colors.red;
      EasyLoading.showError("Erreur d'ouverture du compte");
      response=-1;
    }).timeout(Duration(seconds: 3), onTimeout: () {
      print("===> Time out");
      EasyLoading.instance.backgroundColor = Colors.red;
      EasyLoading.showError("Erreur d'ouverture du compte");
      response = -1;
    });
    return response;
  }

  static Future<int> login(String tel, String mdp) async {
    print(tel);
    print(mdp);
    EasyLoading.instance.backgroundColor = Colors.black;
    EasyLoading.show(status:  'Inscription en cours...');
    // User user;
    int response = -1;
    await http
        .post(
      Uri.parse(baseUrl + patientBaseUrl+"login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "tel": tel,
        "mdp": mdp
      }),
    ).then((value) {
      EasyLoading.dismiss();
      if (value.statusCode == 200) {
        if(value.body.isEmpty) {
          EasyLoading.instance.backgroundColor = Colors.red;
          EasyLoading.showError("Téléphone ou mot de passe incorrecte");
          response=-1;
        } else {
          global.patient = (jsonDecode(value.body));
          response=1;
        }
      } else {
        //LoginModel.user = null;
        EasyLoading.instance.backgroundColor = Colors.red;
        EasyLoading.showError("Erreur d'ouverture du compte");
        response=-1;
      }
    }).onError((error, stackTrace) {
      EasyLoading.instance.backgroundColor = Colors.red;
      EasyLoading.showError("Erreur de connection");
      response=-1;
    }).timeout(Duration(seconds: 3), onTimeout: () {
      EasyLoading.instance.backgroundColor = Colors.red;
      EasyLoading.showError("Erreur de connection");
      response = -1;
    });
    return response;
  }

  static Future<List<dynamic>> getRVAvailable() async {
    List response =  [] ;
    EasyLoading.instance.backgroundColor = Colors.black;
    EasyLoading.show(status:  'Chargement en cours...');
    // User user;
    await http
        .get(
      Uri.parse(baseUrl + rvBaseUrl+"all/patient/"+global.patient["idpatient"].toString()),
      headers: {"Content-Type": "application/json"},

    ).then((value) {
      EasyLoading.dismiss();
      if (value.statusCode == 200) {
          global.allRVAvailable = (jsonDecode(value.body));
          response = (jsonDecode(value.body));
      } else {
        //LoginModel.user = null;
        EasyLoading.instance.backgroundColor = Colors.red;
        EasyLoading.showError(value.statusCode.toString());
      }
    }).onError((error, stackTrace) {
      EasyLoading.dismiss();
      EasyLoading.instance.backgroundColor = Colors.red;
      EasyLoading.showError("Erreur de connection");
    }).timeout(Duration(seconds: 15), onTimeout: () {
      EasyLoading.dismiss();
      EasyLoading.instance.backgroundColor = Colors.red;
      EasyLoading.showError("Erreur de connection");
    });
    return response;
  }

  static Future<List<dynamic>> getRVHistories() async {
    List response =  [] ;

    // User user;
    await http
        .get(
      Uri.parse(baseUrl + rvBaseUrl+"historique/"+global.patient["idpatient"].toString()),
      headers: {"Content-Type": "application/json"},

    ).then((value) {
      if (value.statusCode == 200) {
        global.allRVHistories = (jsonDecode(value.body));
        response = (jsonDecode(value.body));
      } else {
        //LoginModel.user = null;
        EasyLoading.instance.backgroundColor = Colors.red;
        EasyLoading.showError(value.statusCode.toString());
      }
    }).onError((error, stackTrace) {
      EasyLoading.dismiss();
      EasyLoading.instance.backgroundColor = Colors.red;
      EasyLoading.showError("Erreur de connection");
    }).timeout(Duration(seconds: 15), onTimeout: () {
      EasyLoading.dismiss();
      EasyLoading.instance.backgroundColor = Colors.red;
      EasyLoading.showError("Erreur de connection");
    });
    return response;
  }

  static Future<List<dynamic>> getReservations() async {
    List response =  [] ;
    await http
        .get(
      Uri.parse(baseUrl + rvBaseUrl+"patient/"+global.patient["idpatient"].toString()),
      headers: {"Content-Type": "application/json"},

    ).then((value) {
      EasyLoading.dismiss();
      if (value.statusCode == 200) {
        global.allReservation = (jsonDecode(value.body));
        response = (jsonDecode(value.body));
      } else {
        //LoginModel.user = null;
        EasyLoading.instance.backgroundColor = Colors.red;
        EasyLoading.showError(value.statusCode.toString());
      }
    }).onError((error, stackTrace) {
      EasyLoading.dismiss();
      EasyLoading.instance.backgroundColor = Colors.red;
      EasyLoading.showError("Erreur de connection");
    }).timeout(Duration(seconds: 3), onTimeout: () {
      EasyLoading.dismiss();
      EasyLoading.instance.backgroundColor = Colors.red;
      EasyLoading.showError("Erreur de connection");
    });
    return response;
  }

  static Future<int> getDoctors() async {
    EasyLoading.instance.backgroundColor = Colors.black;
    EasyLoading.show(status:  'Chargement en cours...');
    // User user;
    int response = -1;
    await http
        .get(
      Uri.parse(baseUrl+medecinDir+"all"),
      headers: {"Content-Type": "application/json"},
    ).then((value) {
      EasyLoading.dismiss();
      if (value.statusCode == 200) {
        global.allDoctors = (jsonDecode(value.body));
        response=1;
      } else {
        EasyLoading.instance.backgroundColor = Colors.red;
        EasyLoading.showError(value.statusCode.toString());
        response=-1;
      }
    }).onError((error, stackTrace) {
      EasyLoading.dismiss();
      EasyLoading.instance.backgroundColor = Colors.red;
      EasyLoading.showError("Erreur de connection");
      response=-1;
    }).timeout(Duration(seconds: 3), onTimeout: () {
      EasyLoading.dismiss();
      EasyLoading.instance.backgroundColor = Colors.red;
      EasyLoading.showError("Erreur de connection");
      response = -1;
    });
    return response;
  }

  static Future demander(String idRV) async{
    // User user;
    int response = -1;
    await http
        .get(
      Uri.parse(baseUrl + "reservation/add/"+(idRV).toString()+"/"+global.patient['idpatient'].toString()),
      headers: {"Content-Type": "application/json"}
    )
        .then((value) {
      if (value.statusCode == 200) {
        //LoginModel.user = User.fromJson(jsonDecode(value.body));
        EasyLoading.instance.backgroundColor = Colors.green;
        EasyLoading.showToast("Demande reussi !", toastPosition: EasyLoadingToastPosition.bottom);
        response=1;
      } else {
        //LoginModel.user = null;
        EasyLoading.instance.backgroundColor = Colors.red;
        EasyLoading.showToast("Erreur d'envoie de la demande", toastPosition: EasyLoadingToastPosition.bottom);
        response=-1;
      }
      response = value.statusCode;
    }).onError((error, stackTrace) {
      print(stackTrace);
      //LoginModel.user = null;
      EasyLoading.instance.backgroundColor = Colors.red;
      EasyLoading.showToast("Erreur d'envoie de la demande", toastPosition: EasyLoadingToastPosition.bottom);
      response=-1;
    }).timeout(Duration(seconds: 3), onTimeout: () {
      print("TIME OUT !!!!");
      EasyLoading.instance.backgroundColor = Colors.red;
      EasyLoading.showToast("Erreur d'envoie de la demande", toastPosition: EasyLoadingToastPosition.bottom);
      response = -1;
    });
    return response;
  }

  static Future annuler(String idRV) async{
    // User user;
    int response = -1;
    await http
        .delete(
        Uri.parse(baseUrl + "reservation/"+(idRV).toString()+"/"+global.patient["idpatient"].toString()),
        headers: {"Content-Type": "application/json"}
    )
        .then((value) {
      if (value.statusCode == 200) {
        //LoginModel.user = User.fromJson(jsonDecode(value.body));
        EasyLoading.instance.backgroundColor = Colors.green;
        EasyLoading.showToast("Annulation reussie !", toastPosition: EasyLoadingToastPosition.bottom);
        response=1;
      } else {
        //LoginModel.user = null;
        print(value.statusCode);
        EasyLoading.instance.backgroundColor = Colors.red;
        EasyLoading.showToast("Erreur d'envoie de l'annulation", toastPosition: EasyLoadingToastPosition.bottom);
        response=-1;
      }
      response = value.statusCode;
    }).onError((error, stackTrace) {
      print(stackTrace);
      //LoginModel.user = null;
      EasyLoading.instance.backgroundColor = Colors.red;
      EasyLoading.showToast("Erreur d'envoie de l'annulation", toastPosition: EasyLoadingToastPosition.bottom);
      response=-1;
    }).timeout(Duration(seconds: 3), onTimeout: () {
      print("TIME OUT !!!!");
      EasyLoading.instance.backgroundColor = Colors.red;
      EasyLoading.showToast("Erreur d'envoie de l'annulation", toastPosition: EasyLoadingToastPosition.bottom);
      response = -1;
    });
    return response;
  }
}