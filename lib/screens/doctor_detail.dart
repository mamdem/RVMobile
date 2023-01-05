import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:medicare/models/utils/networking.dart';
import 'package:medicare/styles/colors.dart';
import 'package:medicare/styles/styles.dart';
import 'package:medicare/models/utils/global.dart' as global;

class SliverDoctorDetail extends StatefulWidget {

  const SliverDoctorDetail({Key? key}) : super(key: key);

  @override
  _SliverDoctorDetailState createState() => _SliverDoctorDetailState();
}

class _SliverDoctorDetailState extends State<SliverDoctorDetail> {

  int index=0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final json = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    setState(() {
      index = json['index'];
    });
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text(global.allDoctors[index]['structure']['nom']),
            backgroundColor: Color(MyColors.primary),
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              background: global.allDoctors[index]['structure']['imageStructures'].length==0?Image(
                image: AssetImage('assets/default-hospital-profile.jpg'),
                fit: BoxFit.cover,
              ):Image(
                image: (NetworkImage(Networking.baseUrlImg+Networking.cliniqueDir+global.allDoctors[index]['structure']['imageStructures'][0]['nom'])),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: DetailBody(json: global.allDoctors[index], index: index,),
          )
        ],
      ),
    );
  }
}

class DetailBody extends StatelessWidget {
  dynamic json;
  int index;
  DetailBody({Key? key,
    required this.json, required this.index
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    late GoogleMapController mapController; //contrller for Google map
    final Set<Marker> markers = new Set(); //markers for google map
    LatLng showLocation = LatLng(global.allDoctors[index]['structure']['latitude'], global.allDoctors[index]['structure']['longitude']); //location to show in map

    Set<Marker> getmarkers() { //markers to place on map
      markers.add(Marker( //add third marker
        markerId: MarkerId(showLocation.toString()),
        position: showLocation, //position of marker
        infoWindow: InfoWindow( //popup info
          title: 'Marker Title Third ',
          snippet: 'My Custom Subtitle',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));
        //add more markers here
      return markers;
    }

    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DetailDoctorCard(json: json,),
          SizedBox(
            height: 15,
          ),
          DoctorInfo(),
          SizedBox(
            height: 30,
          ),
          Text(
            'À propos de '+json['prenom'],
            style: kTitleStyle,
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            json['biographie'],
            style: TextStyle(
              color: Color(MyColors.purple01),
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Divider(),
          Row(
            //mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Location',
                style: kTitleStyle,
              ),
              Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/map', arguments: {"index":index});
                      },
                      child: Icon(Icons.fullscreen, color: Colors.white),
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(5),
                        backgroundColor: Color(MyColors.primary), // <-- Button color
                        foregroundColor: Colors.red, // <-- Splash color
                      ),
                    ),
                  )
              )
            ],
          ),
          SizedBox(
            height: 25,
          ),
          SizedBox(
            width: double.infinity,
            height: 200,
            child: GoogleMap( //Map widget from google_maps_flutter package
              zoomGesturesEnabled: true, //enable Zoom in, out on map
              initialCameraPosition: CameraPosition( //innital position in map
                target: showLocation, //initial position
                zoom: 15.0, //initial zoom level
              ),
              markers: getmarkers(), //markers to show on map
              mapType: MapType.normal, //map type
              onMapCreated: (controller) { //method called when map is created
                  mapController = controller;
              },
            ),
          ),
          SizedBox(
            height: 25,
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                Color(MyColors.primary),
              ),
            ),
            child: Text('Prendre un rendez-vous'),
            onPressed: () => {
              Networking.getRVAvailableByMedecin(global.allDoctors[index]['idmedecin'].toString()).then((resp){
                global.rvByMedecin=resp;
                Navigator.pushNamed(context, '/appointment', arguments: {"index": index});
              }),

            },
          )
        ],
      ),
    );
  }

}

class DoctorLocation extends StatelessWidget {
  const DoctorLocation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 200,
      child:Text('')
    );
  }
}

class DoctorInfo extends StatelessWidget {
  const DoctorInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        NumberCard(
          label: 'Patients',
          value: '100+',
        ),
        SizedBox(width: 15),
        NumberCard(
          label: 'Experiences',
          value: '10 years',
        ),
        SizedBox(width: 15),
        NumberCard(
          label: 'Rating',
          value: '4.0',
        ),
      ],
    );
  }
}

class AboutDoctor extends StatelessWidget {
  final String title;
  final String desc;
  const AboutDoctor({
    Key? key,
    required this.title,
    required this.desc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class NumberCard extends StatelessWidget {
  final String label;
  final String value;

  const NumberCard({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color(MyColors.bg03),
        ),
        padding: EdgeInsets.symmetric(
          vertical: 30,
          horizontal: 15,
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                color: Color(MyColors.grey02),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              value,
              style: TextStyle(
                color: Color(MyColors.header01),
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailDoctorCard extends StatelessWidget {
  dynamic json;
  DetailDoctorCard({Key? key,
    required this.json
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          padding: EdgeInsets.all(15),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dr. '+json['prenom']+' '+json['nom'],
                      style: TextStyle(
                          color: Color(MyColors.header01),
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      json['service']['nomservice'],
                      style: TextStyle(
                        color: Color(MyColors.grey02),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Image(
                image: NetworkImage(Networking.baseUrlImg+Networking.medecinDir+json['profil']),
                width: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}
