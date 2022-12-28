import 'package:flutter/material.dart';
import 'package:medicare/models/utils/networking.dart';
import 'package:medicare/styles/colors.dart';
import 'package:medicare/styles/styles.dart';

import 'package:medicare/models/utils/global.dart' as global;

class DoctorAppointement extends StatefulWidget {
  const DoctorAppointement({Key? key}) : super(key: key);

  @override
  State<DoctorAppointement> createState() => _DoctorAppointementState();
}



class _DoctorAppointementState extends State<DoctorAppointement> {

  String currentStatus = "À venir";


  String val="";

  int index=0;

  List<dynamic> currentSchedules = [];
  List<dynamic> currentSchedulesSauve = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentSchedules = global.rvByMedecin;
    currentSchedulesSauve = global.rvByMedecin;
  }

  _search(String _value){
    String value = _value.toLowerCase();
    setState(() {
      currentSchedules = [];
      if(value.trim().isEmpty){
        currentSchedules=currentSchedulesSauve;
        return;
      }
      for(dynamic schedule in currentSchedulesSauve){

        if(schedule["medecin"]["prenom"].toString().toLowerCase().contains(value)
            || schedule["medecin"]["nom"].toString().toLowerCase().contains(value)
            || schedule["medecin"]["structure"]["nom"].toString().toLowerCase().contains(value)
            || schedule["medecin"]["structure"]["adresse"].toString().toLowerCase().contains(value)){
          currentSchedules.add(schedule);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 30, top: 30, right: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 20,
            ),
            Container(  //Recherche
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
                        setState(() {
                          val=value;
                        });
                        _search(value);
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Rechercher un rendez-vous...',
                        hintStyle: TextStyle(
                            fontSize: 13,
                            color: Color(MyColors.purple01),
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                child: RefreshIndicator(
                  onRefresh: () async{

                  },
                  child: currentSchedules.isEmpty?
                  ListView(
                    children: [
                      Row(
                        children: [
                          const Spacer(),
                          Expanded(
                              flex: 8,
                              child: Column(
                                children: [
                                  SizedBox(height: 100.0,),
                                  Image.asset("assets/images/cons.png"),
                                  SizedBox(height: 20.0,),
                                  Text(
                                   "Aucun rendez-vous disponible",
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 10.0,),
                                ],
                              )
                          ),
                          const Spacer(),
                        ],
                      )
                    ],
                  )
                      :ListView.builder(
                    itemCount: currentSchedules.length,
                    itemBuilder: (context, index) {
                      var _schedule = currentSchedules[index];
                      bool isLastElement = currentSchedules.length + 1 == index;
                      return Card(
                        margin: !isLastElement
                            ? EdgeInsets.only(bottom: 20)
                            : EdgeInsets.zero,
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            //crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(Networking.baseUrlImg+Networking.medecinDir+_schedule["medecin"]["profil"]),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _schedule['medecin']['prenom']+' '+_schedule['medecin']['nom'],
                                        style: TextStyle(
                                          color: Color(MyColors.header01),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        _schedule["medecin"]['service']["nomservice"],
                                        style: TextStyle(
                                          color: Color(MyColors.grey02),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Color(MyColors.bg03),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                width: double.infinity,
                                padding: EdgeInsets.all(20),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_today,
                                          color: Color(MyColors.primary),
                                          size: 15,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          _schedule["datecreation"].toString().substring(0,10),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(MyColors.primary),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.access_alarm,
                                          color: Color(MyColors.primary),
                                          size: 17,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          _schedule["heuredebut"].toString().substring(0,5)+' ~ '+_schedule["heurefin"].toString().substring(0,5),
                                          style: TextStyle(
                                            color: Color(MyColors.primary),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      child: Text('Détails'),
                                      onPressed: () {},
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(width: 1.0, color: Colors.blue),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                      Expanded(
                                        child: ElevatedButton(
                                          child: Text('Demander'),
                                          onPressed: () async{
                                            setState(() {
                                              global.statusTab[index]=0;
                                            });
                                            Networking.demander(_schedule["idrdv"].toString()).then((resp){
                                              if(resp!=-1){ //That's OK
                                                //global.allRVAvailable
                                                setState(() {
                                                  global.statusTab[index]=1;   //Possibilité d'annuler la demande
                                                  global.statusTab1[index]=1;
                                                });
                                              }else{
                                                setState(() {
                                                  global.statusTab[index]=-1;   //Possibilité d'annuler la demande
                                                  global.statusTab1[index]=-1;
                                                });
                                              }
                                            }) ;
                                          },
                                        ),
                                      )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
            )
          ]
        )
      ),
    );
  }
}
