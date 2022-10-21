import 'package:doctor_login_app/styles/mixins.dart';
import 'package:doctor_login_app/styles/urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class About extends StatelessWidget {

  void _launchURL() async {
    if (!await launch(websiteURL)) throw 'Could not launch $websiteURL';
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_outlined,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            Container(
              width: 120,
              height: 100,
              child: Image.asset("assets/images/logo.png"),
            ),
          ],
        ),
        actions: [
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30,),
            Text('About LabSmart',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
            SizedBox(height: 20,),
            Text('LabSmart is a SaaS platform used across India and abroad by over 700 laboratories. '
                'More than 1,000 users use the application every day to run business operations. '
                'LabSmart is an attempt to bring a high-quality affordable solution to small and '
                'medium scale laboratories.',style: TextStyle(
              height: 1.5,
              fontSize: 16
            ),
            ),
            SizedBox(height: 20,),

            Row(
              children: [
                Text('LabSmart Website :',style: TextStyle(
            ),),
                InkWell(
                  onTap:()=> _launchURL(),
                  child: Text('https://www.labsmartlis.com/',style: TextStyle(
                    color: kblue,
                    fontSize: 16
                  ),),
                )
              ],
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: ()=>_launchURL(),
                  child: Container(
                    width: 200,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 2,
                        color: kblue
                      )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.link),
                          SizedBox(width: 10,),
                          Text('Know More')
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
