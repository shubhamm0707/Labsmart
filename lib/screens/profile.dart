import 'dart:convert';

import 'package:doctor_login_app/models/labmodel.dart';
import 'package:doctor_login_app/screens/about.dart';
import 'package:doctor_login_app/screens/dashboard.dart';
import 'package:doctor_login_app/screens/login.dart';
import 'package:doctor_login_app/styles/mixins.dart';
import 'package:doctor_login_app/styles/urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {


     final String token,uid,client;



     Profile(this.token, this.uid, this.client);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {


  showAlertDialog(BuildContext context, String data)
  {

    var alertDialog=new AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.white,
      content:Row(
        children: [
          CircularProgressIndicator(),
          Text(data)
        ],
      ),
    );

    showDialog(
        barrierDismissible: false,
        context: context, builder: (context)=>alertDialog);

  }


   String name,number,email;

  getData() async{
    print('click');
    SharedPreferences preferences=await SharedPreferences.getInstance();
    print(preferences.get('uid'));
    print(preferences.get('client'));
    print(preferences.get('client'));

   var a_name=preferences.get('name');
   var a_number= preferences.get('number');
   var a_email= preferences.get('email');

    setState(() {
      name=a_name;
      number=a_number;
      email=a_email;
    });

    print(preferences.get('TOKEN'));

    print("--------");

    print(widget.uid);
    print(widget.client);
    print(widget.token);
  }

  Future removeData() async{
    print('click button');
    SharedPreferences preferences=await SharedPreferences.getInstance();
    print(preferences.remove('client'));
    print(preferences.remove('TOKEN'));
    print(preferences.remove('uid'));
  }


  Future delete() async{

    var url="${URL}/doc_app/v1/auth/logout";
    var response= await http.delete(Uri.parse(url),
        headers: {
          'access-token': widget.token,  //P1cmCdEoXrfr12UDbekpUg
          'uid':widget.uid,  //doc_5@mailinator.com
          'client':widget.client,  //kkPCdg5JPfSl7Em2fh-Rbg
          'token-type':'Bearer',
          'content-type': 'application/json'
        }

    );

    if(response.statusCode==200)
    {

      removeData().whenComplete(() async {

        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginScreen()),
              (Route<dynamic> route) => false,
        );

        print('deleted');
      } );

    }else{
      Navigator.pop(context);
    }






  }



  Future allLabs() async {


    print('call-----------------------------------------------');


    var url="${URL}/doc_app/v1/doctor_access/labs";
    var response= await http.get(Uri.parse(url),
        headers: {
          'access-token': widget.token,  //P1cmCdEoXrfr12UDbekpUg
          'uid':widget.uid,  //doc_5@mailinator.com
          'client':widget.client,  //kkPCdg5JPfSl7Em2fh-Rbg
          'token-type':'Bearer',
          'content-type': 'application/json'
        }

    );

    var jsonData= jsonDecode(response.body);
    List<LabData> labs=[];

    if(response.statusCode==200)
    {



      for(var u in jsonData)
      {
        LabData lab= LabData(u['name'], u['city'], u['address_line_one'], u['address_line_two'],u['id']);

        labs.add(lab);

      }


    }else
    {
      print('error code response ${response.body}');
    }
    print('${labs[0].id} :::');
    return labs;
  }


  showAlert(BuildContext context)
  {

    var alertDialog=new AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Colors.white,
        title:Container(

          child: Row(
            children: [
              Container(

                width: 200,
                child: Text(name,style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                ),),
              ),
              Expanded(
                  flex:1,
                  child: Container(

                    child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle
                        ),
                        child: Icon(Icons.person,color: Colors.white,)),
                  ))
            ],
          ),
        ) ,
        content: Container(
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Email: ${email}',style: TextStyle(
                color: Colors.grey,

              )),
              Text('Ph. no. ${number}',style: TextStyle(
                color: Colors.grey,

              )),
              Spacer(),
              InkWell(
                onTap: () async{
                  await Share.share("Hi, I would like you to try LabSmart.\n"
                      "Please visit ${websiteURL} for a free trial");
                },
                child: Text('Invite Lab',style: TextStyle(
                    color: kblue,
                    fontSize: 20
                ),),
              ),
              SizedBox(height: 10,),
              InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>About()));
                },
                child: Text('About LabSmart',style: TextStyle(
                    color: kblue,
                    fontSize: 20
                ),),
              ),
              SizedBox(height: 10,),
              InkWell(
                onTap: (){
                  showAlertDialog(context, 'Logging out...');
                  delete();
                },
                child: Text('Logout',style: TextStyle(
                    color: kblue,
                    fontSize: 20
                ),),
              )
            ],
          ),
        )
    );

    showDialog(context: context, builder: (context)=>alertDialog);

  }


  Future profileFuture;

  @override
  void initState() {
   getData();
   profileFuture= allLabs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = (MediaQuery.of(context).size.height) / 800;
    var width = (MediaQuery.of(context).size.width) / 360;


    // doc_5@mailinator.com
    // I/flutter (14960): yXuWFCVCsdiZawqgH2_b3Q
    // I/flutter (14960): 0F5Vwf8haK8Z4pirNLuuww





    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            IconButton(icon: Icon(Icons.arrow_back_ios_outlined,color: Colors.white,),
           //   Navigator.of(context).pop();
            ),
            Container(
              width: 120,
              height: 100,
              child: Image.asset("assets/images/logo.png"),
            ),
          ],
        ),
        actions: [
          Container(
              decoration: BoxDecoration(color: kblue, shape: BoxShape.circle),
              child: Center(
                child: IconButton(
                    onPressed:(){
                      showAlert(context);
                      setState(() {

                      });
                      // removeData().whenComplete(() async{
                      //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginScreen()));
                      // });
                    }
                    ,icon: Icon(Icons.person),),
              )),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18,vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: (){
                    allLabs();
                  },
                  child: Text('Welcome, ${name}',style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  ),),
                ),
                SizedBox(height: 20,),
                Text('Please select a lab to continue',style: TextStyle(
                    color: Color(0xff4f4f4f),
                    fontSize: 14
                ),),
              ],
            ),
            SizedBox(height: height*25,),
            Expanded(
              child: RefreshIndicator(
                onRefresh: allLabs,
                child: FutureBuilder(
                  future: profileFuture,
                  builder: (context,AsyncSnapshot snapshot){
                    if(snapshot.data==null)
                    {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }else
                    {
                      return ListView.builder(

                          itemCount: snapshot.data.length,
                          itemBuilder: (context,index){
                            return Card(
                              elevation: 3,
                              child: InkWell(
                                onTap: (){
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                                      Dashboard(widget.token, widget.uid, widget.client, snapshot.data[index].id.toString(),
                                          snapshot.data[index].name.toString(),
                                          snapshot.data[index].address_line_one.toString(),snapshot.data[index].address_line_two.toString(),

                                      )));
                                },
                                child: Container(
                                  constraints: BoxConstraints(
                                    minWidth: width*328,
                                    minHeight: height*72,
                                  ),
                                  decoration: BoxDecoration(
                                    color:Color(0xfffafdff),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  child: ListTile(
                                    title: Text(snapshot.data[index].name),
                                    subtitle: Text(snapshot.data[index].address_line_one,style: TextStyle(color: Color(0xff777777),fontSize: 14),),
                                    trailing: Icon(Icons.arrow_forward_ios_outlined,color: Colors.black,),

                                  ),

                                ),
                              ),
                            );

                          });
                    }

                  },
                ),
              ),
            ),
            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }
}
