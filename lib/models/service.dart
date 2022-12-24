class Service{
  late int idservice;
  late String nomservice;
  late String description;

  Service({
    required this.idservice,
    required this.nomservice,
    required this.description
  });

  Service.fromJson(Map<String, dynamic> json){
    this.idservice=json['idservice'];
    this.nomservice = json["nomservice"];
    this.description = json["description"];
  }
}