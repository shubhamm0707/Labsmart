import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:doctor_login_app/models/detail.dart';
import 'package:doctor_login_app/models/labmodel.dart';
import 'package:doctor_login_app/screens/PdfViewPage.dart';
import 'package:doctor_login_app/screens/allpdfhere.dart';
import 'package:doctor_login_app/styles/mixins.dart';
import 'package:doctor_login_app/styles/urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class Dashboard extends StatefulWidget {
  final String token, uid, client, id, name, add1, add2;

  Dashboard(this.token, this.uid, this.client, this.id, this.name, this.add1,
      this.add2);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  StreamController _streamController;
  Stream _stream;

  // bool isAlertOpen=false;

  // showAlertDialog(String data)
  // {
  //   var alertDialog=new AlertDialog(
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(10),
  //     ),
  //     backgroundColor: Colors.white,
  //     content:Row(
  //       children: [
  //         CircularProgressIndicator(),
  //         SizedBox(width: 20,),
  //         Text(data)
  //       ],
  //     ),
  //   );
  //
  //   showDialog(
  //       barrierDismissible: false,
  //       context: context, builder: (context)=>alertDialog);
  //
  // }

  // List<Map<String,Map<String,String>>> list_map=[];
  TextEditingController search = TextEditingController();

  Map<String, List<Map<String, String>>> map_list = {};
  Map<String, List<Map<String, String>>> map_list_report = {};

  String urlPDFPath = "";
  List<Detail> details = [];

  Future<File> getFileFromUrl(url) async {
    try {
      final data = await http.get(url);
      var bytes = data.bodyBytes;
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/mypdfonline.pdf");

      File urlFile = await file.writeAsBytes(bytes);
      return urlFile;
    } catch (e) {
      throw Exception("Error opening url file");
    }
  }

  int iddd = -1;

  bool isPrevious = false;
  bool isNext = true;

  Future allData({String query = "", int page = 1}) async {
    print('refresh-------------------------------------------------');

    _streamController.add("waiting");

    var url;
    if (iddd < 0) {
      iddd = 1;
    } else {
      iddd = iddd;
    }

    if (query == "") {
      url =
          "${URL}/doc_app/v1/doctor_access/labs/${widget.id}/reports?page=${iddd}";
    } else {
      url =
          "${URL}/doc_app/v1/doctor_access/labs/${widget.id}/reports?page=${iddd}&q=${query}";
    }

    //  print(url);

//&q=${"abc dc"}
    var response = await http.get(Uri.parse(url), headers: {
      'access-token': widget.token,
      'uid': widget.uid,
      'client': widget.client,
      'token-type': 'Bearer',
      'content-type': 'application/json'
    });

    var jsonData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      details = [];
      for (MapEntry u in jsonData['cases'].entries) {
        //MapEntry e in numMap.entries

        Detail detail = new Detail(
            u.value['patient']['name'],
            u.value['patient']['age'],
            u.value['patient']['mobile_number'],
            u.value['date'],
            u.value['patient']['sex'],
            u.key);
        details.add(detail);
      }

      map_list = {};

      for (MapEntry u in jsonData['cases'].entries) {
        Map<String, String> map = {};
        List<Map<String, String>> l = [];
        int i = 0;
        for (MapEntry e in jsonData['cases'][u.key]['investigations'].entries) {
          map[e.key] = e.value;
        }
        l.add(map);
        map_list[u.key] = l;
      }

      for (MapEntry u in jsonData['cases'].entries) {
        Map<String, String> map = {};
        List<Map<String, String>> l = [];
        int i = 0;
        for (MapEntry e in jsonData['cases'][u.key]['reports'].entries) {
          map[e.key] = e.value;
        }
        l.add(map);
        map_list_report[u.key] = l;
      }

      if (details != null)
        _streamController.add(details);
      else {
        _streamController.add('no');
      }

      if (details.length == 0) {
        setState(() {
          isNext = false;
        });
      }
    } else {
      print('error');
    }

    return details;
  }

  void nextbutton() {
    iddd++;

    if (!isPrevious) {
      setState(() {
        isPrevious = true;
      });
    }

    allData(query: search.text);
  }

  void previousbutton() {
    setState(() {
      isNext = true;
    });

    if (iddd == 2) {
      iddd--;
      setState(() {
        isPrevious = false;
      });
    } else {
      iddd--;
    }
    allData(query: search.text);
  }

  showAlert(BuildContext context, String id) {
    var alertDialog = new AlertDialog(
        title: Text('Investigations'),
        content: Container(
            width: 200,
            height: 260,
            child: ListView(
              children: [
                for (MapEntry e in map_list[id][0].entries)
                  Column(
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Text('${e.key} - '),
                            Expanded(
                              flex: 1,
                              child: Container(
                                  child: Text(
                                e.value,
                                style: TextStyle(fontSize: 14),
                              )),
                            )
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 2,
                      )
                    ],
                  )
              ],
            )));

    showDialog(context: context, builder: (context) => alertDialog);
  }

  Future dashboard;

  @override
  void initState() {
    super.initState();

    var url = Uri.parse(
        "https://d14lrqamrmxanw.cloudfront.net/uploads/diagnostic_lab_1/LabReport-L1-Mr.ABCD_33YRS-M_-22-12-202120211222-4-1xlci7i.pdf");
    // "https://d33hv1py9n6skn.cloudfront.net/uploads/diagnostic_lab_5/LabReport-L2-Mrs.SunandaMarathe_30YRS-F_-11-12-202120211211-4-1e53s6u.pdf");

    getFileFromUrl(url).then((f) {
      setState(() {
        urlPDFPath = f.path;
        print(urlPDFPath);
      });
    });

    _streamController = StreamController();
    _stream = _streamController.stream;

    // _search();

    allData();

    dashboard = allData();
  }

  @override
  Widget build(BuildContext context) {
    var height = (MediaQuery.of(context).size.height) / 800;
    var width = (MediaQuery.of(context).size.width) / 360;

    print('reeeeeeeeeeeeeeeeeeeeeeeeeeee');

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
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  "${widget.add1}, ${widget.add2}",
                  style: TextStyle(color: Color(0xff4f4f4f), fontSize: 12),
                ),
                SizedBox(
                  height: height * 31,
                ),
                Container(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: search,
                          decoration: InputDecoration(
                              hintText: 'Search by email, name or phone no.',
                              hintStyle: TextStyle(fontSize: 13),
                              isDense: true,
                              contentPadding: EdgeInsets.all(10),
                              border: OutlineInputBorder(
                                  //  borderSide: BorderSide.none
                                  )),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            iddd = 1;
                            isPrevious = false;
                            isNext = true;
                          });
                          search.text.length > 2
                              ? allData(query: search.text)
                              : showSnakbar(
                                  context, 'search length is less than 3');
                          ;
                          FocusScope.of(context).unfocus();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: kblue,
                              ),
                              borderRadius: BorderRadius.circular(7)),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.search,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  width: 14,
                                ),
                                Text(
                                  "Search",
                                  style: TextStyle(color: Colors.black),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            alignment: Alignment.center,
            width: width * 360,
            height: height * 32,
            decoration: BoxDecoration(color: Color(0xffeeeeee)),
            child: Text(
              'Reports and Investigations',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 17),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => allData(query: search.text),
              child: StreamBuilder(
                stream: _stream,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return Center(
                      child: Column(
                        children: [
                          RaisedButton(
                            color: kblue,
                            onPressed: () {},
                            child: Text('clear search'),
                          )
                        ],
                      ),
                    );
                  }
                  if (snapshot.data == "waiting") {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.data == "no") {
                    return Center(
                      child: Column(
                        children: [
                          Text("No data found"),
                          RaisedButton(
                            color: kblue,
                            onPressed: () {},
                            child: Text('clear search'),
                          )
                        ],
                      ),
                    );
                  }
                  return details.length == 0
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text('No data Found'),
                              SizedBox(
                                height: 20,
                              ),
                              (search.text.isNotEmpty)
                                  ? RaisedButton(
                                      color: kblue,
                                      onPressed: () {
                                        setState(() {
                                          search.clear();
                                          FocusScope.of(context).unfocus();
                                          allData();
                                          isNext = true;
                                        });
                                      },
                                      child: Text(
                                        'clear search',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )
                                  : Center()
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return Card(
                                elevation: 3,
                                child: Container(
                                  constraints: BoxConstraints(
                                    minWidth: width * 328,
                                    minHeight: height * 72,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0xfffafdff),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  child: Container(
                                    constraints: BoxConstraints(
                                      minWidth: width * 328,
                                      minHeight: height * 72,
                                    ),
                                    child: Card(
                                      color: Color(0xfffafdff),
                                      elevation: 3,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        child: Container(
                                          constraints: BoxConstraints(
                                            minWidth: width * 328,
                                            minHeight: height * 72,
                                          ),
                                          child: Stack(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: 160,
                                                    child: Text(
                                                      snapshot.data[index].name,
                                                      style: TextStyle(
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                  Text(
                                                    '${snapshot.data[index].age}/ ${snapshot.data[index].sex}',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            Color(0xff777777)),
                                                  ),
                                                  Text(
                                                    snapshot.data[index]
                                                        .mobile_number,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            Color(0xff777777)),
                                                  ),
                                                ],
                                              ),
                                              Positioned(
                                                  bottom: 0,
                                                  child: Text(
                                                    snapshot.data[index].date,
                                                  )),
                                              Positioned(
                                                  right: 0,
                                                  top: 10,
                                                  bottom: 0,
                                                  child:












                                                  Container(
                                                      decoration:
                                                      BoxDecoration(),
                                                      child: Center(
                                                          child: true
                                                              ? Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [


                                                              Column(
                                                                children: [
                                                                  InkWell(
                                                                    onTap: !map_list_report[snapshot.data[index].id][0].isEmpty
                                                                        ? () {
                                                                      if (urlPDFPath != null)
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                                builder: (context) => AllPdfHere(
                                                                                  list: map_list_report[snapshot.data[index].id],
                                                                                )
                                                                              // PdfViewPage(
                                                                              //   path: urlPDFPath,
                                                                              //   name: snapshot.data[index].name,
                                                                              // )

                                                                            ));
                                                                    }
                                                                        : null,
                                                                    child:
                                                                    Container(
                                                                      width: 30,
                                                                      height: 30,
                                                                      decoration:
                                                                      BoxDecoration(border: !map_list_report[snapshot.data[index].id][0].isEmpty? Border.all(color: kblue, width: 1.5) : Border.all(color: Colors.grey, width: 1.5), shape: BoxShape.circle),
                                                                      child:
                                                                      Column(
                                                                        children: [
                                                                          Padding(
                                                                            padding: const EdgeInsets.all(6.0),
                                                                            child: !map_list_report[snapshot.data[index].id][0].isEmpty
                                                                                ? SvgPicture.asset(
                                                                              'assets/images/filepdf.svg',
                                                                              width: 14,
                                                                              height: 14,
                                                                              color: kblue,
                                                                            )
                                                                                : SvgPicture.asset(
                                                                              'assets/images/filepdf.svg',
                                                                              width: 14,
                                                                              height: 14,
                                                                              color: Colors.grey,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height:
                                                                    9,
                                                                  ),
                                                                  InkWell(
                                                                    onTap: !map_list_report[snapshot.data[index].id][0].isEmpty
                                                                        ? () {
                                                                      if (urlPDFPath != null)
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                                builder: (context) => AllPdfHere(
                                                                                  list: map_list_report[snapshot.data[index].id],
                                                                                )
                                                                              // PdfViewPage(
                                                                              //   path: urlPDFPath,
                                                                              //   name: snapshot.data[index].name,
                                                                              // )

                                                                            ));
                                                                    }
                                                                        : null,
                                                                    child:
                                                                    Text(
                                                                      'Reports',
                                                                      style:
                                                                      TextStyle(fontSize: 10,
                                                                      color: !map_list_report[snapshot.data[index].id][0].isEmpty ?kblue:Colors.grey),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(width: width*30,),
                                                              InkWell(
                                                                child: Column(
                                                                  children: [
                                                                    InkWell(
                                                                      onTap:  () {
                                                                        showAlert(context,
                                                                            snapshot.data[index].id);
                                                                      }
                                                                          ,
                                                                      child:
                                                                      Container(
                                                                        width: 30,
                                                                        height: 30,
                                                                        decoration:
                                                                        BoxDecoration(border: Border.all(color: kblue, width: 1.5), shape: BoxShape.circle),
                                                                        child:
                                                                        Column(
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(6.0),
                                                                              child:  SvgPicture.asset(
                                                                                'assets/images/infosolid.svg',
                                                                                width: 14,
                                                                                height: 14,
                                                                                color: kblue,
                                                                              )
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                      9,
                                                                    ),
                                                                    InkWell(
                                                                      onTap: (){
                                                                        showAlert(context,
                                                                            snapshot.data[index].id);
                                                                      },
                                                                      child:
                                                                      Text(
                                                                        'Investigations',
                                                                        style:
                                                                        TextStyle(fontSize: 10,color: kblue),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),



                                                              // SizedBox(
                                                              //   width: 30,
                                                              // ),
                                                              // Column(
                                                              //   children: [
                                                              //     InkWell(
                                                              //       onTap:
                                                              //           () {
                                                              //         showAlert(context,
                                                              //             snapshot.data[index].id);
                                                              //       },
                                                              //       child:
                                                              //       Container(
                                                              //         width: 30,
                                                              //         height: 30,
                                                              //         decoration:
                                                              //         BoxDecoration(border: Border.all(color: kblue, width: 1.5), shape: BoxShape.circle),
                                                              //         child:
                                                              //         Column(
                                                              //           children: [
                                                              //             Padding(
                                                              //               padding: const EdgeInsets.all(6.0),
                                                              //               child: SvgPicture.asset(
                                                              //                 'assets/images/infosolid.svg',
                                                              //                 width: 14,
                                                              //                 height: 14,
                                                              //                 color: kblue,
                                                              //               ),
                                                              //             ),
                                                              //           ],
                                                              //         ),
                                                              //       ),
                                                              //     ),
                                                              //     SizedBox(
                                                              //       height:
                                                              //       3,
                                                              //     ),
                                                              //     Text(
                                                              //       'Investigations',
                                                              //       style:
                                                              //       TextStyle(fontSize: 12),
                                                              //     )
                                                              //   ],
                                                              // )


                                                            ],
                                                          )
                                                              : Text(
                                                              'Not Ready')))

























                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ));
                          });
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RaisedButton(
                  color: Colors.white,
                  onPressed: isPrevious ? previousbutton : null,
                  child: Text(
                    'Previous Page',
                    style: TextStyle(
                      color: isPrevious ? kblue : null,
                    ),
                  ),
                ),
                RaisedButton(
                  color: Colors.white,
                  onPressed: isNext ? nextbutton : null,
                  child: Text(
                    'Next Page',
                    style: TextStyle(
                      color: isNext ? kblue : null,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
