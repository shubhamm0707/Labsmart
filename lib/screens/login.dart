import 'dart:convert';

import 'package:doctor_login_app/components/login_button.dart';
import 'package:doctor_login_app/components/logo.dart';
import 'package:doctor_login_app/components/showdialog.dart';
import 'package:doctor_login_app/screens/dashboard.dart';
import 'package:doctor_login_app/screens/invitescreen.dart';
import 'package:doctor_login_app/screens/profile.dart';
import 'package:doctor_login_app/screens/signup.dart';
import 'package:doctor_login_app/screens/splash.dart';
import 'package:doctor_login_app/styles/mixins.dart';
import 'package:doctor_login_app/styles/urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';


class LoginScreen extends StatefulWidget {


  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController emailController=TextEditingController();
  TextEditingController passController=TextEditingController();

  bool isShowPassword=false;



  void _launchURL() async {
    if (!await launch(forgotPasswordURL)) throw 'Could not launch $forgotPasswordURL';
  }




  Future storeData(String token , String client , String uid, String name ,String number ,String email) async{

    SharedPreferences preferences= await SharedPreferences.getInstance();

    preferences.setString('TOKEN',token );
    preferences.setString('client',uid );
    preferences.setString('uid',client );
    preferences.setString('name',name );
    preferences.setString('number',number );
    preferences.setString('email',email );

  }

  Future signIn() async {



    if(emailController.text.isNotEmpty && passController.text.isNotEmpty)
    {
      showAlertDialog(context, "  Please wait");

      var response= await http.post(Uri.parse("${URL}/doc_app/v1/auth/login"),body: (

          {
            'email':emailController.text.trim(),
            'password':passController.text.trim()
          }
      ));

      var jsonData= jsonDecode(response.body);

      print(jsonData);

      if(response.statusCode==200)
      {
        String token=jsonData['data']['auth_headers']['access-token'];
        String uid=jsonData['data']['auth_headers']['uid'];
        String client=jsonData['data']['auth_headers']['client'];
        String name=jsonData['data']['user']['first_name'];
        String number=jsonData['data']['user']['mobile_number'];
        String email=jsonData['data']['user']['email'];

        print(name);


        storeData(token,uid,
            client,name,number,email).whenComplete(() async{
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Profile(token,uid,client)),
                (Route<dynamic> route) => false,
          );

        })  ;

      }else
      {
        Navigator.pop(context);
        showAlert(context, 'Check email and password',mgs: "Check email and password..",onlytitle: true);
        print('error');
      }
    }else
    {
      showSnakbar(context,"Fields can't be empty");
      print("empty field");
    }
  }

  @override
  Widget build(BuildContext context) {


    var height = (MediaQuery.of(context).size.height)/800;
    var width = (MediaQuery.of(context).size.width)/360;


    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: height*70,),
              Logo(width: width,height: height,),
              SizedBox(height: height*50,),
              Text('Doctor Login',style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600
              ),),
              SizedBox(height: height*20,),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: width*31),
                child: TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon:Icon(Icons.mail),
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      enabled: true,
                      border: border_of_inputfield
                  ),
                ),
              ),
              SizedBox(height: height*20,), Padding(
                padding:  EdgeInsets.symmetric(horizontal: width*31),
                child: TextField(
                  controller: passController,
                  obscureText:! isShowPassword,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon:IconButton(
                         icon: isShowPassword ?
                          Icon(Icons.visibility) : Icon(Icons.visibility_off),
                        onPressed: (){
                           setState(() {
                             isShowPassword=!isShowPassword;
                           });
                        },

                      )

                      ,
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      enabled: true,
                      border: border_of_inputfield
                  ),
                ),
              ),
              SizedBox(height: height*8,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(height: height*18,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width*40),
                    child: InkWell(
                      onTap:()=>_launchURL(),
                      child: Text("Forgot Password", style: TextStyle(
                          color: kblue,
                          fontSize: 14,
                          fontWeight: FontWeight.w700
                      ),),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height*20,),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: width*256,
                  height: height*44,
                  child: RaisedButton(
                      elevation: 10,
                      color: kblue,
                      onPressed: () {
                        signIn();
                      },
                      child: LoginButton('LOGIN')),
                ),
              ),
              SizedBox(height: 10,),
              InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>InviteScreen()));
                },
                splashColor: Colors.black12,
                child: Container(
                  height: height*44,
                  width: width*256,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 2,
                      color: kblue
                    )
                  ),
                  child: Center(child: Text('SIGN UP',style: TextStyle(
                    color: kblue,
                    fontWeight: FontWeight.bold
                  ),)),

                ),
              ),

            ],
          ),
        )
      ),

    );
  }
}
