import 'package:flutter/material.dart';
import 'package:medicare/models/patient.dart';
import 'package:medicare/models/utils/networking.dart';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../Login/login_screen.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var prenomController = TextEditingController();
    var nomController = TextEditingController();
    var telController = TextEditingController();
    var mdpController = TextEditingController();

    var genre = ["Genre","Homme", "Femme"];

    String genreSelected = "Genre";

    return Form(
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            controller: prenomController,
            onSaved: (email) {},
            decoration: InputDecoration(
              hintText: "Prénom",
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              controller: nomController,
              decoration: InputDecoration(
                hintText: "Nom",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.person),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              obscureText: false,
              keyboardType: TextInputType.phone,
              cursorColor: kPrimaryColor,
              controller: telController,
              decoration: InputDecoration(
                hintText: "Téléphone",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.phone_android),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              controller: mdpController,
              decoration: InputDecoration(
                hintText: "Mot de passe",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: defaultPadding),
        child:  DropdownButtonFormField(
          isExpanded: true,
          decoration: InputDecoration(
            hintText: "Mot de passe",
            prefixIcon: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Icon(Icons.person_outline_outlined),
            ),
          ),
          items: genre.map((location) {
            return DropdownMenuItem(
              child: new Text(location,
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                  )),
              value: location,
            );
          }).toList(),
          value: genreSelected,
          onChanged: (dynamic newValue) {
            genreSelected = newValue;
          },
        ),
      ),

          const SizedBox(height: defaultPadding / 2),
          ElevatedButton(
            onPressed: () async{
              int a = await Networking.signup(Patient(idpatient: "0", nom: nomController.text, prenom: prenomController.text, email: "", mdp: mdpController.text, tel: telController.text, genre: genreSelected, profil: "profil"));
              if(a!=-1){
                final route = MaterialPageRoute(
                    builder: (BuildContext context) => LoginScreen());
                Navigator.of(context)
                    .pushAndRemoveUntil(route, (Route<dynamic> route) => false);
              }
            },
            child: Text("Inscripton".toUpperCase()),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return LoginScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}