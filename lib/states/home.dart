import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smarttourism/states/login.dart';
import 'package:smarttourism/states/screenRoute.dart';

final String noImageUrl =
    "https://firebasestorage.googleapis.com/v0/b/smarttourism-20178273.appspot.com/o/noImage.png?alt=media&token=d0c02cf1-3a51-4114-ab69-b1236552862f";
var loc;
var name;
var imgUrl;
var email;
var pNum;
var lat;
var lng;

final TextEditingController _locController = TextEditingController();

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final HomeScreenArgs data = ModalRoute
        .of(context)
        .settings
        .arguments;
    loc = data.location;
    name = data.userdata.name;
    imgUrl = data.userdata.imgUrl;
    email = data.userdata.email;
    pNum = data.userdata.pNum;

    var tabs = [
      PlaceTab(),
      EventTab(),
      MapTab(),
      Info(),
    ];

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        leadingWidth: 50,
        title: Text(
          'Welcome',
          textAlign: TextAlign.left,
        ),
        backgroundColor: Color(0xFF6200EA),
      ),
      drawer: Drawer(
        elevation: 1.0,
        child: Container(
          color: Color(0xCC6200EA),
          child: Column(children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF6200EA)),
              accountName: Text(data.userdata.name),
              accountEmail: Text(data.userdata.email),
              currentAccountPicture: CircleAvatar(
                radius: 30.0,
                backgroundImage: NetworkImage(data.userdata.imgUrl),
                backgroundColor: Colors.transparent,
              ),
            ),
            ListTile(
              title: Text('My Profile', style: TextStyle(color: Colors.white)),
              leading: Icon(Icons.account_box, color: Colors.white),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Profile()));
              },
            ),
            Divider(
              height: 3,
            ),
            ListTile(
              title: Text('Emergency', style: TextStyle(color: Colors.white)),
              leading: Icon(Icons.label_important, color: Colors.white),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Emergency()));
              },
            ),
            Divider(
              height: 3,
            ),
            ListTile(
              title: Text('Transport', style: TextStyle(color: Colors.white)),
              leading: Icon(Icons.emoji_transportation, color: Colors.white),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Transport()));
              },
            ),
            Divider(
              height: 3,
            ),
            ListTile(
              title:
              Text('Informations', style: TextStyle(color: Colors.white)),
              leading: Icon(Icons.info, color: Colors.white),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Information()));
              },
            ),
            Divider(
              height: 3,
            ),
            ListTile(
              title:
              Text('Accomodataion', style: TextStyle(color: Colors.white)),
              leading: Icon(Icons.home, color: Colors.white),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Accommodation()));
              },
            ),
            Divider(
              height: 3,
            ),
            ListTile(
              title:
              Text('Tour Assistant', style: TextStyle(color: Colors.white)),
              leading: Icon(Icons.assistant, color: Colors.white),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TourAssistant()));
              },
            ),
            Divider(
              height: 3,
            ),
            ListTile(
              title: Text('Sign Out', style: TextStyle(color: Colors.white)),
              leading: Icon(Icons.logout, color: Colors.white),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pop();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) =>
                        LogIn()), (Route<dynamic> route) => false);
              },
            ),
          ]),
        ),
      ),
      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
            canvasColor: Color(0xFF6200EA),
            primaryColor: Colors.white,
            textTheme: Theme
                .of(context)
                .textTheme
                .copyWith(caption: new TextStyle(color: Colors.white))),
        child: new BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.location_city, color: Colors.white),
                label: 'Places',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.event, color: Colors.white),
                label: 'Events',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.map, color: Colors.white),
                label: 'Map',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.info, color: Colors.white),
                label: 'Info',
              ),
            ],
            currentIndex: _selectedTab,
            selectedItemColor: Colors.amber[800],
            onTap: (int index) {
              setState(() {
                _selectedTab = index;
              });
            }),
      ),
      body: tabs.elementAt(_selectedTab),
    );
  }
}

class PlaceTab extends StatefulWidget {
  @override
  _PlaceTabState createState() => _PlaceTabState();
}

class _PlaceTabState extends State<PlaceTab> {
  Query attraction = FirebaseFirestore.instance.collection('Attractions');

  Widget loadingWindow() {
    return Container(
      child: Icon(Icons.error),
    );
  }

