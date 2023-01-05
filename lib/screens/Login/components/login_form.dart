import 'package:flutter/material.dart';
import 'package:medicare/models/utils/networking.dart';
import 'package:medicare/screens/home.dart';
import 'package:medicare/styles/colors.dart';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../Signup/signup_screen.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var telController = TextEditingController();
    var mdpController = TextEditingController();

    telController.text="777327178";
    mdpController.text="houma";
    return Form(
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            controller: telController,
            onSaved: (email) {},
            decoration: InputDecoration(
              hintText: "Téléphone",
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Icon(Icons.phone_android),
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
          const SizedBox(height: defaultPadding),
          Hero(
            tag: "login_btn",
            child: ElevatedButton(
              onPressed: () async{
                int res = await Networking.login(telController.text, mdpController.text);
                if(res==1){
                  final route = MaterialPageRoute(
                      builder: (BuildContext context) => Home());
                  Navigator.of(context)
                      .pushAndRemoveUntil(route, (Route<dynamic> route) => false);
                }
              },
              child: Text(
                "Connexion".toUpperCase(),
              ),
              style: ElevatedButton.styleFrom(
                  primary: Color(MyColors.primary), elevation: 0),
            ),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SignUpScreen();
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
