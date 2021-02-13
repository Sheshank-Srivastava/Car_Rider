import 'package:cab_rider/styles/styles.dart';
import 'package:cab_rider/widgets/BrandDivider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:cab_rider/brand_colors.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';

class MainPage extends StatefulWidget {
  static const String id = 'mainpage';

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  double searchSheetHeight = (Platform.isIOS) ? 300 : 275;
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;

  double mapButtonPadding = 0;

  static final CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(28.46579891433427, 77.0248626134921), zoom: 14.4746);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        drawer: Container(
          width: 250,
          color: Colors.white,
          child: Drawer(
            child: ListView(
              padding: EdgeInsets.all(0.0),
              children: [
                Container(
                    color: Colors.white,
                    height: 160,
                    child: DrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'images/user_icon.png',
                            height: 60,
                            width: 60,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Sheshank"),
                              SizedBox(height: 5.0),
                              Text("View Profile"),
                            ],
                          )
                        ],
                      ),
                    )),
                BrandDivider(),
                SizedBox(height: 10),
                ListTile(
                  leading: Icon(Icons.card_giftcard_outlined),
                  title: Text(
                    'Free Rides',
                    style: kDrawerItemStyle,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.credit_card_outlined),
                  title: Text(
                    'Payments',
                    style: kDrawerItemStyle,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.history),
                  title: Text(
                    'Ride History',
                    style: kDrawerItemStyle,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.contact_support),
                  title: Text(
                    'Support',
                    style: kDrawerItemStyle,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.info),
                  title: Text(
                    'About',
                    style: kDrawerItemStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Stack(
          children: [
            ///GoogleMap
            GoogleMap(
              padding: EdgeInsets.only(bottom: mapButtonPadding),
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                mapController = controller;
                setState(() {
                  mapButtonPadding = (Platform.isAndroid) ? 280 : 270;
                });
              },
            ),

            ///Menu Button
            Positioned(
              top: 44,
              left: 20,
              child: GestureDetector(
                onTap: () {
                  scaffoldKey.currentState.openDrawer();
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5.0,
                            spreadRadius: 0.5,
                            offset: Offset(0.7, 0.7))
                      ]),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                    child: Icon(
                      Icons.menu,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),

            ///Search sheet
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: searchSheetHeight,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 15.0,
                          spreadRadius: 0.5,
                          offset: Offset(0.7, 0.7))
                    ]),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Nice to see you!',
                            style: TextStyle(fontSize: 10.0),
                          ),
                          Text(
                            'Where are you going',
                            style: TextStyle(
                                fontSize: 18.0, fontFamily: 'Brand-Bold'),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 5.0,
                                      spreadRadius: 0.5,
                                      offset: Offset(0.7, 0.7))
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.search,
                                    color: Colors.blueAccent,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('Search Destiantion')
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4.0),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 5.0,
                                        spreadRadius: 0.2,
                                        offset: Offset(0.7, 0.7))
                                  ]),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.home_outlined,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Add Home',
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          'Your redidential address',
                                          style: TextStyle(
                                              fontSize: 11.0,
                                              color: BrandColors.colorDimText),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                          SizedBox(
                            height: 12,
                          ),
                          BrandDivider(),
                          SizedBox(height: 8),
                          Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4.0),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 5.0,
                                        spreadRadius: 0.2,
                                        offset: Offset(0.7, 0.7))
                                  ]),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.work_outline,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Add Work',
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          'Your office address',
                                          style: TextStyle(
                                              fontSize: 11.0,
                                              color: BrandColors.colorDimText),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