  Widget streamBuild<QuerySnapshot>() {
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF6200EA),
                  Color(0xDD6200EA),
                  Color(0xCC6200EA),
                  Color(0xDD6200EA),
                  Color(0xCC6200EA),
                  Color(0xDD6200EA),
                  Color(0xCC6200EA),
                  Color(0xFF6200EA),
                ])),
        child: StreamBuilder(
            stream: attraction
                .where("District", isEqualTo: loc.toString())
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return loadingWindow();
              }
              final List name = snapshot.data.documents
                  .map<String>((doc) => (doc.data()['Name']).toString())
                  .toList();
              final List address = snapshot.data.documents
                  .map<String>((doc) => (doc.data()['Address']).toString())
                  .toList();
              final List url = snapshot.data.documents
                  .map<String>((doc) => (doc.data()['ImgUrl']).toString())
                  .toList();
              final List uid = snapshot.data.documents
                  .map<String>((doc) => (doc.id.toString()))
                  .toList();

              return ListView.builder(
                  itemCount: name.length,
                  itemExtent: 180,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: <Widget>[
                        new Container(
                          alignment: Alignment.topCenter,
                          padding: new EdgeInsets.only(
                              top: MediaQuery
                                  .of(context)
                                  .size
                                  .width * .05,
                              right: 0,
                              left: 5),
                          child: new Container(
                            height: MediaQuery
                                .of(context)
                                .size
                                .width * .30,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0x55D1C4E9),
                                      Color(0x99D1C4E9),
                                      Color(0x99D1C4E9),
                                      Color(0x99D1C4E9),
                                      Color(0x99D1C4E9),
                                      Color(0x99D1C4E9),
                                      Color(0x99D1C4E9),
                                      Color(0x55D1C4E9),
                                    ]),
                                border: Border.all(width: 1),
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                        new Container(
                          alignment: Alignment.topLeft,
                          padding:
                          new EdgeInsets.only(top: 0, right: 20.0, left: 0),
                          child: new Container(
                            height: MediaQuery
                                .of(context)
                                .size
                                .width * .40,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * .40,
                            child: new Card(
                              elevation: 50,
                              child: Image.network(
                                url.elementAt(index),
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height,
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                fit: BoxFit.fill,
                              ),
                              color: Colors.white10,
                            ),
                          ),
                        ),
                        InkWell(
                          child: new Container(
                              alignment: Alignment.topRight,
                              padding: new EdgeInsets.only(
                                  top: MediaQuery
                                      .of(context)
                                      .size
                                      .width * .06,
                                  right:
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .width * .015,
                                  left: 0),
                              child: new Container(
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .width * .28,
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * .53,
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height:
                                      MediaQuery
                                          .of(context)
                                          .size
                                          .width *
                                          .15,
                                      width:
                                      MediaQuery
                                          .of(context)
                                          .size
                                          .width *
                                          .6,
                                      child: Text(
                                        name.elementAt(index),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontFamily: "Times New Roman",
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    SizedBox(
                                      height:
                                      MediaQuery
                                          .of(context)
                                          .size
                                          .width *
                                          .12,
                                      width:
                                      MediaQuery
                                          .of(context)
                                          .size
                                          .width *
                                          .6,
                                      child: Text(
                                        address.elementAt(index),
                                        style: TextStyle(
                                          fontFamily: "Times New Roman",
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          onTap: () {
                            print(uid.elementAt(index));
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ExpandedPlaceView(),
                                    settings: RouteSettings(
                                      arguments: uid.elementAt(index),
                                    )));
                          },
                        )
                      ],
                    );
                  });
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0x336200EA), body: Center(child: streamBuild()));
  }
}

class ExpandedPlaceView extends StatefulWidget {
  @override
  _ExpandedPlaceViewState createState() => _ExpandedPlaceViewState();
}

class _ExpandedPlaceViewState extends State<ExpandedPlaceView> {
  Future<QuerySnapshot> snapshot;

  final TextEditingController _locName = TextEditingController();
  final TextEditingController _contactNumber = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _category = TextEditingController();
  GeoPoint location;
  var imgUrl;

  Widget loadingWindow() {
    return Container(
      child: Icon(Icons.error),
    );
  }

  Widget modelBuild() {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            _locName.text,
            style: TextStyle(fontFamily: "Times New Roman"),
          ),
          backgroundColor: Color(0xFF6200EA),
          shadowColor: Color(0xFF6200EA),
        ),
        body: Container(
            padding: EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 0),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF6200EA),
                      Color(0xDD6200EA),
                      Color(0xAA6200EA),
                      Color(0x776200EA),
                      Color(0x556200EA),
                      Color(0x336200EA),
                    ])),
            alignment: Alignment.center,
            child: ListView(children: <Widget>[
              Container(
                child: Image.network(
                  imgUrl,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * .3,
                ),
              ),
              Container(
                height: 60,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * .25,
                        child: Text(
                          "Name : ",
                          textAlign: TextAlign.left,
                          softWrap: true,
                          style: TextStyle(
                            wordSpacing: 2,
                            fontFamily: "Times New Roman",
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * .70,
                        child: TextFormField(
                          maxLines: 2,
                          enabled: false,
                          controller: _locName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Times New Roman",
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(bottom: 5),
                          ),
                        )),
                  ],
                ),
              ),
              Container(
                height: 40,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * .25,
                        child: Text(
                          "Phone No: ",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            wordSpacing: 2,
                            fontFamily: "Times New Roman",
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * .70,
                        child: TextFormField(
                          enabled: false,
                          controller: _contactNumber,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Times New Roman",
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(bottom: 5),
                          ),
                        )),
                  ],
                ),
              ),
              Container(
                height: 60,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * .25,
                        child: Text(
                          "Address : ",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            wordSpacing: 2,
                            fontFamily: "Times New Roman",
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * .70,
                        child: TextFormField(
                          enabled: false,
                          controller: _address,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Times New Roman",
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(bottom: 5),
                          ),
                        )),
                  ],
                ),
              ),
              Container(
                height: 40,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * .25,
                        child: Text(
                          "District : ",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            wordSpacing: 2,
                            fontFamily: "Times New Roman",
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * .70,
                        child: Text(
                          loc,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Times New Roman",
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        )),
                  ],
                ),
              ),
              Container(
                height: 40,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * .25,
                        child: Text(
                          "Category: ",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            wordSpacing: 2,
                            fontFamily: "Times New Roman",
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * .70,
                        child: TextFormField(
                          enabled: false,
                          controller: _category,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Times New Roman",
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(bottom: 5),
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Center(
                child: FlatButton(
                  height: 50,
                  minWidth: MediaQuery
                      .of(context)
                      .size
                      .width * .4,
                  color: Color(0xDD6200EA),
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ViewOnMap()));
                  },
                  child: Text(
                    "View on map",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Times New Roman",
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              )
            ])));
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference attraction =
    FirebaseFirestore.instance.collection('Attractions');
    final String id = ModalRoute
        .of(context)
        .settings
        .arguments;
    return FutureBuilder<DocumentSnapshot>(
      future: attraction.doc(id).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          _locName.text = snapshot.data["Name"].toString();
          _address.text = snapshot.data["Address"].toString();
          _category.text = snapshot.data["Category"].toString();
          _contactNumber.text = snapshot.data["Contact Number"].toString();
          imgUrl = snapshot.data["ImgUrl"].toString();
          location = snapshot.data["Location"];
          lat = location.latitude;
          lng = location.longitude;
        }

        if (imgUrl != null) {
          return modelBuild();
        }

        return loadingWindow();
      },
    );
  }
}

