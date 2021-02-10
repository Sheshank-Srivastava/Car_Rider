import 'package:cab_rider/brand_colors.dart';
import 'package:cab_rider/screens/mainpage.dart';
import 'package:cab_rider/widgets/ProgressDialog.dart';
import 'package:cab_rider/widgets/TaxiButton.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cab_rider/screens/registrationpage.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  static const String id = 'login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

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
                  height: 70,
                ),
                Image(
                  alignment: Alignment.center,
                  height: 100.0,
                  width: 100.0,
                  image: AssetImage('images/logo.png'),
                ),
                SizedBox(height: 40),
                Text(
                  'Sign In as Rider',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25.0, fontFamily: 'Brand-Bold'),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
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
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(fontSize: 14.0),
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 10.0)),
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      TaxiButton(
                          color: BrandColors.colorGreen,
                          title: 'LOGIN',
                          onPressed: () async {
                            var connectivityResult =
                                await Connectivity().checkConnectivity();
                            if (connectivityResult !=
                                    ConnectivityResult.mobile &&
                                connectivityResult != ConnectivityResult.wifi) {
                              showSnackBar("No internet connection");
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
                            loginUser();
                          })
                    ],
                  ),
                ),

                //Route to Signup/ Registration Page
                FlatButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, RegistrationPage.id, (route) => false);
                    },
                    child: Text('Don\'t have an account, sign up here')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showSnackBar(String s) {
    var snackbar = SnackBar(content: Text(s));
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  void loginUser() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) =>
            ProgressDialog(status: 'Logging you in'));
    final UserCredential user = await _auth
        .signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .catchError((ex) {
      Navigator.pop(context);
      PlatformException thisEx = ex;
      showSnackBar(thisEx.message);
    });

    if (user == null) {
      Navigator.pop(context);
      showSnackBar('Invalid email/password');
      return;
    }
    DatabaseReference userRef =
        FirebaseDatabase.instance.reference().child('user/${user.user.uid}');
    userRef.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        Navigator.pushNamedAndRemoveUntil(
            context, MainPage.id, (route) => false);
      } else {
        Navigator.pop(context);
        showSnackBar('User not exists');
      }
    });
  }
}
