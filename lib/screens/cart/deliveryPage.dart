import 'package:client_bos_final/common/globals.dart';
import 'package:client_bos_final/custom/menu_finalisation.dart';
import 'package:client_bos_final/icons/socicon_icons.dart';
import 'package:client_bos_final/screens/home/home.dart';
import 'package:client_bos_final/service/commandService.dart';
import 'package:flutter/material.dart';

class DeliveryPage extends StatefulWidget {
  DeliveryPage({this.code1, this.code2});
  final String code1;
  final String code2;
  @override
  _DeliveryPageState createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage> {
  Future<bool> _mailSend1, _mailSend2;

  @override
  void initState() {
    super.initState();
    setState(() {
      carts = [];
      quantities = [];
      cartDescription = [];
      cartNames = [];
      length = 0;
      clearShopInCommand();
      setCartLength(length);
      clearTotal();
      setCartQuantities(quantities);
      storeProductCart(carts);
    });

    _mailSend1 = sendRecapMail(widget.code1);
    if (widget.code2 != null) {
      _mailSend2 = sendRecapMail(widget.code2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Center(
            child: Text('Commande enregistree'),
          ),
          leading: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        bottomNavigationBar: Container(
          color: Color(0xffecf5f5),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: <Widget>[
                Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(0xff53c8ef),
                        borderRadius: BorderRadius.all(Radius.circular(30.0))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(15.0, 8.0, 5.0, 8.0),
                          child: Icon(
                            Socicon.homes,
                            color: Color(0xffecf5f5),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 8.0, 15.0, 8.0),
                          child: Text('Accueil',
                              style: TextStyle(color: Color(0xffecf5f5))),
                        )
                      ],
                    ),
                  ),
                ),
                Spacer()
              ],
            ),
          ),
        ),
        body: FutureBuilder(
            future: _mailSend1,
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data) {
                  if (widget.code2 != null) {
                    return FutureBuilder(
                      future: _mailSend2,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            color: Color(0xffecf5f5),
                            child: Column(
                              children: <Widget>[
                                FinalisationMenu(2),
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        'img/success.gif',
                                        fit: BoxFit.cover,
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Center(
                                            child: Text(
                                              'Vous avez recu un mail descriptif de votre commande et nous vous contacterons lorsque votre commande sera prete... L\'equipe Buy On Send vous remercie et vous donne rendez-vous lors de vos prochains achats',
                                              textAlign: TextAlign.justify,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        if (snapshot.hasError) {
                          return Text(
                              'impossible d\'envoyer le mail recapitulatif');
                        }
                        return Container(
                          color: Color(0xffecf5f5),
                          child: Column(
                            children: <Widget>[
                              FinalisationMenu(2),
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                      'img/success.gif',
                                      fit: BoxFit.cover,
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Center(
                                          child: Text(
                                            'Vous recevrez un mail descriptif de votre commande sous peu...',
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return Container(
                      color: Color(0xffecf5f5),
                      child: Column(
                        children: <Widget>[
                          FinalisationMenu(2),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  'img/success.gif',
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Center(
                                      child: Text(
                                        'Vous avez recu un mail descriptif de votre commande et nous vous contacterons lorsque votre commande sera prete... L\'equipe Buy On Send vous remercie et vous donne rendez-vous lors de vos prochains achats',
                                        textAlign: TextAlign.justify,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                } else {
                  return Text('impossible d\'envoyer le mail recapitulatif');
                }
              }
              return Container(
                color: Color(0xffecf5f5),
                child: Column(
                  children: <Widget>[
                    FinalisationMenu(2),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'img/success.gif',
                            fit: BoxFit.cover,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Center(
                                child: Text(
                                  'Vous recevrez un mail descriptif de votre commande sous peu...',
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }));
  }
}
