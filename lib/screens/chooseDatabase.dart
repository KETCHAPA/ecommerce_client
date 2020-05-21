import 'dart:async';

import 'package:client_bos_final/common/ENDPOINT.dart';
import 'package:client_bos_final/common/globals.dart';
import 'package:flutter/material.dart';

class ChooseDataBase extends StatefulWidget {
  ChooseDataBase();
  @override
  _ChooseDataBaseState createState() => _ChooseDataBaseState();
}

class _ChooseDataBaseState extends State<ChooseDataBase> {
  int isSelected;
  bool nextLevel = true, nextLevel2 = true;

  void nextPage2() async {
    setState(() {
      nextLevel2 = false;
    });
    modeEndPoint = 'Mode production';
    endPoint = 'https://apiecommerceproduction.bdconsulting-cm.com/api';
    imageEndPoint = 'apiecommerceproduction';
    setDatabaseUrl(endPoint, modeEndPoint, imageEndPoint);
    Navigator.pushNamed(context, '/');
  }

  startTime2() {
    Duration _duration = new Duration(milliseconds: 0);
    return new Timer(_duration, nextPage2);
  }

  void nextPage() async {
    setState(() {
      nextLevel = false;
    });
    modeEndPoint = await getDatabaseMode();
    imageEndPoint = await getDatabaseImageUrl();
    Navigator.pushNamed(context, '/');
  }

  startTime() {
    Duration _duration = new Duration(milliseconds: 0);
    return new Timer(_duration, nextPage);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        color: Color(0xffede6ea),
        child: FutureBuilder(
            future: getDatabaseUrl(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data == '') {
                  nextLevel2 ? startTime2() : SizedBox();
                } else {
                  endPoint = snapshot.data;
                  nextLevel ? startTime() : SizedBox();
                }
              }
              return Scaffold(
                body: Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Center(child: CircularProgressIndicator()),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Un instant',
                      ),
                    ],
                  ),
                ),
              );
            }),
      )),
    );
  }
}

class Item {
  final String text;
  final String url;
  final String image;
  Item({this.text, this.url, this.image});
}

List<Item> items = [
  Item(
      text: 'Mode developpeur',
      url: 'https://apiecommerce.bdconsulting-cm.com/api',
      image: 'apiecommerce'),
  Item(
      text: 'Mode test',
      url: 'https://apiecommercetest.bdconsulting-cm.com/api',
      image: 'apiecommercetest'),
  Item(
      text: 'Mode production',
      url: 'https://apiecommerceproduction.bdconsulting-cm.com/api',
      image: 'apiecommerceproduction'),
];
