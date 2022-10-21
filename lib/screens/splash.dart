import 'dart:async';

import 'package:doctor_login_app/components/logo.dart';
import 'package:doctor_login_app/screens/login.dart';
import 'package:doctor_login_app/screens/profile.dart';
import 'package:doctor_login_app/styles/mixins.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {


  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  String uid,token,client;
  
  printf(String uid,String token,String client)
  {
    print(uid);
    print(token);
    print(client);
  }

  @override
  void initState()
  {

    getValidationData().whenComplete(() async{

      Timer(Duration(seconds: 3),()=>
        token==null ?  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>LoginScreen()



      ))
      : Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Profile(token, uid, client)
      )));

    });

    super.initState();
  }

  Future getValidationData() async{
    final SharedPreferences sharedPreferences= await SharedPreferences.getInstance();
    var a_uid=sharedPreferences.getString('uid');
    var a_token=sharedPreferences.getString('TOKEN');
    var a_client=sharedPreferences.getString('client');

    setState(() {
      uid=a_uid;
      token=a_token;
      client=a_client;
    });

  }

  @override
  Widget build(BuildContext context) {

    var height=MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: height/6,),
              Image.asset("assets/images/logo.png"),
              Text("SEAMLESS    CONNECTED    DIAGNOSTICS",style: TextStyle(
                color: kblue
              ),),
              SizedBox(height: height/10,),
              SvgPicture.asset(
                'assets/images/splash.svg',
                width: double.infinity,
                height: height/2,
              ),
              Spacer(),
              Text('www.labsmartlis.com',style: TextStyle(
                color: kblue
              ),),
              SizedBox(height: 20,)
            ],
          ),
        ),
      ),
    );
  }
}
