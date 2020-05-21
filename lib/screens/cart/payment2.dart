import 'package:client_bos_final/common/removeAccent.dart';
import 'package:client_bos_final/custom/menu_finalisation.dart';
import 'package:client_bos_final/screens/cart/lastVerification.dart';
import 'package:client_bos_final/screens/cart/payment.dart';
import 'package:client_bos_final/service/paymentService.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class Payment2Page extends StatefulWidget {
  Payment2Page(
      {@required this.shops,
      @required this.items,
      @required this.quantities,
      @required this.names,
      @required this.amount,
      @required this.proIds1,
      @required this.proIds2,
      @required this.qties1,
      @required this.qties2,
      @required this.shopStringIds1,
      @required this.shopStringIds2,
      @required this.pay1Id,
      @required this.liv1Id,
      @required this.pay1Name,
      @required this.liv1Price,
      @required this.pay1Price,
      @required this.liv1Name,
      @required this.userId});

  final List items, quantities;
  final List shops, names;
  final String qties1,
      proIds1,
      shopStringIds1,
      qties2,
      proIds2,
      shopStringIds2,
      liv1Name,
      pay1Name;
  final int userId, amount, liv1Price, pay1Id, liv1Id, pay1Price;
  @override
  _Payment2PageState createState() => _Payment2PageState();
}

class _Payment2PageState extends State<Payment2Page> {
  ProgressDialog progress;
  int isSelectedPayment = -1,
      isSelectedLivraison = -1,
      importancePay = 2,
      importanceLiv = 2,
      _payId = 0,
      _payPrice = 0,
      _livPrice = 0,
      _livId = 0;
  Future<List> payments;
  Future<List> livraisons;
  List _filteredShop = [], _filteredShopNames = [];
  String _livName = '', _payName = '';
  bool canDelete;

  @override
  void initState() {
    super.initState();
    canDelete = false;
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
    payments = getPaymentWay(_filteredShop[1]);
    livraisons = getLivraisonWay(_filteredShop[1]);
  }

  _fetchData() {
    setState(() {
      payments = getPaymentWay(_filteredShop[1]);
      livraisons = getLivraisonWay(_filteredShop[1]);
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
            padding:
                const EdgeInsets.symmetric(vertical: 4.0, horizontal: 15.0),
            child: Row(children: <Widget>[
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
                          borderRadius:
                              BorderRadius.all(Radius.circular(30.0))),
                      elevation: 10.0,
                      color: Colors.green[400],
                      child: Icon(Icons.arrow_forward),
                      onPressed:
                          isSelectedPayment == -1 || isSelectedLivraison == -1
                              ? null
                              : () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FinalPage(
                                                liv1Price: widget.liv1Price,
                                                liv2Price: _livPrice,
                                                pay1Price: widget.pay1Price,
                                                pay2Price: _payPrice,
                                                items: widget.items,
                                                quantities: widget.quantities,
                                                amount: widget.amount,
                                                liv1Id: widget.liv1Id,
                                                liv1Name: widget.liv1Name,
                                                names: widget.names,
                                                pay1Id: widget.pay1Id,
                                                pay1Name: widget.pay1Name,
                                                liv2Name: _livName,
                                                pay2Name: _payName,
                                                liv2Id: _livId,
                                                pay2Id: _payId,
                                                proIds1: widget.proIds1,
                                                proIds2: widget.proIds2,
                                                qties1: widget.qties1,
                                                qties2: widget.qties2,
                                                shopStringIds1:
                                                    widget.shopStringIds1,
                                                shopStringIds2:
                                                    widget.shopStringIds2,
                                                shops: widget.shops,
                                                userId: widget.userId,
                                              )));
                                }))
            ])),
        body: RefreshIndicator(
          onRefresh: () async {
            _fetchData();
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
                    Text('Boutique ${_filteredShopNames[1]}',
                        style: TextStyle(
                          fontSize: 20.0,
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
                                              _payId =
                                                  snapshot.data[index]['id'];
                                              _payPrice = int.parse(snapshot
                                                  .data[index]['price']);
                                              _payName =
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
                                              if (om.length == 1) {
                                                om.add(2);
                                              }
                                            } else {
                                              if (om.length > 1) {
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
                                              if (momo.length < 2) {
                                                momo.add(2);
                                                canDelete = true;
                                              }
                                            } else {
                                              if (canDelete) {
                                                momo.removeLast();
                                                canDelete = false;
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
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                      snapshot.data[index][
                                                                      'price'] ==
                                                                  null ||
                                                              snapshot.data[
                                                                          index]
                                                                      [
                                                                      'price'] ==
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
                                              _livId =
                                                  snapshot.data[index]['id'];
                                              _livPrice = int.parse(snapshot
                                                  .data[index]['price']);
                                              _livName =
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
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                      snapshot.data[index][
                                                                      'price'] ==
                                                                  null ||
                                                              snapshot.data[
                                                                          index]
                                                                      [
                                                                      'price'] ==
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
        ));
  }
}
