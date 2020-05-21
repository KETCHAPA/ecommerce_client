import 'package:client_bos_final/common/globals.dart';
import 'package:client_bos_final/custom/menu_finalisation.dart';
import 'package:client_bos_final/screens/account/update.dart';
import 'package:client_bos_final/screens/cart/payment.dart';
import 'package:flutter/material.dart';

class FinalisationPage extends StatefulWidget {
  FinalisationPage(
      {this.userId,
      @required this.items,
      @required this.total,
      @required this.quantities});

  final List items, quantities;
  final int total;
  final int userId;
  @override
  _FinalisationPageState createState() => _FinalisationPageState();
}

String qties1 = '',
    qties2 = '',
    proIds1 = '',
    proIds2 = '',
    shopStringIds1 = '',
    shopStringIds2 = '';
int amount = 0;

class _FinalisationPageState extends State<FinalisationPage> {
  @override
  void initState() {
    super.initState();
    amount = widget.total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text('Finalisation de la commande'),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 15.0),
        child: Row(
          children: <Widget>[
            Container(
              width: 55.0,
              height: 55.0,
              child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  elevation: 10.0,
                  color: Colors.red[400],
                  child: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context)),
            ),
            Spacer(),
            Container(
              width: 55.0,
              height: 55.0,
              child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  elevation: 10.0,
                  color: Colors.green[400],
                  child: Icon(Icons.arrow_forward),
                  onPressed: () {
                    var _shopNames = widget.items[0].shopName;
                    List<int> _index1 = [], _index2 = [];
                    for (var i = 0; i < widget.items.length; i++) {
                      if (widget.items[i].shopName == _shopNames) {
                        proIds1 += '${widget.items[i].id.toString()} ,';
                        shopStringIds1 +=
                            '${widget.items[i].shopId.toString()} ,';
                        _index1.add(i);
                      } else {
                        proIds2 += '${widget.items[i].id.toString()} ,';
                        shopStringIds2 +=
                            '${widget.items[i].shopId.toString()} ,';
                        _index2.add(i);
                      }
                    }
                    for (var item in _index1) {
                      qties1 += '${widget.quantities[item].toString()} ,';
                    }
                    for (var item in _index2) {
                      qties2 += '${widget.quantities[item].toString()} ,';
                    }
                    print('qties1=' +
                        qties1 +
                        ', qties2=' +
                        qties2 +
                        ', proIds1=' +
                        proIds1 +
                        ', proIds2=' +
                        proIds2 +
                        ', ShopStringIds1=' +
                        shopStringIds1 +
                        ', ShopStringIds2=' +
                        shopStringIds2);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PaymentPage(
                                  shops: commandShopIds,
                                  names: shopNames,
                                  amount: widget.total,
                                  proIds1: proIds1,
                                  proIds2: proIds2,
                                  qties1: qties1,
                                  qties2: qties2,
                                  shopStringIds1: shopStringIds1,
                                  shopStringIds2: shopStringIds2,
                                  userId: widget.userId,
                                  items: widget.items,
                                  quantities: widget.quantities,
                                )));
                  }),
            ),
          ],
        ),
      ),
      body: Container(
          color: Colors.grey.withOpacity(.2),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                FinalisationMenu(0),
                SizedBox(
                  height: 15.0,
                ),
                Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                      child: FutureBuilder(
                        future: getCurrentUser(),
                        builder: (BuildContext context, snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => UpdateData(
                                                  user: snapshot.data,
                                                  secondParameter: 'yes',
                                                  items: widget.items,
                                                  quantities: widget.quantities,
                                                  total: widget.total,
                                                  userId: widget.userId,
                                                )));
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        'Adresse d\'envoi:',
                                        style: TextStyle(fontSize: 15.0),
                                      ),
                                      Spacer(),
                                      Text(
                                        'Modifier',
                                        style: TextStyle(fontSize: 15.0),
                                      ),
                                      Icon(
                                        Icons.mode_edit,
                                        size: 15.0,
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      '${snapshot.data['name'].toUpperCase()}',
                                      style: TextStyle(fontSize: 15.0),
                                    ),
                                    Spacer(),
                                    Text(
                                      snapshot.data['phone'],
                                      style: TextStyle(fontSize: 13.0),
                                    )
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      snapshot.data['email'],
                                      style: TextStyle(fontSize: 14.0),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      '${snapshot.data['street']} - ${snapshot.data['address']}',
                                      style: TextStyle(fontSize: 14.0),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      '${snapshot.data['town']} - ${snapshot.data['country']}',
                                      style: TextStyle(fontSize: 14.0),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }
                          if (snapshot.hasError) {
                            return Center(
                              child: Text('${snapshot.error}'),
                            );
                          }
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      )),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  height: 150.0 * widget.items.length,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 35.0, right: 8.0),
                    child: ListView.builder(
                      physics: ScrollPhysics(parent: null),
                      itemCount: widget.items.length,
                      itemBuilder: (BuildContext context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 0.0),
                          child: Container(
                            height: 150.0,
                            width: MediaQuery.of(context).size.width,
                            child: Stack(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  child: Row(
                                    children: <Widget>[
                                      Spacer(),
                                      Text(
                                          'Vendeur: ${widget.items[index].shopName.length > 11 ? widget.items[index].shopName.substring(0, 11) + '...' : widget.items[index].shopName ?? 'Non renseigne'}'),
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                      height: 120.0,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            height: 120,
                                            width: 120.0,
                                            child: Image.network(
                                              imagePath(
                                                  '${widget.items[index].photo}'),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  widget.items[index].name
                                                              .length <
                                                          30
                                                      ? '${widget.items[index].name}'
                                                      : '${widget.items[index].name.substring(0, 29)}...',
                                                  style: TextStyle(
                                                      fontSize: 17.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: 5.0,
                                                ),
                                                Text(
                                                    '${widget.items[index].newPrice == null || widget.items[index].newPrice == 0 ? widget.items[index].oldPrice : widget.items[index].newPrice} Fcfa'),
                                                Spacer(),
                                                Container(
                                                  height: 20.0,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .45,
                                                  child: Row(
                                                    children: <Widget>[
                                                      Spacer(),
                                                      Text(
                                                          'Qte: ${widget.quantities[index].toString() ?? 0}'),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      )),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              'Avez-vous un bon de reduction ? ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('(Optionnel)')
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width * .63,
                              height: 40.0,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Code promotionnel'),
                                ),
                              ),
                            ),
                            Spacer(),
                            InkWell(
                              onTap: () {},
                              child: Container(
                                width: MediaQuery.of(context).size.width * .22,
                                height: 40.0,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blue),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0))),
                                child: Center(
                                    child: Text(
                                  'Appliquer',
                                  style: TextStyle(color: Colors.blue),
                                )),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                )
              ],
            ),
          )),
    );
  }
}
