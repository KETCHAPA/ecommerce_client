import 'package:client_bos_final/common/globals.dart';
import 'package:client_bos_final/custom/navigation_bar.dart';
import 'package:client_bos_final/icons/awesome_icons.dart';
import 'package:client_bos_final/icons/car_icons.dart';
import 'package:client_bos_final/icons/favorite_icons.dart';
import 'package:client_bos_final/icons/icon_data.dart';
import 'package:client_bos_final/icons/setting_icons.dart';
import 'package:client_bos_final/screens/account/recently.dart';
import 'package:client_bos_final/screens/account/update.dart';
import 'package:client_bos_final/screens/auth/login.dart';
import 'package:client_bos_final/screens/auth/register.dart';
import 'package:client_bos_final/screens/command/commands.dart';
import 'package:client_bos_final/screens/discount/discounts.dart';
import 'package:client_bos_final/service/accountService.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Color _color1 = Color(0xff00aedf);
  Color _color2 = Color(0xff63e68e);
  Color _color3 = Color(0xff5b86e5);
  String userCode;
  bool userIsLogIn;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CustomNavigationBar(4),
        body: FutureBuilder(
            future: isLogged(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
              if (snapshot.hasData) {
                userIsLogIn = snapshot.data;
                return ListView(
                  children: <Widget>[
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * .3,
                        child: Stack(
                          children: <Widget>[
                            SafeArea(
                              top: true,
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * .22,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [_color1, _color2]),
                                    borderRadius: BorderRadius.vertical(
                                        bottom: Radius.circular(30.0))),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {},
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Icon(AwesomeIcons.qr_code,
                                            color: Colors.white),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, '/settings');
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Icon(Settings.settings_gears,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                width: MediaQuery.of(context).size.width * .95,
                                height: 130.0,
                                child: Card(
                                  elevation: 10.0,
                                  child: Center(
                                      child: FutureBuilder(
                                    future: isLogged(),
                                    builder: (BuildContext context, snapshot) {
                                      if (snapshot.hasError) {
                                        return Center(
                                          child: Text('${snapshot.error}'),
                                        );
                                      }
                                      if (snapshot.hasData) {
                                        return snapshot.data
                                            ? FutureBuilder(
                                                future: getCurrentUser(),
                                                builder: (BuildContext context,
                                                    snapshot) {
                                                  if (snapshot.hasData) {
                                                    userCode =
                                                        snapshot.data['code'];
                                                    return Row(
                                                      children: <Widget>[
                                                        Container(
                                                          height: 70,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.25,
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      20.0),
                                                          child: ClipOval(
                                                            child:
                                                                Image.network(
                                                              imagePath(snapshot
                                                                              .data[
                                                                          'photo'] !=
                                                                      null
                                                                  ? snapshot
                                                                          .data[
                                                                      'photo']
                                                                  : snapshot.data[
                                                                              'gender'] ==
                                                                          'femme'
                                                                      ? 'users/avatar2.jpg'
                                                                      : 'users/avatar.jpg'),
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          height: 130.0,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              .55,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              InkWell(
                                                                onTap: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              UpdateData(user: snapshot.data)));
                                                                },
                                                                child: Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                      snapshot
                                                                          .data[
                                                                              'name']
                                                                          .toUpperCase(),
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              12.0),
                                                                    ),
                                                                    Spacer(),
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(builder: (context) => UpdateData(user: snapshot.data)));
                                                                      },
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .mode_edit,
                                                                        size:
                                                                            14.0,
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              UpdateData(user: snapshot.data)));
                                                                },
                                                                child: Text(
                                                                    snapshot.data[
                                                                        'email']),
                                                              ),
                                                              Text(
                                                                  snapshot.data[
                                                                      'phone']),
                                                              snapshot.data['country'] ==
                                                                          null &&
                                                                      snapshot.data[
                                                                              'towh'] ==
                                                                          null
                                                                  ? SizedBox(
                                                                      height:
                                                                          0.0,
                                                                    )
                                                                  : Row(
                                                                      children: <
                                                                          Widget>[
                                                                        Text(snapshot.data['country'] ??
                                                                            ''),
                                                                        snapshot.data['town'] ==
                                                                                null
                                                                            ? Text('')
                                                                            : Text(' - '),
                                                                        Text(snapshot.data['town'] ??
                                                                            ''),
                                                                      ],
                                                                    ),
                                                              snapshot.data['address'] ==
                                                                          null &&
                                                                      snapshot.data[
                                                                              'street'] ==
                                                                          null
                                                                  ? SizedBox(
                                                                      height:
                                                                          0.0,
                                                                    )
                                                                  : Row(
                                                                      children: <
                                                                          Widget>[
                                                                        Text(snapshot.data['address'] ??
                                                                            ''),
                                                                        snapshot.data['street'] ==
                                                                                null
                                                                            ? Text('')
                                                                            : Text(' - '),
                                                                        Text(snapshot.data['street'] ??
                                                                            '')
                                                                      ],
                                                                    )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  }
                                                  if (snapshot.hasError) {
                                                    return Center(
                                                      child: Text(
                                                          '${snapshot.error}'),
                                                    );
                                                  }
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                },
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        LoginPage(
                                                                          redirection:
                                                                              AccountPage(),
                                                                        )));
                                                      },
                                                      child: Text(
                                                        'Connexion / ',
                                                        style: TextStyle(
                                                            fontSize: 15.0,
                                                            color: _color3),
                                                      )),
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  RegisterPage(
                                                                      redirection:
                                                                          AccountPage())));
                                                    },
                                                    child: Text(
                                                      'Inscription',
                                                      style: TextStyle(
                                                          fontSize: 15.0,
                                                          color: _color3),
                                                    ),
                                                  )
                                                ],
                                              );
                                      }
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                  )),
                                ),
                              ),
                            )
                          ],
                        )),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 14.0, top: 10.0, right: 20.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Mes Commandes',
                            style: TextStyle(fontSize: 15.0),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              userIsLogIn
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CommandPage(
                                                code: userCode,
                                                title: 'Vos Commandes',
                                                filter: 'toutes_vos_commandes',
                                              )))
                                  : Container();
                            },
                            child: Text(
                              'Tout voir ->',
                              style: TextStyle(
                                  color: userIsLogIn ? _color3 : Colors.grey,
                                  fontSize: 10.0),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                userIsLogIn
                                    ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => CommandPage(
                                                  code: userCode,
                                                  title: 'Commandes en attente',
                                                  filter: 'en_attente',
                                                )))
                                    : Container();
                              },
                              child: Column(
                                children: <Widget>[
                                  Icon(
                                    IconDatas.hourglass,
                                    color: userIsLogIn ? _color3 : Colors.grey,
                                    size: 30.0,
                                  ),
                                  Text('En Attente')
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                userIsLogIn
                                    ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => CommandPage(
                                                  code: userCode,
                                                  title: 'Commandes en route',
                                                  filter: 'en_route',
                                                )))
                                    : Container();
                              },
                              child: Column(
                                children: <Widget>[
                                  Icon(
                                    CarIcons.taxi,
                                    color: userIsLogIn ? _color3 : Colors.grey,
                                    size: 30.0,
                                  ),
                                  Text('En route')
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                userIsLogIn
                                    ? showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title:
                                                Text('Retour et remboursement'),
                                            content: Text(
                                                'Regles de retour et remboursement'),
                                          );
                                        })
                                    : Container();
                              },
                              child: Column(
                                children: <Widget>[
                                  Icon(
                                    AwesomeIcons.stopwatch,
                                    color: userIsLogIn ? _color3 : Colors.grey,
                                    size: 20.0,
                                  ),
                                  Text('Retour et'),
                                  Text('remboursement')
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 10.0,
                      color: Colors.grey,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/favoriteItems');
                      },
                      child: ListTile(
                        leading: Icon(
                          AddToFavorites.add_to_favorite,
                          color: _color3,
                        ),
                        title: Text('Favoris'),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RecentlyProductPage()));
                      },
                      child: ListTile(
                        leading: Icon(
                          AwesomeIcons.clockwise,
                          color: _color3,
                        ),
                        title: Text('Vu recemment'),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        userIsLogIn
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DiscountPage(code: userCode)))
                            : Container();
                      },
                      child: ListTile(
                        leading: Icon(
                          AwesomeIcons.coupon,
                          color: userIsLogIn ? _color3 : Colors.grey,
                        ),
                        title: Text('Mes coupons'),
                        trailing: Container(
                          width: 80.0,
                          child: Row(
                            children: <Widget>[
                              Text('Montant: ',
                                  style: TextStyle(
                                      color:
                                          userIsLogIn ? _color3 : Colors.grey,
                                      fontSize: 10.0)),
                              userIsLogIn
                                  ? FutureBuilder(
                                      future: getCurrentUser(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return FutureBuilder(
                                              future: fetchDiscountAmount(
                                                  snapshot.data['code']),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  return Text(
                                                      snapshot.data.toString(),
                                                      style: TextStyle(
                                                          color: _color3,
                                                          fontSize: 10.0));
                                                }
                                                return Text('0',
                                                    style: TextStyle(
                                                        color: _color3,
                                                        fontSize: 10.0));
                                              });
                                        }
                                        return Text('0',
                                            style: TextStyle(
                                                color: _color3,
                                                fontSize: 10.0));
                                      })
                                  : Text('0',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 10.0)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.style,
                        color: userIsLogIn ? _color3 : Colors.grey,
                      ),
                      title: Text('Mes Buy-Pay'),
                      trailing: Container(
                        width: 50.0,
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Solde:',
                              style: TextStyle(
                                  color: userIsLogIn ? _color3 : Colors.grey,
                                  fontSize: 10.0),
                            ),
                            Text(
                              '0',
                              style: TextStyle(
                                  color: userIsLogIn ? _color3 : Colors.grey,
                                  fontSize: 10.0),
                            )
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 10.0,
                      color: Colors.grey,
                    ),
                    ListTile(
                      leading: Icon(
                        AwesomeIcons.address,
                        color: userIsLogIn ? _color3 : Colors.grey,
                      ),
                      title: Text('Management des adresses'),
                    ),
                    InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Service Clientele'),
                                content: Container(
                                  height: 50.0,
                                  width: MediaQuery.of(context).size.width / 3,
                                  child: Column(
                                    children: <Widget>[
                                      Text('Veuillez contacter le '),
                                      Text('+33 844 8483',
                                          style: TextStyle(color: Colors.red))
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                      child: ListTile(
                        leading: Icon(
                          Icons.devices_other,
                          color: _color3,
                        ),
                        title: Text('Service Clienteles'),
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        AwesomeIcons.love_letter,
                        color: userIsLogIn ? _color3 : Colors.grey,
                      ),
                      title: Text('Inviter un(e) ami(e)'),
                    ),
                  ],
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}