class EventTab extends StatefulWidget {
  @override
  _EventTabState createState() => _EventTabState();
}

class _EventTabState extends State<EventTab> {
  CollectionReference events = FirebaseFirestore.instance.collection('Events');

  Widget loadingWindow() {
    return Container(
      child: Icon(Icons.error),
    );
  }

  Widget streamBuild<QuerySnapshot>() {
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF6200EA),
                  Color(0xDD6200EA),
                  Color(0xCC6200EA),
                  Color(0xDD6200EA),
                  Color(0xCC6200EA),
                  Color(0xDD6200EA),
                  Color(0xCC6200EA),
                  Color(0xFF6200EA),
                ])),
        child: StreamBuilder(
            stream:
            events.doc(loc.toString()).collection('Details').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return loadingWindow();
              }
              final List owner = snapshot.data.documents
                  .map<String>((doc) => (doc.data()['OwnerName']).toString())
                  .toList();
              final List name = snapshot.data.documents
                  .map<String>((doc) => (doc.data()['Name']).toString())
                  .toList();
              final List date = snapshot.data.documents
                  .map<String>((doc) => (doc.data()['Date']).toString())
                  .toList();
              final List address = snapshot.data.documents
                  .map<String>((doc) => (doc.data()['Address']).toString())
                  .toList();
              final List url = snapshot.data.documents
                  .map<String>((doc) => (doc.data()['ImgUrl']).toString())
                  .toList();
              final List id = snapshot.data.documents
                  .map<String>((doc) => (doc.id.toString()))
                  .toList();
              return ListView.builder(
                  itemCount: name.length,
                  itemExtent: 180,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: <Widget>[
                        new Container(
                          alignment: Alignment.topCenter,
                          padding: new EdgeInsets.only(
                              top: MediaQuery
                                  .of(context)
                                  .size
                                  .width * .05,
                              right: 0,
                              left: 5),
                          child: new Container(
                            height: MediaQuery
                                .of(context)
                                .size
                                .width * .30,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0x55D1C4E9),
                                      Color(0x99D1C4E9),
                                      Color(0x99D1C4E9),
                                      Color(0x99D1C4E9),
                                      Color(0x99D1C4E9),
                                      Color(0x99D1C4E9),
                                      Color(0x99D1C4E9),
                                      Color(0x55D1C4E9),
                                    ]),
                                border: Border.all(width: 1),
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                        new Container(
                          alignment: Alignment.topLeft,
                          padding:
                          new EdgeInsets.only(top: 0, right: 20.0, left: 0),
                          child: new Container(
                            height: MediaQuery
                                .of(context)
                                .size
                                .width * .40,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * .40,
                            child: new Card(
                              elevation: 50,
                              child: Image.network(
                                url.elementAt(index),
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height,
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          child: new Container(
                              alignment: Alignment.topRight,
                              padding: new EdgeInsets.only(
                                  top: MediaQuery
                                      .of(context)
                                      .size
                                      .width * .06,
                                  right:
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .width * .015,
                                  left: 0),
                              child: new Container(
                                alignment: Alignment.centerLeft,
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .width * .28,
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * .53,
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height:
                                      MediaQuery
                                          .of(context)
                                          .size
                                          .width *
                                          .12,
                                      width:
                                      MediaQuery
                                          .of(context)
                                          .size
                                          .width *
                                          .6,
                                      child: Text(
                                        name.elementAt(index),
                                        style: TextStyle(
                                          fontFamily: "Times New Roman",
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    SizedBox(
                                      height:
                                      MediaQuery
                                          .of(context)
                                          .size
                                          .width *
                                          .06,
                                      width:
                                      MediaQuery
                                          .of(context)
                                          .size
                                          .width *
                                          .6,
                                      child: Text(
                                        address.elementAt(index) +
                                            " \t" +
                                            date.elementAt(index),
                                        style: TextStyle(
                                          fontFamily: "Times New Roman",
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    SizedBox(
                                      height:
                                      MediaQuery
                                          .of(context)
                                          .size
                                          .width *
                                          .06,
                                      width:
                                      MediaQuery
                                          .of(context)
                                          .size
                                          .width *
                                          .6,
                                      child: Text(
                                        "by : " + owner.elementAt(index),
                                        style: TextStyle(
                                          fontFamily: "Times New Roman",
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ExpandedEventView(),
                                    settings: RouteSettings(
                                      arguments: id.elementAt(index),
                                    )));
                          },
                        )
                      ],
                    );
                  });
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0x336200EA),
        body: Stack(
          children: [
            Center(child: streamBuild()),
            Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.only(top: 0, right: 10, left: 0, bottom: 10),
              child: new Container(
                alignment: Alignment.center,
                height: MediaQuery
                    .of(context)
                    .size
                    .width * .15,
                width: MediaQuery
                    .of(context)
                    .size
                    .width * .15,
                decoration: new BoxDecoration(
                  color: Color(0x55D1C4E9),
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.add,
                    size: 30,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => NewEvent()));
                  },
                ),
              ),
            ),
          ],
        ));
  }
}

