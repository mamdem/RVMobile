import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medicare/models/utils/networking.dart';
import 'package:medicare/styles/colors.dart';
import 'package:medicare/styles/styles.dart';
import 'package:medicare/models/utils/global.dart' as global;


class HomeTab extends StatefulWidget {
  const HomeTab({Key? key, required this.onPressedScheduleCard}) : super(key: key);

  final void Function() onPressedScheduleCard;

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab>{

  List<dynamic> doctorsList = [];

  bool isSearch = false;

  String val="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(!global.first) {
      global.first=true;
      Networking.getDoctors().then((value) {
        setState(() {
          doctorsList = global.allDoctors;
        });
      });
    }else{
      doctorsList=global.allDoctors;
    }
  }

  _search(String val){
    setState(() {
      doctorsList=[];
      String value = val.trim().toLowerCase();
      if(value.isEmpty){
        doctorsList = global.allDoctors;
      }else{
        for(dynamic doctor in global.allDoctors){
          if(doctor['nom'].toString().toLowerCase().contains(value)
              || doctor['prenom'].toString().toLowerCase().contains(value)
              || doctor['service']['nomservice'].toString().toLowerCase().contains(value)
              || doctor['structure']['nom'].toString().toLowerCase().contains(value)
              || doctor['structure']['adresse'].toString().toString().contains(value)){
            doctorsList.add(doctor);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          // Update the `leading` to have a better design
          backgroundColor: Color(MyColors.primary),
          centerTitle: true,
          elevation: 2,
          leading: IconButton(
              icon: global. b64!=""?  CircleAvatar(
                backgroundImage: MemoryImage(base64Decode(global.b64)),
                radius: 50,
              ):global.patient['profil']!=null?CircleAvatar(
                backgroundImage: NetworkImage(Networking.baseUrlImg+"patient/"+global.patient['profil']),
                radius: 50,
              ):CircleAvatar(
                backgroundImage: AssetImage("assets/icons/default.png"),
                radius: 50,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/profil');
              }
          ),
          // Change the app name
          title: Text(
            global.patient["prenom"].toString()+' '+global.patient["nom"].toString()+' 👋',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 18
            ),
          ),
          actions: <Widget>[
            // Second button - increment
            IconButton(
              icon: isSearch? Icon(Icons.search_off):Icon(Icons.search), // The "+" icon
              onPressed: (){
                setState(() {
                  isSearch = !isSearch;
                });
              }, // The `_incrementCounter` function
            ), //IconButton
          ],
        ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
            //padding: EdgeInsets.symmetric(horizontal: 30),
            child:Padding(
              padding: const EdgeInsets.only(left: 30, top: 20, right: 30),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                isSearch? Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(MyColors.bg),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Icon(
                          Icons.search,
                          color: Color(MyColors.purple02),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: TextField(
                          onChanged: (value){
                            val=value;
                            _search(value);
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Rechercher un docteur...',
                            hintStyle: TextStyle(
                                fontSize: 13,
                                color: Color(MyColors.purple01),
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                ):Text(
                  'Accueil',
                  textAlign: TextAlign.center,
                  style: kTitleStyle,
                ),
                SizedBox(
                  height: 20,
                ),
                CategoryIcons(),
                SizedBox(
                  height: 20,
                ),
                /*Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
               Text(
                  'Les rendez-vous d\'aujourd\'hui',
                  style: kTitleStyle,
                ),
                TextButton(
                  child: Text(
                    'Voir tout',
                    style: TextStyle(
                      color: Color(MyColors.yellow01),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {},
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            AppointmentCard(
              onTap: widget.onPressedScheduleCard,
            ),
            SizedBox(
              height: 20,
            ),*/
              Expanded(
                  child:RefreshIndicator(
                    onRefresh:() async{
                      Networking.getDoctors().then((rep){
                        if(rep.isNotEmpty){
                          setState(() {
                            global.allDoctors=rep;
                            doctorsList=rep;
                          });
                        }
                      });
                    },
                    child: ListView(
                      children: [
                        Text(
                          'Top Docteur',
                          style: TextStyle(
                            color: Color(MyColors.header01),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        for (int i=0; i<doctorsList.length;i++)
                          TopDoctorCard(
                            index: i,
                            img: doctorsList[i]['profil'],
                            doctorName: doctorsList[i]['prenom']+' '+doctorsList[i]['nom'],
                            doctorTitle: doctorsList[i]['service']['nomservice'],
                          )
                      ],
                    )
                  )
              ),
            ]
          ))
        ),
      )
    );
  }
}

class TopDoctorCard extends StatelessWidget {
  int index;
  String img;
  String doctorName;
  String doctorTitle;

  TopDoctorCard({
    required this.index,
    required this.img,
    required this.doctorName,
    required this.doctorTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/detail', arguments: {"index": index});
        },
        child: Row(
          children: [
            Container(
              color: Color(MyColors.grey01),
              child: Image(
                width: 80,
                height: 95,
                image: NetworkImage(Networking.baseUrlImg+Networking.medecinDir+img),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctorName,
                  style: TextStyle(
                    color: Color(MyColors.header01),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  doctorTitle,
                  style: TextStyle(
                    color: Color(MyColors.grey02),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.star,
                      color: Color(MyColors.yellow02),
                      size: 18,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      '4.0 - 50 Reviews',
                      style: TextStyle(color: Color(MyColors.grey02)),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final void Function() onTap;

  const AppointmentCard({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(MyColors.primary),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage('assets/doctor01.jpeg'),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Dr.Muhammed Syahid',
                                style: TextStyle(color: Colors.white)),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              'Dental Specialist',
                              style: TextStyle(color: Color(MyColors.text01)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ScheduleCard(),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          height: 10,
          decoration: BoxDecoration(
            color: Color(MyColors.bg02),
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          width: double.infinity,
          height: 10,
          decoration: BoxDecoration(
            color: Color(MyColors.bg03),
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}

List<Map> categories = [
  {'icon': Icons.coronavirus, 'text': 'Covid 19'},
  {'icon': Icons.local_hospital, 'text': 'Hospital'},
  {'icon': Icons.car_rental, 'text': 'Ambulance'},
  {'icon': Icons.local_pharmacy, 'text': 'Pill'},
];

class CategoryIcons extends StatelessWidget {
  const CategoryIcons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //return Text("");
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (var category in categories)
          CategoryIcon(
            icon: category['icon'],
            text: category['text'],
          ),

      ],
    );
  }
}

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(MyColors.bg01),
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      padding: EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Icon(
            Icons.calendar_today,
            color: Colors.white,
            size: 15,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            'Mon, July 29',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            width: 20,
          ),
          Icon(
            Icons.access_alarm,
            color: Colors.white,
            size: 17,
          ),
          SizedBox(
            width: 5,
          ),
          Flexible(
            child: Text(
              '11:00 ~ 12:10',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryIcon extends StatelessWidget {
  IconData icon;
  String text;

  CategoryIcon({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Color(MyColors.bg01),
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Color(MyColors.bg),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                icon,
                color: Color(MyColors.primary),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              text,
              style: TextStyle(
                color: Color(MyColors.primary),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchInput extends StatelessWidget {
  const SearchInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(MyColors.bg),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Icon(
              Icons.search,
              color: Color(MyColors.purple02),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Rechercher un docteur...',
                hintStyle: TextStyle(
                    fontSize: 13,
                    color: Color(MyColors.purple01),
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UserIntro extends StatelessWidget {
  const UserIntro({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              global.patient["prenom"].toString()+' '+global.patient["nom"].toString()+' 👋',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        const CircleAvatar(
          backgroundImage: AssetImage('assets/person.jpeg'),
        )
      ],
    );
  }
}
