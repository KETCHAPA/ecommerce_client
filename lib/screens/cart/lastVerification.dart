import 'package:client_bos_final/common/globals.dart';
import 'package:client_bos_final/custom/loading.dart';
import 'package:client_bos_final/custom/menu_finalisation.dart';
import 'package:client_bos_final/screens/cart/deliveryPage.dart';
import 'package:client_bos_final/screens/cart/payment.dart';
import 'package:client_bos_final/screens/payment/mtn.dart';
import 'package:client_bos_final/screens/payment/orange.dart';
import 'package:client_bos_final/service/commandService.dart';
import 'package:client_bos_final/service/paymentService.dart';
import 'package:flutter/material.dart';

import 'package:progress_dialog/progress_dialog.dart';
import 'package:sweetalert/sweetalert.dart';

class FinalPage extends StatefulWidget {
  FinalPage(
      {@required this.items,
      @required this.quantities,
      @required this.shops,
      @required this.names,
      @required this.amount,
      @required this.pay1Id,
      @required this.liv1Id,
      @required this.pay1Name,
      @required this.liv1Price,
      @required this.pay1Price,
      @required this.proIds1,
      @required this.proIds2,
      @required this.qties1,
      @required this.qties2,
      @required this.shopStringIds1,
      @required this.shopStringIds2,
      @required this.liv1Name,
      @required this.userId,
      this.pay2Id,
      this.liv2Id,
      this.pay2Name,
      this.liv2Price,
      this.pay2Price,
      this.liv2Name});

  final List items, quantities;
  final String qties1, proIds1, shopStringIds1, qties2, proIds2, shopStringIds2;
  final String pay2Name, liv2Name, pay1Name, liv1Name;
  final List shops, names;
  final int userId,
      amount,
      liv1Price,
      liv2Price,
      pay1Id,
      liv1Id,
      pay2Id,
      liv2Id,
      pay1Price,
      pay2Price;
  @override
  _FinalPageState createState() => _FinalPageState();
}

class _FinalPageState extends State<FinalPage> {
  ProgressDialog progress;
  String prices1 = '', prices2 = '';
  int amount1 = 0, amount2 = 0;
  @override
  void initState() {
    super.initState();
  }