class ExpandedEventView extends StatefulWidget {
  @override
  _ExpandedEventViewState createState() => _ExpandedEventViewState();
}

class _ExpandedEventViewState extends State<ExpandedEventView> {
  Future<QuerySnapshot> snapshot;

  final TextEditingController _eventName = TextEditingController();
  final TextEditingController _contactNumber = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _date = TextEditingController();
  final TextEditingController _time = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _owner = TextEditingController();
  GeoPoint location;
  var imgUrl;

  Widget loadingWindow() {
    return Container(
      child: Icon(Icons.error),
    );
  }

  Widget modelBuild() {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            _eventName.text,
            style: TextStyle(fontFamily: "Times New Roman"),
          ),
          backgroundColor: Color(0xFF6200EA),
          shadowColor: Color(0xFF6200EA),
        ),
        body: Container(
            padding: EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 0),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF6200EA),
                      Color(0xDD6200EA),
                      Color(0xAA6200EA),
                      Color(0x776200EA),
                      Color(0x556200EA),
                      Color(0x336200EA),
                    ])),
            alignment: Alignment.center,
            child: ListView(children: <Widget>[
              Container(
                child: Image.network(
                  imgUrl,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * .3,
                ),
              ),
              Container(
                height: 40,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * .30,
                        child: Text(
                          "Added by: ",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            wordSpacing: 2,
                            fontFamily: "Times New Roman",
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * .65,
                        child: TextFormField(
                          enabled: false,
                          controller: _owner,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Times New Roman",
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(bottom: 5),
                          ),
                        )),
                  ],
                ),
              ),
              Container(
                height: 40,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * .30,
                        child: Text(
                          "Name : ",
                          textAlign: TextAlign.left,
                          softWrap: true,
                          style: TextStyle(
                            wordSpacing: 2,
                            fontFamily: "Times New Roman",
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * .65,
                        child: TextFormField(
                          maxLength: 200,
                          enabled: false,
                          controller: _eventName,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Times New Roman",
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(bottom: 5),
                          ),
                        )),
                  ],
                ),
              ),
              Container(
                height: 40,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * .30,
                        child: Text(
                          "Phone No: ",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            wordSpacing: 2,
                            fontFamily: "Times New Roman",
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * .65,
                        child: TextFormField(
                          enabled: false,
                          controller: _contactNumber,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Times New Roman",
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(bottom: 5),
                          ),
                        )),
                  ],
                ),
              ),
              Container(
                height: 40,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * .30,
                        child: Text(
                          "Address : ",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            wordSpacing: 2,
                            fontFamily: "Times New Roman",
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * .65,
                        child: TextFormField(
                          enabled: false,
                          controller: _address,
                          textAlign: TextAlign.left,
                          maxLength: 300,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Times New Roman",
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(bottom: 0),
                          ),
                        )),
                  ],
                ),
              ),
              Container(
                height: 40,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * .30,
                        child: Text(
                          "District : ",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            wordSpacing: 2,
                            fontFamily: "Times New Roman",
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * .65,
                        child: Text(
                          loc,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Times New Roman",
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        )),
                  ],
                ),
              ),
              Container(
                height: 40,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * .30,
                        child: Text(
                          "Date: ",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            wordSpacing: 2,
                            fontFamily: "Times New Roman",
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * .65,
                        child: TextFormField(
                          enabled: false,
                          controller: _date,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Times New Roman",
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(bottom: 5),
                          ),
                        )),
                  ],
                ),
              ),
              Container(
                height: 40,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * .30,
                        child: Text(
                          "Time: ",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            wordSpacing: 2,
                            fontFamily: "Times New Roman",
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * .65,
                        child: TextFormField(
                          enabled: false,
                          controller: _time,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Times New Roman",
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(bottom: 5),
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 100,
                child: Row(
                  children: <Widget>[
                    Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * .30,
                        alignment: Alignment.topCenter,
                        child: Text(
                          "Description: ",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            wordSpacing: 2,
                            fontFamily: "Times New Roman",
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * .65,
                        child: TextFormField(
                          enabled: false,
                          controller: _description,
                          textAlign: TextAlign.left,
                          maxLength: 128,
                          maxLines: 10,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Times New Roman",
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(bottom: 10),
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.all(5),
                child: Center(
                  child: FlatButton(
                    height: 50,
                    minWidth: MediaQuery
                        .of(context)
                        .size
                        .width * .4,
                    color: Color(0xDD6200EA),
                    padding: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ViewOnMap()));
                    },
                    child: Text(
                      "View on map",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Times New Roman",
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ),
              )
            ])));
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference attraction = FirebaseFirestore.instance
        .collection('Events')
        .doc(loc)
        .collection('Details');
    final String id = ModalRoute
        .of(context)
        .settings
        .arguments;
    return FutureBuilder<DocumentSnapshot>(
      future: attraction.doc(id).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          _eventName.text = snapshot.data["Name"].toString();
          _address.text = snapshot.data["Address"].toString();
          _contactNumber.text = snapshot.data["Contact Number"].toString();
          _date.text = snapshot.data["Date"].toString();
          _time.text = snapshot.data["Time"].toString();
          _description.text = snapshot.data["Description"].toString();
          _owner.text = snapshot.data["OwnerName"].toString();
          imgUrl = snapshot.data["ImgUrl"].toString();
          location = snapshot.data["Location"];
          lat = location.latitude;
          lng = location.longitude;
          print(lat.toString() + " " + lng.toString());
        }

        if (imgUrl != null) {
          return modelBuild();
        }

        return loadingWindow();
      },
    );
  }
}

