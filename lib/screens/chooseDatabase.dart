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
  bool nextLevel = true;
  String _mode, _url, _image;
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
          bottomNavigationBar: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: OutlineButton(
              child: Text('Valider'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              onPressed: isSelected == null
                  ? null
                  : () async {
                      endPoint = _url;
                      modeEndPoint = _mode;
                      imageEndPoint = _image;
                      await setDatabaseUrl(_url, _mode, _image);
                      Navigator.pushNamed(context, '/');
                    },
            ),
          ),
          body: Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            color: Color(0xffede6ea),
            child: FutureBuilder(
                future: getDatabaseUrl(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data == '') {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 4.0),
                            child: Text('Mode avec lequel vous allez'),
                          ),
                          Text('vous connecter'),
                          Spacer(),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(height: 10.0),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 140,
                                  child: ListView.builder(
                                    physics: ScrollPhysics(parent: null),
                                    itemCount: items.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            isSelected = index;
                                            _mode = items[index].text;
                                            _url = items[index].url;
                                            _image = items[index].image;
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 5.0),
                                          child: Row(
                                            children: <Widget>[
                                              Icon(
                                                index == isSelected
                                                    ? Icons.check_box
                                                    : Icons
                                                        .check_box_outline_blank,
                                                color: index == isSelected
                                                    ? Colors.deepOrangeAccent
                                                    : Colors.black
                                                        .withOpacity(.1),
                                              ),
                                              SizedBox(
                                                width: 5.0,
                                              ),
                                              Text(
                                                items[index].text,
                                                style:
                                                    TextStyle(fontSize: 15.0),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacer()
                        ],
                      );
                    } else {
                      endPoint = snapshot.data;
                      nextLevel ? startTime() : SizedBox();
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
                                style: TextStyle(
                                    fontFamily: 'Overlock',
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  }
                  return Center(
                    child: CircularProgressIndicator(),
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