  createData() async {
    progress = loadingWidget(context);
    progress.show();
    var _shopName = widget.items[0].shopName;
    for (var i = 0; i < widget.items.length; i++) {
      if (_shopName == widget.items[i].shopName) {
        prices1 +=
            '${widget.items[i].newPrice == null || widget.items[i].newPrice == 0 ? widget.items[i].oldPrice : widget.items[i].newPrice} ,';
        amount1 +=
            widget.items[i].newPrice == null || widget.items[i].newPrice == 0
                ? widget.items[i].oldPrice * widget.quantities[i]
                : widget.items[i].newPrice * widget.quantities[i];
      } else {
        prices2 +=
            '${widget.items[i].newPrice == null || widget.items[i].newPrice == 0 ? widget.items[i].oldPrice : widget.items[i].newPrice} ,';
        amount2 +=
            widget.items[i].newPrice == null || widget.items[i].newPrice == 0
                ? widget.items[i].oldPrice * widget.quantities[i]
                : widget.items[i].newPrice * widget.quantities[i];
      }
    }
    Map<String, dynamic> params = Map<String, dynamic>();
    params['pro_ids'] = widget.proIds1;
    params['quantities'] = widget.qties1;
    params['prices'] = prices1;
    params['amount'] =
        (amount1 + widget.liv1Price + widget.pay1Price).toString();
    print('debut de la premiere commande');
    await storeCart(params).then((data) async {
      if (data != null) {
        Map<String, dynamic> params = Map<String, dynamic>();
        params['client_id'] = widget.userId.toString();
        params['cart_id'] = data.id.toString();
        params['shop_id'] = widget.shopStringIds1;
        print('commande');
        await storeCommand(params).then((data) async {
          if (data != null) {
            String _commandCode1 = data.code;
            Map<String, dynamic> params = Map<String, dynamic>();
            params['ser_id'] = widget.pay1Id.toString();
            params['importance'] = '2';
            print('commande service 1');
            await storeCommandServices(params, _commandCode1)
                .then((data) async {
              if (data != null) {
                progress.show();
                params['ser_id'] = widget.liv1Id.toString();
                params['importance'] = '2';
                print('commande service 2');
                await storeCommandServices(params, _commandCode1)
                    .then((data) async {
                  if (data != null) {
                    if (widget.liv2Id != null) {
                      Map<String, dynamic> params = Map<String, dynamic>();
                      params['pro_ids'] = widget.proIds2;
                      params['quantities'] = widget.qties2;
                      params['prices'] = prices2;
                      params['amount'] =
                          (amount2 + widget.liv2Price + widget.pay2Price)
                              .toString();
                      print('debut de la deuxieme commande');
                      await storeCart(params).then((data) async {
                        if (data != null) {
                          Map<String, dynamic> params = Map<String, dynamic>();
                          params['client_id'] = widget.userId.toString();
                          params['cart_id'] = data.id.toString();
                          params['shop_id'] = widget.shopStringIds2;
                          print('commande 2');
                          await storeCommand(params).then((data) async {
                            if (data != null) {
                              String _commandCode2 = data.code;
                              Map<String, dynamic> params =
                                  Map<String, dynamic>();
                              params['ser_id'] = widget.pay2Id.toString();
                              params['importance'] = '3';
                              print('commande service 3');
                              await storeCommandServices(params, _commandCode2)
                                  .then((data) async {
                                if (data != null) {
                                  progress.show();
                                  params['ser_id'] = widget.liv2Id.toString();
                                  params['importance'] = '3';
                                  print('commande service 4');
                                  await storeCommandServices(
                                          params, _commandCode2)
                                      .then((data) {
                                    progress.dismiss();
                                    if (data != null) {
                                      om.isNotEmpty
                                          ? Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      OrangeMoneyPayment(
                                                        shops: widget.shops,
                                                        items: widget.items,
                                                        quantities:
                                                            widget.quantities,
                                                        pay1: widget.pay1Price,
                                                        liv1: widget.liv1Price,
                                                        pay2: widget.pay2Price,
                                                        liv2: widget.liv2Price,
                                                        mailCode1:
                                                            _commandCode1,
                                                        mailCode2:
                                                            _commandCode2,
                                                        names: widget.names,
                                                      )))
                                          : momo.isNotEmpty
                                              ? Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MoMoPayment(
                                                            pay1: widget
                                                                .pay1Price,
                                                            liv1: widget
                                                                .liv1Price,
                                                            pay2: widget
                                                                .pay2Price,
                                                            liv2: widget
                                                                .liv2Price,
                                                            shops: widget.shops,
                                                            items: widget.items,
                                                            mailCode1:
                                                                _commandCode1,
                                                            mailCode2:
                                                                _commandCode2,
                                                            quantities: widget
                                                                .quantities,
                                                            names: widget.names,
                                                          )))
                                              : Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          DeliveryPage(
                                                            code1:
                                                                _commandCode1,
                                                            code2:
                                                                _commandCode2,
                                                          )));
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                actions: <Widget>[
                                                  FlatButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text('Ok')),
                                                ],
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5.0))),
                                                elevation: 15.0,
                                                title: Text('Erreur'),
                                                content: Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.warning,
                                                      color: Colors.red,
                                                      size: 30.0,
                                                    ),
                                                    SizedBox(
                                                      width: 10.0,
                                                    ),
                                                    Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            1.1,
                                                        child: Text(
                                                            'Impossible de valider le mode de livraison de la boutique ${widget.names[1]}. Verifier votre connexion internet et reessayer.'))
                                                  ],
                                                ),
                                              ));
                                    }
                                  });
                                } else {
                                  progress.dismiss();
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            actions: <Widget>[
                                              FlatButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('Ok')),
                                            ],
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5.0))),
                                            elevation: 15.0,
                                            title: Text('Erreur'),
                                            content: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.warning,
                                                  color: Colors.red,
                                                  size: 30.0,
                                                ),
                                                SizedBox(
                                                  width: 10.0,
                                                ),
                                                Container(
                                                    width: 400.0,
                                                    child: Text(
                                                        'Impossible de confirmer la paiement de la boutique ${widget.names[1]}. Verifier votre connexion internet et reessayer.'))
                                              ],
                                            ),
                                          ));
                                }
                              });
                            } else {
                              progress.dismiss();
                              SweetAlert.show(context,
                                  title: 'Une erreur est survenue',
                                  subtitle:
                                      'Verifier votre connexion internet et reessayer.',
                                  style: SweetAlertStyle.error);
                            }
                          });
                        } else {
                          progress.dismiss();
                          SweetAlert.show(context,
                              title: 'Une erreur est survenue',
                              subtitle:
                                  'Verifier votre connexion internet et reessayer.',
                              style: SweetAlertStyle.error);
                        }
                        return null;
                      });
                    } else {
                      progress.dismiss();
                      om.isNotEmpty
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OrangeMoneyPayment(
                                        shops: widget.shops,
                                        items: widget.items,
                                        quantities: widget.quantities,
                                        pay1: widget.pay1Price,
                                        liv1: widget.liv1Price,
                                        pay2: widget.pay2Price,
                                        liv2: widget.liv2Price,
                                        mailCode1: _commandCode1,
                                        names: widget.names,
                                      )))
                          : momo.isNotEmpty
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MoMoPayment(
                                            pay1: widget.pay1Price,
                                            liv1: widget.liv1Price,
                                            pay2: widget.pay2Price,
                                            liv2: widget.liv2Price,
                                            shops: widget.shops,
                                            items: widget.items,
                                            mailCode1: _commandCode1,
                                            quantities: widget.quantities,
                                            names: widget.names,
                                          )))
                              : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DeliveryPage(code1: _commandCode1)));
                    }
                  } else {
                    progress.dismiss();
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              actions: <Widget>[
                                FlatButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Ok')),
                              ],
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0))),
                              elevation: 15.0,
                              title: Text('Erreur'),
                              content: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.warning,
                                    color: Colors.red,
                                    size: 30.0,
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Container(
                                      width: MediaQuery.of(context).size.width /
                                          1.1,
                                      child: Text(
                                          'Impossible de valider le mode de livraison de la boutique ${widget.names[0]}. Verifier votre connexion internet et reessayer.'))
                                ],
                              ),
                            ));
                  }
                });
              } else {
                progress.dismiss();
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          actions: <Widget>[
                            FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Ok')),
                          ],
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0))),
                          elevation: 15.0,
                          title: Text('Erreur'),
                          content: Row(
                            children: <Widget>[
                              Icon(
                                Icons.warning,
                                color: Colors.red,
                                size: 30.0,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Container(
                                  width: 400.0,
                                  child: Text(
                                      'Impossible de confirmer la paiement de la boutique ${widget.names[0]}. Verifier votre connexion internet et reessayer.'))
                            ],
                          ),
                        ));
              }
            });
          } else {
            progress.dismiss();
            SweetAlert.show(context,
                title: 'Une erreur est survenue',
                subtitle: 'Verifier votre connexion internet et reessayer.',
                style: SweetAlertStyle.error);
          }
        });
      } else {
        progress.dismiss();
        SweetAlert.show(context,
            title: 'Une erreur est survenue',
            subtitle: 'Verifier votre connexion internet et reessayer.',
            style: SweetAlertStyle.error);
      }
      return null;
    });
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
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width - 20.0,
        height: 50.0,
        child: Row(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * .6,
              height: 41.0,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    widget.liv2Price == null
                        ? 'Total: ${widget.amount + widget.pay1Price + widget.liv1Price} Fcfa'
                        : 'Total: ${widget.amount + widget.pay1Price + widget.liv1Price + widget.liv2Price + widget.pay2Price} Fcfa',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                createData();
              },
              child: Container(
                width: MediaQuery.of(context).size.width * .4,
                color: Colors.orange,
                child: Center(
                  child: Text(
                    'Terminer',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                ),
              ),
            )
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
                FinalisationMenu(2),
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      'Informations personnelles',
                                      style: TextStyle(
                                          fontSize: 15.0, color: Colors.grey),
                                    ),
                                  ],
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
                                      style: TextStyle(fontSize: 15.0),
                                    )
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      snapshot.data['email'],
                                      style: TextStyle(fontSize: 18.0),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      '${snapshot.data['street']} - ${snapshot.data['address']}',
                                      style: TextStyle(fontSize: 18.0),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      '${snapshot.data['town']} - ${snapshot.data['country']}',
                                      style: TextStyle(fontSize: 18.0),
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
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              'Sous total produit: ',
                              style: TextStyle(fontSize: 15.0),
                            ),
                            Spacer(),
                            Text(
                              '${widget.amount} Fcfa',
                              style: TextStyle(fontSize: 15.0),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              'Frais de service: ',
                              style: TextStyle(fontSize: 15.0),
                            ),
                            Spacer(),
                            Text(
                              widget.liv2Price == null
                                  ? '${widget.liv1Price + widget.pay1Price} Fcfa'
                                  : '${widget.liv1Price + widget.liv2Price + widget.pay1Price + widget.pay2Price} Fcfa',
                              style: TextStyle(fontSize: 15.0),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              'Total: ',
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            Text(
                              widget.liv2Price == null
                                  ? 'Total: ${widget.amount + widget.pay1Price + widget.liv1Price} Fcfa'
                                  : 'Total: ${widget.amount + widget.pay1Price + widget.liv1Price + widget.liv2Price + widget.pay2Price} Fcfa',
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
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
