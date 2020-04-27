import 'package:client_bos_final/common/globals.dart';
import 'package:client_bos_final/custom/sweetAlert.dart';
import 'package:client_bos_final/model/shops.dart';
import 'package:client_bos_final/screens/product/products.dart';
import 'package:client_bos_final/screens/search/search.dart';
import 'package:client_bos_final/service/homeService.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:sweetalert/sweetalert.dart';

class ShopPage extends StatefulWidget {
  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  Future<List<Shop>> shops;

  @override
  void initState() {
    super.initState();
    shops = fetchShops();
  }

  _fetchData() {
    shops = fetchShops();
    Navigator.popAndPushNamed(context, '/shop');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            color: Colors.black.withOpacity(.7),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchPage()));
            },
          ),
        ],
        title: Center(
          child: Text('Boutiques'),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10.0,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 30.0,
            child: Row(
              children: <Widget>[
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
                  child: Text(
                    'Triage par defaut',
                    style: TextStyle(fontSize: 10.0),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Spacer(),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 10.0,
                    ),
                    Spacer(),
                  ],
                ),
                Spacer(),
                Icon(
                  Icons.tune,
                  size: 18.0,
                  color: Colors.deepOrange,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0, left: 3.0),
                  child: Text(
                    'Filtre',
                    style: TextStyle(color: Colors.deepOrange, fontSize: 13.0),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: FutureBuilder(
                future: shops,
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  if (snapshot.hasData) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height - 135.0,
                      child: RefreshIndicator(
                        onRefresh: () async {
                          await _refreshData();
                        },
                        child: ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProductsPage(
                                              shop: snapshot.data[index],
                                            )));
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 30.0),
                                child: Container(
                                    child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 20.0),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        width: 90,
                                        height: 120.0,
                                        child: Image.network(
                                          imagePath(
                                              snapshot.data[index].photo ??
                                                  'shops/clothes_shop.jpg'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 18.0, vertical: 4.0),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .56,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                snapshot.data[index].name,
                                                style: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(.6)),
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  renderStars(snapshot
                                                      .data[index].rate),
                                                  SizedBox(
                                                    width: 3.0,
                                                  ),
                                                  Text(
                                                      '${parseIntToDouble(snapshot.data[index].rate)}'),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Spacer(),
                                                  Icon(Icons.more_vert)
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }

                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ))
        ],
      ),
    );
  }
}
