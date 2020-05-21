import 'package:client_bos_final/common/removeAccent.dart';
import 'package:client_bos_final/custom/menu_finalisation.dart';
import 'package:client_bos_final/custom/sweetAlert.dart';
import 'package:client_bos_final/screens/cart/lastVerification.dart';
import 'package:client_bos_final/screens/cart/payment2.dart';
import 'package:client_bos_final/service/paymentService.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:sweetalert/sweetalert.dart';

class PaymentPage extends StatefulWidget {
  PaymentPage(
      {@required this.items,
      @required this.quantities,
      @required this.shops,
      @required this.names,
      @required this.amount,
      @required this.proIds1,
      @required this.proIds2,
      @required this.qties1,
      @required this.qties2,
      @required this.shopStringIds1,
      @required this.shopStringIds2,
      this.userId});

  final List items, quantities;
  final List shops, names;
  final String qties1, proIds1, shopStringIds1, qties2, proIds2, shopStringIds2;
  final int userId, amount;
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

List<int> om = [], momo = [];

class _PaymentPageState extends State<PaymentPage> {
  ProgressDialog progress;
  int isSelectedPayment = -1,
      isSelectedLivraison = -1,
      importancePay = 2,
      importanceLiv = 2;
  Future<List> payments;
  Future<List> livraisons;
  List _filteredShop = [], _filteredShopNames = [];
  String payName = '', livName = '';
  int payId = 0, livId = 0, livPrice = 0, payPrice = 0;

  @override
  void initState() {
    super.initState();
    om.clear();
    momo.clear();
    for (var item in widget.shops) {
      if (!_filteredShop.contains(item)) {
        _filteredShop.add(item);
      }
    }
    for (var item in widget.names) {
      if (!_filteredShopNames.contains(item)) {
        _filteredShopNames.add(item);
      }
    }
    payments = getPaymentWay(_filteredShop[0]);
    livraisons = getLivraisonWay(_filteredShop[0]);
  }

