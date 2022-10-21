import 'package:doctor_login_app/screens/dashboard.dart';
import 'package:doctor_login_app/screens/invitescreen.dart';
import 'package:doctor_login_app/screens/profile.dart';
import 'package:doctor_login_app/screens/signup.dart';
import 'package:doctor_login_app/screens/splash.dart';
import 'package:doctor_login_app/styles/mixins.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:doctor_login_app/screens/login.dart';

void main()
{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          home: MyApp(),
          theme: ThemeData(
              primaryColor: kblue
          ),
        ));
  });

}


class MyApp extends StatelessWidget {

  static final widthscreen=360;
  static final heightscreen=800;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Splash(),
    );
  }
}
// new comment

