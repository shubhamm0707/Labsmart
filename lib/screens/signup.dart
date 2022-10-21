import 'dart:convert';

import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:doctor_login_app/components/login_button.dart';
import 'package:doctor_login_app/components/logo.dart';
import 'package:doctor_login_app/components/showdialog.dart';
import 'package:doctor_login_app/screens/profile.dart';
import 'package:doctor_login_app/styles/mixins.dart';
import 'package:doctor_login_app/styles/urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:country_code_picker/country_code.dart';


class SignUp extends StatefulWidget {

  final email,code;


  SignUp({this.email, this.code});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool isShowPassword=false;
  bool _checked=false;

  String valueChoose;

  var listItem=['Dr.','Mr.','Mrs.','Smt.','Ms.'];







  String countyCode="+91";

  void setCode(text){
    setState(() {
      countyCode=text.toString();
      print(countyCode);
    });
}

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  Future storeData(String token , String client , String uid, String name ,String number ,String email) async{

    SharedPreferences preferences= await SharedPreferences.getInstance();

    preferences.setString('TOKEN',token );
    preferences.setString('client',uid );
    preferences.setString('uid',client );
    preferences.setString('name',name );
    preferences.setString('number',number );
    preferences.setString('email',email );

  }

  Future signup () async{

     if(!_checked)
       {
         showAlert(context, "Check the box",mgs: "Check the box",onlytitle: true);
       }
       else if(passwordController.text.length <6)
         {
           showAlert(context, "Password length is too small",mgs: "Password length is too small",onlytitle: true);
         }
     else {
       if (countyCode == "+91" && mobileController.text.length != 10) {
         showAlert(context, "Check mobile number",mgs:"Check mobile number",onlytitle: true );
       } else {
         if (nameController.text.isNotEmpty &&
             passwordController.text.isNotEmpty &&
             mobileController.text.isNotEmpty) {
           showAlertDialog(context, "Please wait");
           print(widget.email);
           print(widget.code);

           var response = await http.post(
               Uri.parse("${URL}/doc_app/v1/auth/signup"), body: (
               {
                 'email': widget.email,
                 'first_name': nameController.text,
                 'mobile_number': mobileController.text,
                 'country_dial_code': countyCode,
                 'password': passwordController.text,
                 'tos_accepted': 'true',
                 'invite_code': widget.code,
               }
           ));
           print(response.statusCode);
           var jsonData = jsonDecode(response.body);
           if (response.statusCode == 200) {
             String token = response.headers['access-token'];
             String uid = jsonData['email'];
             String client = response.headers['client'];
             String name = jsonData['first_name'];
             String number = jsonData['mobile_number'];
             String email = jsonData['email'];

             print(name);


             storeData(token, uid,
                 client, name, number, email).whenComplete(() async {
               Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                   builder: (context) => Profile(token, uid, client)),
                     (Route<dynamic> route) => false,
               );
             });
           } else if(response.statusCode==422)
             {
               Navigator.pop(context);

               if(jsonData['email']!=null && jsonData['mobile_number']!=null)
               showAlert(context, 'Email and phone numbers are taken');
               else if(jsonData['email']!=null)
                 showAlert(context, 'Email is taken',mgs: 'Email is taken',onlytitle: true);
               else if(jsonData['mobile_number']!=null)
                 showAlert(context, 'Phone number is taken',mgs: "Phone number is taken",onlytitle: true);

             }

           else {
             Navigator.pop(context);
             showAlert(context, "Please check and try again");

             print(response.statusCode);

           }
         } else {
           showSnakbar(context,"Field's can't be empty");
         }
       }
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
                SizedBox(height: height*92,),
                Logo(width: width,height: height,),
                SizedBox(height: height*70,),
                Text('Sign Up',style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600
                ),),
                SizedBox(height: height*36,),

                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 20),
                //   child: Row(
                //     children: [
                //     Container(
                //       decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(10),
                //           border: Border.all(
                //               width: 1,
                //               color: Colors.grey
                //           )
                //       ),
                //       child: Padding(
                //         padding: const EdgeInsets.symmetric(horizontal: 8.0),
                //         child: DropdownButton(
                //           hint: Center(child: Text('Dr')),
                //           value: valueChoose,
                //           onChanged: (newValue){
                //             setState(() {
                //               valueChoose=newValue;
                //             });
                //           },
                //           items: listItem.map((valueItem){
                //             return DropdownMenuItem(
                //                 value: valueItem,
                //                 child:Text(valueItem) );
                //           }).toList(),
                //         ),
                //       ),
                //     ),
                //     SizedBox(width: 10,),
                //     Expanded(
                //       flex: 1,
                //       child: Container(
                //         width: 100,
                //         height: 52,
                //         child: TextField(
                //           controller:mobileController,
                //           keyboardType: TextInputType.number,
                //           decoration: InputDecoration(
                //               labelText: 'Mobile Number',
                //               labelStyle: TextStyle(fontWeight: FontWeight.bold),
                //               enabled: true,
                //               border: border_of_inputfield
                //           ),
                //         ),
                //       ),
                //     ),
                //
                //   ],),
                // ),
                // SizedBox(height: height*20,),

                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: width*20),
                  child: TextField(
                    controller: nameController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        enabled: true,
                        border: border_of_inputfield
                    ),
                  ),
                ),
                SizedBox(height: height*20,),
                // Padding(
                //   padding:  EdgeInsets.symmetric(horizontal: width*20),
                //   child: TextField(
                //     controller: nameController,
                //     keyboardType: TextInputType.emailAddress,
                //     decoration: InputDecoration(
                //         labelText: 'Degree',
                //         labelStyle: TextStyle(fontWeight: FontWeight.bold),
                //         enabled: true,
                //         border: border_of_inputfield
                //     ),
                //   ),
                // ),
                // SizedBox(height: height*20,),
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: width*20),
                  child: TextField(
                    obscureText: !isShowPassword,
                    controller: passwordController,
                    decoration: InputDecoration(
                        labelText: 'Set a password (min. 6 characters)',
                        suffixIcon:IconButton(
                          icon: isShowPassword ?
                          Icon(Icons.visibility) : Icon(Icons.visibility_off),
                          onPressed: (){
                            setState(() {
                              isShowPassword=!isShowPassword;
                            });
                          },

                        ),
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        enabled: true,
                        border: border_of_inputfield
                    ),
                  ),
                ),
                SizedBox(height: height*20,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 1,
                          color: Colors.grey
                        )
                      ),
                      child: CountryCodePicker(
                        onChanged:(text)=>setCode(text),
                        initialSelection: 'IN',
                        favorite: ['+91','IN'],
                        hideMainText: false,
                        padding: EdgeInsets.all(0),
                        showFlagMain: true,
                        showFlagDialog: true,
                      ),
                    ),
                   SizedBox(width: 10,),
                    Expanded(
                      flex: 1,
                      child: Container(
                        width: 100,
                        height: 52,
                        child: TextField(
                          controller:mobileController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: 'Mobile Number',
                              labelStyle: TextStyle(fontWeight: FontWeight.bold),
                              enabled: true,
                              border: border_of_inputfield
                          ),
                        ),
                      ),
                    ),

                  ],),
                ),
                SizedBox(height: height*20,),
                CheckboxListTile(
                  title: Row(
                    children: [
                      Text("I agree to the ",style: TextStyle(
                        fontSize: 12
                      ),),
                      Text("Terms of Service ",style: TextStyle(
                          fontSize: 12,
                          color: kblue
                      ),),
                      Text("and ",style: TextStyle(
                          fontSize: 12
                      ),),
                      Text("Privacy Policy.",style: TextStyle(
                          fontSize: 12,
                          color: kblue
                      ),),
                    ],
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  value: _checked,
                  onChanged: (bool value){
                    setState(() {
                      _checked=value;
                    });
                  },
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
                         signup();
                        },
                        child: LoginButton('SIGN UP')),
                  ),
                ),
                SizedBox(height: height*60,),

              ],
            ),
          )
      ),

    );
  }
}