class ViewOnMap extends StatefulWidget {
  @override
  _ViewOnMapState createState() => _ViewOnMapState();
}

class _ViewOnMapState extends State<ViewOnMap> {
  Completer<GoogleMapController> _controller = Completer();

  final Set<Marker> _markers = {};

  LatLng _lastMapPosition = LatLng(lat, lng);

  MapType _currentMapType = MapType.normal;

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  void _addMarker() {
    setState(() {
      _markers.clear();
      _markers.add(Marker(
        draggable: true,
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        infoWindow: InfoWindow(
          title: _lastMapPosition.toString(),
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    _addMarker();
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(lat, lng),
              zoom: 10,
            ),
            mapType: _currentMapType,
            markers: _markers,
            onCameraMove: _onCameraMove,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Align(
              alignment: Alignment.topRight,
              child: Column(
                children: <Widget>[
                  FloatingActionButton(
                    heroTag: 'MapChange',
                    onPressed: _onMapTypeButtonPressed,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    backgroundColor: Color(0xCC6200EA),
                    child: const Icon(Icons.map, size: 36.0),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                children: <Widget>[
                  FloatingActionButton(
                    heroTag: 'MapChange2',
                    onPressed: () {
                      _markers.clear();
                      Navigator.pop(context);
                    },
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    backgroundColor: Color(0xCC6200EA),
                    child: const Icon(Icons.arrow_back, size: 36.0),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}

class MapTab extends StatefulWidget {
  @override
  _MapTabState createState() => _MapTabState();
}

class _MapTabState extends State<MapTab> {
  var latitude = 8.7542009;
  var longitude = 80.4982424;

  Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = const LatLng(8.7542009, 80.4982424);

  final Set<Marker> _markers = {};

  LatLng _lastMapPosition = _center;

  MapType _currentMapType = MapType.normal;

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  void _onAddMarkerButtonPressed() {
    setState(() {
      _markers.clear();
      _markers.add(Marker(
        draggable: true,
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        infoWindow: InfoWindow(
          title: _lastMapPosition.toString(),
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
            mapType: _currentMapType,
            markers: _markers,
            onCameraMove: _onCameraMove,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.topRight,
              child: Column(
                children: <Widget>[
                  FloatingActionButton(
                    heroTag: 'MapChange',
                    onPressed: _onMapTypeButtonPressed,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    backgroundColor: Color(0xCC6200EA),
                    child: const Icon(Icons.map, size: 36.0),
                  ),
                  SizedBox(height: 16.0),
                  FloatingActionButton(
                    heroTag: 'Marker',
                    onPressed: _onAddMarkerButtonPressed,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    backgroundColor: Color(0xCC6200EA),
                    child: const Icon(Icons.add_location, size: 36.0),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  locationCall(latitude, longitude) {
    _goToLocation(latitude, longitude);
  }

  Future<void> _goToLocation(latitude, longitude) async {
    double _zoom = 10;
    this.latitude = latitude;
    this.longitude = longitude;
    double lat = latitude;
    double long = -longitude;
    GoogleMapController controller = await _controller.future;
    controller
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, long), _zoom));
  }
}

class Info extends StatefulWidget {
  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0x336200EA),
        body: Center(
            child: Container(
              color: Colors.white,
              child: Center(
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 80, left: 10, right: 10),
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.75,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.75,
                  color: Color(0xFF6200EA),
                  child: Column(
                    children: [
                      Text(
                        "Team Rex ",
                        style: TextStyle(
                          wordSpacing: 2,
                          fontFamily: "Times New Roman",
                          fontSize: 35,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Software engineering Design Project 2020",
                        style: TextStyle(
                          wordSpacing: 2,
                          fontFamily: "Times New Roman",
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.call,
                            size: 30,
                          ),
                          Text(
                            "   0786559104",
                            style: TextStyle(
                              wordSpacing: 2,
                              fontFamily: "Times New Roman",
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.email,
                            size: 30,
                          ),
                          Text(
                            "   2017E082@eng.jfn.ac.lk",
                            style: TextStyle(
                              wordSpacing: 2,
                              fontFamily: "Times New Roman",
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.email,
                            size: 30,
                          ),
                          Text(
                            "   2017E073@eng.jfn.ac.lk",
                            style: TextStyle(
                              wordSpacing: 2,
                              fontFamily: "Times New Roman",
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }
}

class NewEvent extends StatefulWidget {
  @override
  _NewEventState createState() => _NewEventState();
}

class _NewEventState extends State<NewEvent> {
  var info;
  CollectionReference event = FirebaseFirestore.instance
      .collection('Events')
      .doc(loc)
      .collection('Details');

  FirebaseStorage storage = FirebaseStorage.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _desController = TextEditingController();
  final TextEditingController _conNoController = TextEditingController();
  final TextEditingController _notificationController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  File image;

  Future<void> uploadWithImg(name) async {
    String downloadURL =
    await FirebaseStorage.instance.ref('Event/$name.jpg').getDownloadURL();
    event
        .doc(name)
        .update({
      'ImgUrl': downloadURL,
    })
        .then((value) => _notificationController.text = "Event Added")
        .catchError((error) =>
    _notificationController.text = "Failed to add event: $error");
    Navigator.pop(context);
  }

  Future uploadPic(name) async {
    _notificationController.clear();

    if (image != null) {
      Reference ref = storage.ref().child('Event/$name.jpg');
      UploadTask uploadTask = ref.putFile(image);
      uploadTask.then((res) {
        uploadWithImg(name);
      });
      uploadTask.catchError((error) {
        _notificationController.text = 'Unable to Upload Image $error';
      });
    } else {
      event
          .doc(name)
          .update({
        'ImgUrl': noImageUrl,
      })
          .then((value) => _notificationController.text = "Event Added")
          .catchError((error) =>
      _notificationController.text = "Failed to add event: $error");
      Navigator.pop(context);
    }
  }

  _imgFromCamera() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 800,
      maxHeight: 800,
    );
    if (pickedFile != null) {
      image = File(pickedFile.path);
    }
  }

  _imgFromGallery() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
    );

    setState(() {
      image = File(pickedFile.path);
    });
  }

  Widget showImg() {
    var val = MediaQuery
        .of(context)
        .size
        .width;
    if (image != null) {
      return Image.file(image);
    }
    return Container(
      padding: EdgeInsets.only(
          top: val * .1, left: val * .1, right: val * .1, bottom: val * .1),
      color: Colors.white60,
      child: Column(
        children: [
          Container(
              height: 150,
              width: 150,
              child: Icon(
                Icons.file_upload,
                size: 120,
                color: Colors.black,
              )),
          Text(
            "Upload Image",
            style: TextStyle(
              fontSize: 18,
              fontFamily: "Times New Roman",
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }



  Future<void> addEvent() async {
    _notificationController.clear();
    if (!(_nameController.text.isEmpty ||
        _dateController.text.isEmpty ||
        _timeController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _conNoController.text.isEmpty ||
        _desController.text.isEmpty)) {
      var long = double.parse(_locController.text.split(", ")[1]);
      var lat = double.parse(_locController.text.split(", ")[0]);
      event.add({
        'Location': GeoPoint(lat, long),
        'Date': _dateController.text,
        'Description': _desController.text,
        'District': loc,
        'Address': _addressController.text,
        'Name': _nameController.text,
        'Contact Number': _conNoController.text,
        'OwnerID': FirebaseAuth.instance.currentUser.uid,
        'OwnerName': name,
        'Time': _timeController.text,
      }).then((value) {
        uploadPic(value.id);
      }).catchError((error) => info = "Failed to add Event $error");
    } else {
      info = "Fill all the required fields";
    }
    _notificationController.text = info;
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        // Refer step 1
        firstDate: DateTime(2000),
        lastDate: DateTime(2025),
        builder: (context, child) {
          return Theme(
            data: ThemeData.dark(),
            child: child,
          );
        });
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _dateController.text = selectedDate.toString().split(' ')[0];
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _timeController.text =
        selectedTime.toString().split("(")[1].split(")")[0];
      });
  }

  Widget _uploadImageWindow(BuildContext context) {
    return new AlertDialog(
      title: const Text('Choose from '),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            _imgFromGallery();
            Navigator.of(context).pop();
          },
          textColor: Theme
              .of(context)
              .primaryColor,
          child: const Text('Gallary'),
        ),
        new FlatButton(
          onPressed: () {
            _imgFromCamera();
            Navigator.of(context).pop();
          },
          textColor: Theme
              .of(context)
              .primaryColor,
          child: const Text('Camera'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Add New Event",
            style: TextStyle(fontFamily: "Times New Roman"),
          ),
          backgroundColor: Color(0xFF6200EA),
          shadowColor: Color(0xFF6200EA),
        ),
        body: Container(
            padding: EdgeInsets.only(top: 0, right: 5, left: 5, bottom: 40),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF6200EA),
                      Color(0xAA6200EA),
                      Color(0x996200EA),
                      Color(0x886200EA),
                      Color(0x556200EA),
                      Color(0x116200EA),
                    ])),
            alignment: Alignment.center,
            child: ListView(children: <Widget>[
              Container(
                height: 60,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * .30,
                        child: Text(
                          "Name : ",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            wordSpacing: 2,
                            fontFamily: "Times New Roman",
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    Container(
                        height: 50,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * .60,
                        child: TextFormField(
                          controller: _nameController,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Times New Roman",
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        )),
                  ],
                ),
              ),
              Container(
                height: 60,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * .30,
                        child: Text(
                          "Phone No :",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            wordSpacing: 2,
                            fontFamily: "Times New Roman",
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    Container(
                        height: 50,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * .60,
                        child: TextFormField(
                          controller: _conNoController,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Times New Roman",
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        )),
                  ],
                ),
              ),
              Container(
                height: 60,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * .30,
                        child: Text(
                          "Date : ",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            wordSpacing: 2,
                            fontFamily: "Times New Roman",
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    Container(
                        height: 50,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * .50,
                        child: TextFormField(
                          controller: _dateController,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Times New Roman",
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        )),
                    Container(
                      child: IconButton(
                        icon: Icon(
                          Icons.date_range,
                          size: 40,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          _selectDate(context);
                        },
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 60,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * .30,
                        child: Text(
                          "Time : ",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            wordSpacing: 2,
                            fontFamily: "Times New Roman",
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    Container(
                        height: 50,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * .50,
                        child: TextFormField(
                          controller: _timeController,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "Times New Roman",
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        )),
                    Container(
                      child: IconButton(
                        icon: Icon(
                          Icons.access_time,
                          size: 40,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          _selectTime(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 60,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * .30,
                        child: Text(
                          "Lane :",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            wordSpacing: 2,
                            fontFamily: "Times New Roman",
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    Container(
                        height: 50,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * .60,
                        child: TextFormField(
                          controller: _addressController,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Times New Roman",
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        )),
                  ],
                ),
              ),
              Container(
                height: 60,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * .30,
                        child: Text(
                          "City :",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            wordSpacing: 2,
                            fontFamily: "Times New Roman",
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    Container(
                        height: 50,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * .60,
                        alignment: Alignment.center,
                        child: Text(
                          loc,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontFamily: "Times New Roman",
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        )),
                  ],
                ),
              ),
              Container(
                height: 60,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * .30,
                        child: Text(
                          "Location :",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            wordSpacing: 2,
                            fontFamily: "Times New Roman",
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    Container(
                        height: 60,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * .50,
                        child: TextFormField(
                          controller: _locController,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Times New Roman",
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        )),
                    IconButton(
                      icon: Icon(
                        Icons.location_on,
                        color: Colors.black,
                      ),
                      iconSize: 40,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LocationView()));
                      },
                    ),
                  ],
                ),
              ),
              Container(
                height: 120,
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 100,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * .30,
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.only(top: 10),
                      child: SizedBox(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * .70,
                          child: Text(
                            "Description :",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              wordSpacing: 2,
                              fontFamily: "Times New Roman",
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    ),
                    Container(
                        height: 110,
                        width: 250,
                        child: TextField(
                          controller: _desController,
                          maxLength: 128,
                          maxLines: 10,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "Times New Roman",
                              color: Colors.black,
                              fontSize: 15),
                        )),
                  ],
                ),
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        _uploadImageWindow(context),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent),
                  ),
                  height: MediaQuery
                      .of(context)
                      .size
                      .width * .8,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * .8,
                  child: showImg(),
                ),
              ),
              SizedBox(
                child: TextField(
                  controller: _notificationController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
              Container(
                height: 50,
                alignment: Alignment.center,
                width: double.infinity,
                child: FlatButton(
                  height: 50,
                  minWidth: MediaQuery
                      .of(context)
                      .size
                      .width * .4,
                  color: Color(0xDD6200EA),
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onPressed: () {
                    addEvent();
                  },
                  child: Text(
                    "Add Event",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Times New Roman",
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
              ),
            ])));
  }
}

class LocationView extends StatefulWidget {
  static const LatLng _center = const LatLng(8.7542009, 80.4982424);

  @override
  _LocationViewState createState() => _LocationViewState();
}

class _LocationViewState extends State<LocationView> {
  var latitude = 8.7542009;

  var longitude = 80.4982424;

  Completer<GoogleMapController> _controller = Completer();

  final Set<Marker> _markers = {};

  LatLng _lastMapPosition = LocationView._center;

  MapType _currentMapType = MapType.normal;

  void _onAddMarkerButtonPressed() {
    setState(() {
      _markers.clear();
      _markers.add(Marker(
        draggable: true,
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        infoWindow: InfoWindow(
          title: _lastMapPosition.toString(),
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
      _locController.text =
      _lastMapPosition.toString().split("(")[1].split(")")[0];
    });
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LocationView._center,
              zoom: 11.0,
            ),
            mapType: _currentMapType,
            markers: _markers,
            onCameraMove: _onCameraMove,
          ),
          Padding(
            padding:
            const EdgeInsets.only(top: 30, left: 30, right: 10, bottom: 30),
            child: Align(
              alignment: Alignment.topRight,
              child: Column(
                children: <Widget>[
                  FloatingActionButton(
                    heroTag: 'Marker',
                    onPressed: _onAddMarkerButtonPressed,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    backgroundColor: Color(0xCC6200EA),
                    child: const Icon(Icons.add_location, size: 36.0),
                  ),
                  SizedBox(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * .10,
                  ),
                  FloatingActionButton(
                    heroTag: 'Conform',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    backgroundColor: Color(0xCC6200EA),
                    child: const Icon(Icons.check, size: 36.0),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    if (pNum == null) {
      pNum = '-';
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "My Profile",
            style: TextStyle(fontFamily: "Times New Roman"),
          ),
          backgroundColor: Color(0xFF6200EA),
          shadowColor: Color(0xFF6200EA),
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x556200EA),
                    Color(0x666200EA),
                    Color(0x776200EA),
                    Color(0x886200EA),
                    Color(0x996200EA),
                    Color(0xAA6200EA),
                  ])),
          alignment: Alignment.center,
          padding:
          EdgeInsets.only(top: MediaQuery
              .of(context)
              .size
              .height * .10),
          child: Column(children: <Widget>[
            Image(
              image: NetworkImage(imgUrl),
              height: MediaQuery
                  .of(context)
                  .size
                  .height * .40,
              width: MediaQuery
                  .of(context)
                  .size
                  .height * .40,
              fit: BoxFit.fitHeight,
            ),
            SizedBox(height: MediaQuery
                .of(context)
                .size
                .height * .08),
            Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(right: 20, left: 20),
                  child: Text(
                    "Full Name : " + name,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        fontFamily: "Times New Roman"),
                  ),
                ),
                SizedBox(height: MediaQuery
                    .of(context)
                    .size
                    .height * .02),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(right: 20, left: 20),
                  child: Text(
                    "Email : " + email,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        fontFamily: "Times New Roman"),
                  ),
                ),
                SizedBox(height: MediaQuery
                    .of(context)
                    .size
                    .height * .02),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(right: 20, left: 20),
                  child: Text(
                    "Contact Number : " + pNum,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        fontFamily: "Times New Roman"),
                  ),
                ),
                SizedBox(height: MediaQuery
                    .of(context)
                    .size
                    .height * .05),
                Container(
                  width: 150,
                  decoration: BoxDecoration(
                      color: Color(0x556200EA),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(color: Color(0xFF6200EA), spreadRadius: 1),
                      ]),
                  child: FlatButton(
                    onPressed: () {},
                    child: Text(
                      'Update',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontFamily: "Times New Roman",
                        color: Colors.black,
                      ),
                    ),
                  ),
                )
              ],
            )
          ]),
        ));
  }
}

class Emergency extends StatefulWidget {
  @override
  _EmergencyState createState() => _EmergencyState();
}

class _EmergencyState extends State<Emergency> {
  Widget soon() {
    return Center(
      child: Text(
        'Comming Soon',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: "Times New Roman",
          color: Colors.white,
          fontSize: 25,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF6200EA),
          title: Text('Transport'),
        ),
        backgroundColor: Color(0x556200EA),
        body: Center(child: soon()));
  }
}

class Transport extends StatefulWidget {
  @override
  _TransportState createState() => _TransportState();
}

class _TransportState extends State<Transport> {
  Widget soon() {
    return Center(
      child: Text(
        'Comming Soon',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: "Times New Roman",
          color: Colors.white,
          fontSize: 25,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF6200EA),
          title: Text('Transport'),
        ),
        backgroundColor: Color(0x556200EA),
        body: Center(child: soon()));
  }
}

class Information extends StatefulWidget {
  @override
  _InformationState createState() => _InformationState();
}

class _InformationState extends State<Information> {
  Widget soon() {
    return Center(
      child: Text(
        'Comming Soon',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: "Times New Roman",
          color: Colors.white,
          fontSize: 25,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF6200EA),
          title: Text('Transport'),
        ),
        backgroundColor: Color(0x556200EA),
        body: Center(child: soon()));
  }
}

class Accommodation extends StatefulWidget {
  @override
  _AccommodationState createState() => _AccommodationState();
}

class _AccommodationState extends State<Accommodation> {
  Widget soon() {
    return Center(
      child: Text(
        'Comming Soon',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: "Times New Roman",
          color: Colors.white,
          fontSize: 25,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF6200EA),
          title: Text('Transport'),
        ),
        backgroundColor: Color(0x556200EA),
        body: Center(child: soon()));
  }
}

class TourAssistant extends StatefulWidget {
  @override
  _TourAssistantState createState() => _TourAssistantState();
}

class _TourAssistantState extends State<TourAssistant> {
  Widget soon() {
    return Center(
      child: Text(
        'Comming Soon',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: "Times New Roman",
          color: Colors.white,
          fontSize: 25,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF6200EA),
          title: Text('Transport'),
        ),
        backgroundColor: Color(0x556200EA),
        body: Center(child: soon()));
  }
}
