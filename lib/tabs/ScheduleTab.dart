import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medicare/models/utils/networking.dart';
import 'package:medicare/styles/colors.dart';
import 'package:medicare/styles/styles.dart';

import 'package:medicare/models/utils/global.dart' as global;

class ScheduleTab extends StatefulWidget {
  const ScheduleTab({Key? key}) : super(key: key);

  @override
  State<ScheduleTab> createState() => _ScheduleTabState();
}

enum FilterStatus { Upcoming, Complete, Cancel }


class _ScheduleTabState extends State<ScheduleTab> {
  FilterStatus status = FilterStatus.Upcoming;
  Alignment _alignment = Alignment.centerLeft;

  String currentStatus = "À venir";
  List<dynamic> currentSchedules = [];
  List<dynamic> currentSchedulesSauve = [];

  String val="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(global.statusTab.isEmpty){
      for(int i=0; i<global.allRVAvailable.length;i++){
        global.statusTab.add(-1);    //-1 = non demandé; 0 en cours de demande ou d'annulation; 1 demande
        global.statusTab1.add(-1);
      }
    }
    currentSchedules = global.allRVAvailable;
    currentSchedulesSauve = global.allRVAvailable;
  }

  initializestatusTab(List<dynamic> list){
    global.statusTab = [];
    for(int i=0; i<list.length;i++){
      global.statusTab.add(-1);    //-1 = non demandé; 0 en cours de demande ou d'annulation; 1 demande
    }
  }

  _search(String _value){
    String value = _value.toLowerCase();
    setState(() {
      currentSchedules = [];
      dynamic schedule;
      if(value.trim().isEmpty){
        currentSchedules=currentSchedulesSauve;
        return;
      }
      for(dynamic sched in currentSchedulesSauve){
        schedule = sched;
        if(status==FilterStatus.Complete){
          schedule=sched["rendezvous"];
        }
        if(schedule["medecin"]["prenom"].toString().toLowerCase().contains(value)
            || schedule["medecin"]["nom"].toString().toLowerCase().contains(value)
        || schedule["medecin"]["structure"]["nom"].toString().toLowerCase().contains(value)
        || schedule["medecin"]["structure"]["adresse"].toString().toLowerCase().contains(value)){
          currentSchedules.add(sched);
        }
      }
    });
  }

  bool isSearch=false;
  @override
  Widget build(BuildContext context) {
    final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
    return Scaffold(
      appBar: AppBar(
        // Update the `leading` to have a better design
        backgroundColor: Color(MyColors.primary),
        centerTitle: true,
        leading: IconButton(
            icon:global. b64!=""?  CircleAvatar(
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
      body: Padding(
        padding: const EdgeInsets.only(left: 30, top: 20, right: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /*Text(
              'Rendez-vous',
              textAlign: TextAlign.center,
              style: kTitleStyle,
            ),*/
            isSearch ? Container(  //Recherche
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
            ):Text(
              'Rendez-vous',
              textAlign: TextAlign.center,
              style: kTitleStyle,
            ),
            SizedBox(
              height: 20,
            ),
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(MyColors.bg),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                  status = FilterStatus.Upcoming;
                                  _alignment = Alignment.centerLeft;
                                  currentStatus = "À venir";
                                  currentSchedules = global.allRVAvailable;
                                  currentSchedulesSauve = global.allRVAvailable;
                                  global.statusTab = global.statusTab1;
                                  _search(val);
                              });
                            },
                            child: Center(
                              child: Text(
                               "À venir",
                                style: kFilterStyle,
                              ),
                            ),
                          ),
                        ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              status = FilterStatus.Complete;
                              _alignment = Alignment.center;
                              currentStatus = "Mes RV";
                              currentSchedules = global.allReservation;
                              currentSchedulesSauve = global.allReservation;
                              initializestatusTab(currentSchedules);
                              _search(val);
                            });
                          },
                          child: Center(
                            child: Text(
                              "Mes RV",
                              style: kFilterStyle,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              status = FilterStatus.Cancel;
                              _alignment = Alignment.centerRight;
                              currentStatus = "Historiques";
                              currentSchedules = global.allRVHistories;
                              currentSchedulesSauve = global.allRVHistories;
                              initializestatusTab(currentSchedules);
                              _search(val);
                            });
                          },
                          child: Center(
                            child: Text(
                              "Historiques",
                              style: kFilterStyle,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedAlign(
                  duration: Duration(milliseconds: 200),
                  alignment: _alignment,
                  child: Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(MyColors.primary),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        currentStatus,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async{
                  Networking.getRVAvailable().then((resp){
                    if(resp.isNotEmpty) {
                      setState(() {
                        global.allRVAvailable = resp;
                        if(status==FilterStatus.Upcoming){
                          currentSchedules = resp;
                          currentSchedulesSauve = resp;
                          initializestatusTab(resp);
                          global.statusTab1 = global.statusTab;
                          _search(val);
                        }
                      });
                    }
                  });
                  Networking.getReservations().then((resp){
                    if(resp.isNotEmpty){
                      setState(() {
                        global.allReservation = resp;
                        if(status==FilterStatus.Complete){
                          currentSchedules = resp;
                          currentSchedulesSauve = resp;
                          initializestatusTab(resp);
                          _search(val);
                        }
                      });
                    }
                  });
                  Networking.getRVHistories().then((resp){
                    if(resp.isNotEmpty){
                      setState(() {
                        global.allRVHistories = resp;
                        if(status==FilterStatus.Cancel){
                          currentSchedules=resp;
                          currentSchedulesSauve=resp;
                          initializestatusTab(resp);
                          _search(val);
                        }
                      });
                    }
                  });

                },
                child: currentSchedules.isEmpty ?
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
                                  status==FilterStatus.Cancel? 'Aucune historique'
                                  : 'Aucun rendez-vous',
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
                    : ListView.builder(
                  itemCount: currentSchedules.length,
                  itemBuilder: (context, index) {
                    var _schedule = currentSchedules[index];
                    if(status==FilterStatus.Complete){
                      _schedule = currentSchedules[index]['rendezvous'];
                    }
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
                                if(status==FilterStatus.Upcoming)
                                  if(global.statusTab[index]==0)
                                    Expanded(child: LinearProgressIndicator())
                                  else if(global.statusTab[index]==-1)
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
                                  else
                                    Expanded(
                                      child: OutlinedButton(
                                        child: Text('Annuler'),
                                        onPressed: () async{
                                          Networking.annuler(_schedule['idrdv'].toString()).then((resp){
                                            if(resp!=-1){   //That's OK
                                              setState(() {
                                                global.statusTab[index]=-1;
                                                global.statusTab1[index]=-1;
                                              });
                                            }else{
                                              setState(() {
                                                global.statusTab[index]=1;
                                                global.statusTab1[index]=1;
                                              });
                                            }
                                          });

                                        },
                                        style: OutlinedButton.styleFrom(
                                          side: BorderSide(width: 1.0, color: Colors.orange),
                                        ),
                                      ),
                                    )
                                else if(status==FilterStatus.Complete)
                                  if(_schedule['patient']!=null && _schedule['patient']['idpatient']==global.patient['idpatient'])
                                    Expanded(
                                      child: OutlinedButton(
                                        child: Text('Confirmé', style: TextStyle(color: Colors.green),),
                                        onPressed: null,

                                      ),
                                    )
                                  else if(_schedule['patient']==null && currentSchedules[index]['status']==0)
                                    Expanded(
                                      child: OutlinedButton(
                                        child: Text('En attente', style: TextStyle(color: Colors.orange),),
                                        onPressed: null,

                                      ),
                                    )
                                  else if(_schedule['patient']==null && currentSchedules[index]['status']==-1)
                                    Expanded(
                                      child: OutlinedButton(
                                        child: Text('Rejeté',style: TextStyle(color: Colors.red),),
                                        onPressed: null,
                                      ),
                                    )
                                  else
                                    Expanded(
                                      child: OutlinedButton(
                                        child: Text('Confirmé pour un autre', style: TextStyle(color: Colors.deepOrangeAccent),),
                                        onPressed: null,
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
          ],
        ),
      ),
    );
  }
}

/*class DateTimeCard extends StatelessWidget {
  const DateTimeCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                'Mon, July 29',
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
                '11:00 ~ 12:10',
                style: TextStyle(
                  color: Color(MyColors.primary),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
*/