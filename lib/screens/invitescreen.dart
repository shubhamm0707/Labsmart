import 'dart:convert';

import 'package:doctor_login_app/components/login_button.dart';
import 'package:doctor_login_app/components/logo.dart';
import 'package:doctor_login_app/components/showdialog.dart';
import 'package:doctor_login_app/screens/login.dart';
import 'package:doctor_login_app/screens/profile.dart';
import 'package:doctor_login_app/screens/signup.dart';
import 'package:doctor_login_app/styles/mixins.dart';
import 'package:doctor_login_app/styles/urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;


class InviteScreen extends StatefulWidget {

  @override
  _InviteScreenState createState() => _InviteScreenState();
}

class _InviteScreenState extends State<InviteScreen> {

  TextEditingController emailController= TextEditingController();
  TextEditingController codeController= TextEditingController();

  TextEditingController check=TextEditingController();

 Future checkingInvite() async
  {

    if(emailController.text.isNotEmpty && codeController.text.isNotEmpty)
      {
        showAlertDialog(context, 'Please wait');
        var url='${URL}/doc_app/v1/auth/validate_invite_code?email=${emailController.text.trim()}&invite_code=${codeController.text.trim()}';
        var response= await http.get(Uri.parse(url));

        var jsonData= jsonDecode(response.body);




        if(response.statusCode==200)
          {


           if( jsonData['data']['message']=='Valid')
           {
             Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>SignUp(email: emailController.text,code: codeController.text,)));
           }else
             {
               Navigator.pop(context);
               showAlert(context, 'Please check and try again.');
               print(emailController.text);
               print(codeController.text);
             }

          }else
            {
              Navigator.pop(context);
              showAlert(context, 'something');
              print('error');
            }
      }else
        {
          showSnakbar(context,"Field's can't be empty");
          print("empty field");
        }



  }


  @override
  Widget build(BuildContext context) {

    bool isShow=true;

    var height = (MediaQuery.of(context).size.height)/800;
    var width = (MediaQuery.of(context).size.width)/360;

    return  Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: height*92,),
                Logo(width: width,height: height,),
                SizedBox(height: height*70,),
                Text('Sign Up',style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600
                ),),
                SizedBox(height: height*36,),
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: width*31),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.mail),
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        enabled: true,
                        border: border_of_inputfield
                    ),
                  ),
                ),
                SizedBox(height: height*20,),
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: width*31),
                  child: TextField(
                    controller: codeController,
                    decoration: InputDecoration(
                        labelText: 'Invite code',
                        prefixIcon: Icon(Icons.code),
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        enabled: true,
                        border: border_of_inputfield
                    ),
                  ),
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

                          checkingInvite();
                        },
                        child: LoginButton('Continue')),
                  ),
                ),
                SizedBox(height: height*146,),
                InkWell(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginScreen()));
                    },
                    child: ShowDialog(width: width,height: height,))
              ],
            ),
          )
      ),

    );
  }
}

