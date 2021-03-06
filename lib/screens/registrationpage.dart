import 'package:cab_rider/brand_colors.dart';
import 'package:cab_rider/screens/mainpage.dart';
import 'package:cab_rider/widgets/ProgressDialog.dart';
import 'package:cab_rider/widgets/TaxiButton.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cab_rider/screens/loginpage.dart';
import 'package:flutter/services.dart';

class RegistrationPage extends StatefulWidget {
  static const String id = 'register';

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();

  void showSnackBar(String title) {
    final snackBar = SnackBar(
        content: Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 15.0),
    ));
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  var fullNameController = TextEditingController();

  var phoneController = TextEditingController();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  void registerUser() async {
    showDialog(
        context: context,
        builder: (BuildContext context) => ProgressDialog(
              status: "Registering you...",
            ),
        barrierDismissible: false);
    final UserCredential user = await _auth
        .createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .catchError((ex) {
      Navigator.pop(context);
      PlatformException thisEx = ex;
      showSnackBar(thisEx.message);
    });

    if (user != null) {
      DatabaseReference newUserRef =
          FirebaseDatabase.instance.reference().child('user/${user.user.uid}');

      Map userMap = {
        'fullname': fullNameController.text,
        'email': emailController.text,
        'phone': phoneController.text
      };

      newUserRef.set(userMap);
      Navigator.pushNamedAndRemoveUntil(context, MainPage.id, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Image(
                  alignment: Alignment.center,
                  height: 100.0,
                  width: 100.0,
                  image: AssetImage('images/logo.png'),
                ),
                SizedBox(height: 40),
                Text(
                  'Create a Rider\'s Account',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25.0, fontFamily: 'Brand-Bold'),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      //Full Name
                      TextField(
                        controller: fullNameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: 'Full name',
                            labelStyle: TextStyle(fontSize: 14.0),
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 10.0)),
                        style: TextStyle(fontSize: 14),
                      ),

                      SizedBox(height: 10),

                      //Email Address
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: 'Email Address',
                            labelStyle: TextStyle(fontSize: 14.0),
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 10.0)),
                        style: TextStyle(fontSize: 14),
                      ),

                      SizedBox(height: 10),

                      //Phone Number
                      TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            labelText: 'Mobile no.',
                            labelStyle: TextStyle(fontSize: 14.0),
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 10.0)),
                        style: TextStyle(fontSize: 14),
                      ),

                      SizedBox(height: 10),
                      //Password
                      TextField(
                        obscureText: true,
                        controller: passwordController,
                        decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(fontSize: 14.0),
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 10.0)),
                        style: TextStyle(fontSize: 14),
                      ),

                      SizedBox(
                        height: 30,
                      ),

                      TaxiButton(
                          color: BrandColors.colorBlue,
                          title: 'REGISTER',
                          onPressed: () async {
                            var connectivityResult =
                                await Connectivity().checkConnectivity();

                            if (connectivityResult !=
                                    ConnectivityResult.mobile &&
                                connectivityResult != ConnectivityResult.wifi) {
                              showSnackBar('No internet connection');
                              return;
                            }

                            if (fullNameController.text.length < 3) {
                              showSnackBar('Please provide a valid name');
                              return;
                            }
                            if (phoneController.text.length < 10) {
                              showSnackBar('Please provide valid phone number');
                              return;
                            }
                            if (!emailController.text.contains('@')) {
                              showSnackBar('Please provide valid email');
                              return;
                            }
                            if (passwordController.text.length < 8) {
                              showSnackBar(
                                  'Please keep password more than 8 characters');
                              return;
                            }
                            registerUser();
                          })
                    ],
                  ),
                ),
                //Route to login page
                FlatButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, LoginPage.id, (route) => false);
                    },
                    child: Text('Already have rider\'s account, Login')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
