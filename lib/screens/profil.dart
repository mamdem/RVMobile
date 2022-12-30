import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_type/image_picker_type.dart';
import 'package:medicare/models/utils/networking.dart';
import 'package:medicare/screens/Profile/display_image.dart';
import 'package:medicare/styles/colors.dart';
import 'package:medicare/styles/styles.dart';
import 'package:medicare/models/utils/global.dart' as global;

class Profil extends StatefulWidget {
  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {

  var prenomController = TextEditingController();
  var nomController = TextEditingController();
  var emailController = TextEditingController();
  var mdpController = TextEditingController();
  var telController = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    prenomController.text = global.patient['prenom'] ?? "";
    nomController.text = global.patient['nom'] ?? "";
    emailController.text = global.patient['email'] ?? "";
    telController.text = global.patient['tel'] ?? "";
    mdpController.text = global.patient['mdp'] ?? "";
  }

  bool loading=false;


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(MyColors.primary),
        title: Text("Profil"),
      ),
      body: Column(
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: 10,
          ),

          InkWell(
              onTap: () {
                //navigateSecondPage(EditImagePage());
                showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return SafeArea(
                        child: ImagePickerHelper(
                          // isSave: true,  //if you want to save image in directory
                          size: Size(300, 300),
                          onDone: (file) {
                            setState(() {
                              loading=true;
                            });
                            if (file == null) {
                              print(null);
                            } else {
                              Uint8List bytes = file.readAsBytesSync();
                              String base64Image = base64Encode(bytes);
                              Networking.updateProfil(base64Image, global.patient['idpatient'].toString()).then((resp){
                                if(resp!=-1){
                                  setState(() {
                                    loading=false;
                                    global.b64 = base64Image;
                                    global.patient['profil']=global.prefixImg+global.patient['idpatient'].toString()+".png";
                                  });
                                }
                              });

                            }
                          },
                        ),
                      );/// If you dont want to safe area you can remove it
                    }
                  );
              },
              child:Stack(children: [
                CircleAvatar(
                  radius: 55,
                  //backgroundColor: color,
                  child:Stack(
                    children: [
                      global. b64!=""?  CircleAvatar(
                        backgroundImage: MemoryImage(base64Decode(global.b64)),
                        radius: 100,
                      ):global.patient['profil']!=null?CircleAvatar(
                        backgroundImage: NetworkImage(Networking.baseUrlImg+"patient/"+global.patient['profil']),
                        radius: 100,
                      ):CircleAvatar(
                        backgroundImage: AssetImage("assets/icons/default.png"),
                        radius: 100,
                      ),
                      loading?Center(
                        child: CircularProgressIndicator(
                      )):Text(""),
                    ],
                  )


                ),


                Positioned(
                  child: ClipOval(
                      child: Container(
                        padding: EdgeInsets.all(7),
                        color: Colors.white,
                        child: Icon(
                          Icons.camera_alt_rounded,
                          color: Color(MyColors.primary),
                          size: 20,
                        ),
                      )),
                  right: -5,
                  top: 10,
                ),

              ]
            )
          ),
          Expanded(child: ListView(
            children: [
              //Prenom field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                child: TextFormField(
                  //readOnly: true,
                  enabled: false,
                  controller: prenomController,
                  textInputAction: TextInputAction.done,
                  obscureText: false,
                  decoration: InputDecoration(
                      hintText: "Prenom",
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(0),
                        child: Icon(Icons.person),
                      ),
                      suffixIcon: IconButton(
                        onPressed: (){},
                        icon: Icon(Icons.edit),
                        color: Color(MyColors.primary),
                      ),
                      //border: OutlineInputBorder(),
                  ),
                ),
              ),
              //Nom field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                child: TextFormField(
                  enabled: false,
                  controller: nomController,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                      hintText: "Nom",
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(0),
                        child: Icon(Icons.person),
                      ),
                      suffixIcon: IconButton(
                        onPressed: (){},
                        icon: Icon(Icons.edit),
                        color: Color(MyColors.primary),
                      )
                  ),
                ),
              ),
              //Email field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                child: TextFormField(
                  controller: emailController,
                  textInputAction: TextInputAction.done,
                  enabled: false,
                  decoration: InputDecoration(
                      hintText: emailController.text==""? "Saisissez votre email...":emailController.text,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(0),
                        child: Icon(Icons.email),
                      ),
                      suffixIcon: IconButton(
                        onPressed: (){},
                        icon: Icon(Icons.edit),
                        color: Color(MyColors.primary),
                      )
                  ),
                ),
              ),
              //Téléphone field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                child: TextFormField(
                  enabled: false,
                  controller: telController,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                      hintText: "Téléphone",
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(0),
                        child: Icon(Icons.phone_android),
                      ),
                      suffixIcon: IconButton(
                        onPressed: (){},
                        icon: Icon(Icons.edit),
                        color: Color(MyColors.primary),
                      )
                  ),
                ),
              ),
              //MDP field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                child: TextFormField(
                  controller: telController,
                  textInputAction: TextInputAction.done,
                  obscureText: true,
                  enabled: false,
                  decoration: InputDecoration(
                      hintText: "Mot de passe",
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(0),
                        child: Icon(Icons.lock),
                      ),
                      suffixIcon: IconButton(
                        onPressed: (){},
                        icon: Icon(Icons.edit),
                        color: Color(MyColors.primary),
                      )
                  ),
                ),
              ),

              //Btn modify field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
                child:  ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color(MyColors.primary),
                    ),
                  ),
                  child: Text('Modifier'),
                  onPressed: () => {


                  },
                )
              ),
              //Btn disconnect field
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 0),
                  child:  ElevatedButton.icon(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.red,
                      ),
                    ),
                    onPressed: () {},
                    label: Text('Déconnexion'), // <-- Text
                    icon: Icon( // <-- Icon
                      Icons.logout,
                      size: 24.0,
                    ),
                  ),
              ),
            ],
          ))
        ]
      )
    );
  }
}