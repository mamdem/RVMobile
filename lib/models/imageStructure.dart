class ImageStructure{
  late int id;
  late String nom;
  late String dateSave;

  ImageStructure({
    required this.id,
    required this.nom,
    required this.dateSave
  });

  ImageStructure.fromJson(Map<String, dynamic> json){
    this.id=json["id"];
    this.nom=json['nom'];
    this.dateSave=json["dateSave"];
  }
}