  Future<Null> _refreshData() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      await _fetchData();
    } else {
      new Future.delayed(Duration(seconds: 3), () {
        sweetalert(
          context: context,
          withConfirmation: false,
          title: 'Pas de connexion',
          subtitle:
              '  Pour une meilleure experience,\nactivez votre connexion internet.',
          type: SweetAlertStyle.confirm,
        );
      });
      return null;
    }
  }

  _fetchData() {
    setState(() {
      payments = getPaymentWay(_filteredShop[0]);
      livraisons = getLivraisonWay(_filteredShop[0]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                onPressed: isSelectedPayment == -1 || isSelectedLivraison == -1
                    ? null
                    : () async {
                        _filteredShop.length > 1
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Payment2Page(
                                          pay1Name: payName,
                                          liv1Name: livName,
                                          items: widget.items,
                                          liv1Price: livPrice,
                                          pay1Price: payPrice,
                                          quantities: widget.quantities,
                                          shops: widget.shops,
                                          names: widget.names,
                                          amount: widget.amount,
                                          proIds1: widget.proIds1,
                                          proIds2: widget.proIds2,
                                          qties1: widget.qties1,
                                          qties2: widget.qties2,
                                          shopStringIds1: widget.shopStringIds1,
                                          shopStringIds2: widget.shopStringIds2,
                                          userId: widget.userId,
                                          liv1Id: livId,
                                          pay1Id: payId,
                                        )))
                            : Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FinalPage(
                                          liv1Price: livPrice,
                                          pay1Price: payPrice,
                                          items: widget.items,
                                          quantities: widget.quantities,
                                          amount: widget.amount,
                                          liv1Id: livId,
                                          names: widget.names,
                                          pay1Id: payId,
                                          liv1Name: livName,
                                          pay1Name: payName,
                                          proIds1: widget.proIds1,
                                          proIds2: widget.proIds2,
                                          qties1: widget.qties1,
                                          qties2: widget.qties2,
                                          shopStringIds1: widget.shopStringIds1,
                                          shopStringIds2: widget.shopStringIds2,
                                          shops: widget.shops,
                                          userId: widget.userId,
                                        )));
                      },
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _refreshData();
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => PaymentPage(
                    shops: widget.shops,
                    names: widget.names,
                    amount: widget.amount,
                    proIds1: widget.proIds1,
                    proIds2: widget.proIds2,
                    qties1: widget.qties1,
                    qties2: widget.qties2,
                    shopStringIds1: widget.shopStringIds1,
                    shopStringIds2: widget.shopStringIds2,
                    userId: widget.userId,
                    items: widget.items,
                    quantities: widget.quantities,
                  )));
        },
        child: Container(
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  FinalisationMenu(1),
                  SizedBox(
                    height: 15.0,
                  ),
                  Center(
                      child: Text(
                    'Boutique ${_filteredShopNames[0]}',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  )),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    'Mode de paiement: ',
                    style: TextStyle(fontSize: 15.0),
                  ),
                  FutureBuilder(
                    future: payments,
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('${snapshot.error}'),
                        );
                      }
                      if (snapshot.hasData) {
                        return Container(
                          color: Colors.white,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 10.0),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 35.0 * snapshot.data.length,
                                  child: ListView.builder(
                                    physics: ScrollPhysics(parent: null),
                                    itemCount: snapshot.data.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            isSelectedPayment = index;
                                            payId = snapshot.data[index]['id'];
                                            payPrice = int.parse(
                                                snapshot.data[index]['price']);
                                            payName =
                                                snapshot.data[index]['name'];
                                          });
                                          if (removeDiacritics(snapshot
                                                      .data[index]['name'])
                                                  .toLowerCase()
                                                  .contains('orange money') ||
                                              removeDiacritics(
                                                      snapshot.data[index]
                                                          ['description'])
                                                  .toLowerCase()
                                                  .contains('orange money')) {
                                            if (om.isEmpty) {
                                              om.add(1);
                                            }
                                          } else {
                                            if (om.isNotEmpty) {
                                              om.removeLast();
                                            }
                                          }

                                          if (removeDiacritics(snapshot
                                                      .data[index]['name'])
                                                  .toLowerCase()
                                                  .contains('mobile money') ||
                                              removeDiacritics(
                                                      snapshot.data[index]
                                                          ['description'])
                                                  .toLowerCase()
                                                  .contains('mobile money')) {
                                            if (momo.isEmpty) {
                                              momo.add(1);
                                            }
                                          } else {
                                            if (momo.isNotEmpty) {
                                              momo.removeLast();
                                            }
                                          }
                                          print('OM $om');
                                          print('MoMo $momo');
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 5.0),
                                          child: Row(
                                            children: <Widget>[
                                              Icon(
                                                index == isSelectedPayment
                                                    ? Icons.check_box
                                                    : Icons
                                                        .check_box_outline_blank,
                                                color: index ==
                                                        isSelectedPayment
                                                    ? Colors.deepOrangeAccent
                                                    : Colors.black
                                                        .withOpacity(.1),
                                              ),
                                              SizedBox(
                                                width: 5.0,
                                              ),
                                              Text(
                                                snapshot.data[index]['name'],
                                                style:
                                                    TextStyle(fontSize: 15.0),
                                              ),
                                              Spacer(),
                                              Container(
                                                height: 17.0,
                                                child: Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                    snapshot.data[index]
                                                                    ['price'] ==
                                                                null ||
                                                            snapshot.data[index]
                                                                    ['price'] ==
                                                                '0'
                                                        ? ''
                                                        : 'Fcfa',
                                                    style: TextStyle(
                                                        fontSize: 8.0),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 3.0,
                                              ),
                                              Text(snapshot.data[index]
                                                              ['price'] ==
                                                          null ||
                                                      snapshot.data[index]
                                                              ['price'] ==
                                                          '0'
                                                  ? 'Gratuit'
                                                  : '${snapshot.data[index]['price']}')
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
                        );
                      }
                      return Center(
                        child: Image.asset('img/loading5.gif'),
                      );
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'Mode de Livraison: ',
                    style: TextStyle(fontSize: 15.0),
                  ),
                  FutureBuilder(
                    future: livraisons,
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('${snapshot.error}'),
                        );
                      }
                      if (snapshot.hasData) {
                        return Container(
                          color: Colors.white,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 10.0),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 35.0 * snapshot.data.length,
                                  child: ListView.builder(
                                    physics: ScrollPhysics(parent: null),
                                    itemCount: snapshot.data.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            isSelectedLivraison = index;
                                            livId = snapshot.data[index]['id'];
                                            livPrice = int.parse(
                                                snapshot.data[index]['price']);
                                            livName =
                                                snapshot.data[index]['name'];
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 5.0),
                                          child: Row(
                                            children: <Widget>[
                                              Icon(
                                                index == isSelectedLivraison
                                                    ? Icons.check_box
                                                    : Icons
                                                        .check_box_outline_blank,
                                                color: index ==
                                                        isSelectedLivraison
                                                    ? Colors.deepOrangeAccent
                                                    : Colors.black
                                                        .withOpacity(.1),
                                              ),
                                              SizedBox(
                                                width: 5.0,
                                              ),
                                              Text(
                                                snapshot.data[index]['name'],
                                                style:
                                                    TextStyle(fontSize: 15.0),
                                              ),
                                              Spacer(),
                                              Container(
                                                height: 17.0,
                                                child: Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                    snapshot.data[index]
                                                                    ['price'] ==
                                                                null ||
                                                            snapshot.data[index]
                                                                    ['price'] ==
                                                                '0'
                                                        ? ''
                                                        : 'Fcfa',
                                                    style: TextStyle(
                                                        fontSize: 8.0),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 3.0,
                                              ),
                                              Text(snapshot.data[index]
                                                              ['price'] ==
                                                          null ||
                                                      snapshot.data[index]
                                                              ['price'] ==
                                                          '0'
                                                  ? 'Gratuit'
                                                  : '${snapshot.data[index]['price']}')
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
                        );
                      }
                      return Center(
                        child: Image.asset('img/loading5.gif'),
                      );
                    },
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
