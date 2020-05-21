import 'package:client_bos_final/common/globals.dart';
import 'package:client_bos_final/custom/navigation_bar.dart';
import 'package:client_bos_final/custom/sweetAlert.dart';
import 'package:client_bos_final/screens/auth/login.dart';
import 'package:client_bos_final/screens/cart/finalisation.dart';
import 'package:client_bos_final/screens/product/showProduct.dart';
import 'package:flutter/material.dart';
import 'package:sweetalert/sweetalert.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Future _dailyDeals;

  @override
  void initState() {
    super.initState();
    _dailyDeals = getDailyDeals();
  }

  void changeQuantity(int price, String sign) {
    setState(() {
      setTotal(price, sign);
    });
  }

  _fetchData() async {
    _dailyDeals = getDailyDeals();
  }

  Future<Null> refreshData() async {
    await _fetchData();
    return null;
  }

  void _deleteItem(int index) {
    setState(() {
      cartNames.removeAt(index);
      cartDescription.removeAt(index);
      commandShopIds.removeAt(index);
      shopNames.removeAt(index);
      setNumberOfShopInCommand();
      setTotal(
          carts[index].newPrice == 0 || carts[index].newPrice == null
              ? carts[index].oldPrice * quantities[index]
              : carts[index].newPrice * quantities[index],
          '-');
      quantities.removeAt(index);
      length--;
      setCartLength(length);
      setCartQuantities(quantities);
      carts.removeAt(index);
      storeProductCart(carts);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(length > 1
              ? 'Mon panier ($length articles)'
              : 'Mon panier ($length article)'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
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
              },
            )
          ],
        ),
        bottomNavigationBar: CustomNavigationBar(3),
        body: RefreshIndicator(
          onRefresh: () async {
            await refreshData();
          },
          child: Container(
              color: Colors.grey.withOpacity(.2),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: FutureBuilder(
                future: getCartTotal(),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('${snapshot.error}'),
                    );
                  }
                  if (snapshot.hasData) {
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 10.0,
                          ),
                          carts.isEmpty
                              ? Container(
                                  color: Colors.white,
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * .55,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.remove_shopping_cart,
                                          size: 100.0,
                                        ),
                                        Text('Vous n\'avez aucun article')
                                      ],
                                    ),
                                  ),
                                )
                              : Container(
                                  color: Colors.white,
                                  width: MediaQuery.of(context).size.width,
                                  height: 150.0 * carts.length,
                                  child: ListView.builder(
                                    physics: ScrollPhysics(parent: null),
                                    itemCount: carts.length,
                                    itemBuilder: (BuildContext context, index) {
                                      return InkWell(
                                        onTap: () {},
                                        onLongPress: () {},
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 35.0, right: 8.0),
                                          child: Container(
                                            height: 150.0,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 12.0),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Spacer(),
                                                      Text(
                                                          'Vendeur: ${carts[index].shopName ?? 'Non renseigne'}'),
                                                    ],
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Container(
                                                      height: 120.0,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Stack(
                                                            children: <Widget>[
                                                              Container(
                                                                height: 120,
                                                                width: 120.0,
                                                                child: Image
                                                                    .network(
                                                                  imagePath(carts[
                                                                          index]
                                                                      .photo),
                                                                  fit: BoxFit
                                                                      .fill,
                                                                ),
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    _deleteItem(
                                                                        index);
                                                                  });
                                                                },
                                                                child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .topLeft,
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        bottom:
                                                                            15.0),
                                                                    child: Container(
                                                                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(40.0)), color: Colors.red),
                                                                        width: 50.0,
                                                                        height: 50.0,
                                                                        child: Align(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          child:
                                                                              Icon(
                                                                            Icons.delete_outline,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        )),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        12.0),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  carts[index]
                                                                              .name
                                                                              .length >
                                                                          15
                                                                      ? '${carts[index].name.substring(0, 15)}...'
                                                                      : '${carts[index].name}',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          17.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                SizedBox(
                                                                  height: 5.0,
                                                                ),
                                                                Text(carts[index].newPrice ==
                                                                            0 ||
                                                                        carts[index].newPrice ==
                                                                            null
                                                                    ? '${carts[index].oldPrice} Fcfa'
                                                                    : '${carts[index].newPrice} Fcfa'),
                                                                Spacer(),
                                                                Container(
                                                                  height: 20.0,
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      .45,
                                                                  child: Row(
                                                                    children: <
                                                                        Widget>[
                                                                      Spacer(),
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          if (quantities[index] ==
                                                                              1) {
                                                                            showDialog(
                                                                                context: context,
                                                                                builder: (BuildContext context) {
                                                                                  return AlertDialog(
                                                                                    actions: <Widget>[
                                                                                      OutlineButton(
                                                                                        child: Text(
                                                                                          'Continuer',
                                                                                          style: TextStyle(color: Colors.green),
                                                                                        ),
                                                                                        onPressed: () {
                                                                                          Navigator.pop(context);
                                                                                          setState(() {
                                                                                            _deleteItem(index);
                                                                                          });
                                                                                        },
                                                                                      ),
                                                                                      OutlineButton(
                                                                                        onPressed: () {
                                                                                          Navigator.pop(context);
                                                                                        },
                                                                                        child: Text(
                                                                                          'Annuler',
                                                                                          style: TextStyle(color: Colors.red),
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                    title: Text('Suppression'),
                                                                                    content: Text('Vous allez supprimer cet article'),
                                                                                  );
                                                                                });
                                                                          } else {
                                                                            setState(() {
                                                                              quantities[index]--;
                                                                              setCartQuantities(quantities);
                                                                              changeQuantity(carts[index].newPrice == 0 || carts[index].newPrice == null ? carts[index].oldPrice : carts[index].newPrice, '-');
                                                                            });
                                                                          }
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              40.0,
                                                                          child:
                                                                              Icon(
                                                                            Icons.remove_circle,
                                                                            color:
                                                                                Colors.grey,
                                                                            size:
                                                                                20.0,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                3.0,
                                                                            vertical:
                                                                                3.0),
                                                                        child: Text(index <
                                                                                quantities.length
                                                                            ? quantities[index].toString()
                                                                            : '1'),
                                                                      ),
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            quantities[index]++;
                                                                            setCartQuantities(quantities);
                                                                            changeQuantity(carts[index].newPrice == 0 || carts[index].newPrice == null ? carts[index].oldPrice : carts[index].newPrice,
                                                                                '+');
                                                                          });
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              40.0,
                                                                          child:
                                                                              Icon(
                                                                            Icons.add_circle,
                                                                            color:
                                                                                Colors.grey,
                                                                            size:
                                                                                20.0,
                                                                          ),
                                                                        ),
                                                                      )
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
                                        ),
                                      );
                                    },
                                  ),
                                ),
                          SizedBox(
                            height: 10.0,
                          ),
                          FutureBuilder(
                            future: _dailyDeals,
                            builder: (BuildContext context, snapshot) {
                              if (snapshot.hasData) {
                                List data = [];
                                for (var item in snapshot.data) {
                                  if (!data.contains(item)) {
                                    data.add(item);
                                  }
                                }
                                return data.isEmpty
                                    ? SizedBox(
                                        height: 0,
                                      )
                                    : Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        color: Colors.white,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                'Meilleures offres',
                                                style:
                                                    TextStyle(fontSize: 15.0),
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: data.length >= 4
                                                  ? 135.0 * 2
                                                  : 135.0,
                                              child: GridView.builder(
                                                  padding: EdgeInsets.only(
                                                      top: 10.0),
                                                  physics: ScrollPhysics(
                                                      parent: null),
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisCount: 3),
                                                  itemCount: data.length >= 6
                                                      ? 6
                                                      : data.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          index) {
                                                    return InkWell(
                                                      onTap: () {
                                                        if (recents.contains(
                                                            data[index])) {
                                                          recents
                                                              .add(data[index]);
                                                        }
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ShowProductPage(
                                                                      code: data[
                                                                              index]
                                                                          .code),
                                                            ));
                                                      },
                                                      child: Column(
                                                        children: <Widget>[
                                                          Stack(
                                                            children: <Widget>[
                                                              Container(
                                                                width: 90,
                                                                height: 90.0,
                                                                child:
                                                                    Container(
                                                                  width: 70,
                                                                  height: 70.0,
                                                                  child: Image
                                                                      .network(
                                                                    imagePath(
                                                                        '${data[index].photo}'),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              ),
                                                              data[index].newPrice ==
                                                                          0 ||
                                                                      data[index]
                                                                              .newPrice ==
                                                                          null
                                                                  ? Container()
                                                                  : Container(
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .red,
                                                                          borderRadius:
                                                                              BorderRadius.only(bottomRight: Radius.circular(10.0))),
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(3.0),
                                                                        child:
                                                                            Text(
                                                                          '-${discountPercent(data[index].oldPrice, data[index].newPrice)}%',
                                                                          style: TextStyle(
                                                                              fontSize: 10.0,
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                      ),
                                                                    ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 7.0,
                                                          ),
                                                          Text(
                                                            data[index].newPrice ==
                                                                        0 ||
                                                                    data[index]
                                                                            .newPrice ==
                                                                        null
                                                                ? '${data[index].oldPrice} Fcfa'
                                                                : '${data[index].newPrice} Fcfa',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }),
                                            ),
                                          ],
                                        ));
                              }
                              if (snapshot.hasError) {
                                return Center(
                                  child: Text('${snapshot.error}'),
                                );
                              }
                              return Container();
                            },
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            color: Colors.white,
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width * .6,
                                  height: 50.0,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text('Total: $total Fcfa',
                                            style: TextStyle(fontSize: 15.0))),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width * .4,
                                  height: 50.0,
                                  color: Colors.deepOrangeAccent,
                                  child: Center(
                                    child: FutureBuilder(
                                      future: isLogged(),
                                      builder:
                                          (BuildContext context, snapshot) {
                                        if (snapshot.hasError) {
                                          return Center(
                                            child: Text('${snapshot.error}'),
                                          );
                                        }
                                        if (snapshot.hasData) {
                                          return snapshot.data
                                              ? FutureBuilder(
                                                  future: getCurrentUser(),
                                                  builder:
                                                      (BuildContext context,
                                                          snapshot) {
                                                    if (snapshot.hasData) {
                                                      return InkWell(
                                                        onTap: () {
                                                          carts.isEmpty
                                                              ? sweetalert(
                                                                  context:
                                                                      context,
                                                                  withConfirmation:
                                                                      false,
                                                                  subtitle:
                                                                      'Votre panier est vide',
                                                                  type: SweetAlertStyle
                                                                      .confirm)
                                                              : Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) => FinalisationPage(
                                                                          userId: snapshot.data[
                                                                              'id'],
                                                                          items:
                                                                              carts,
                                                                          total:
                                                                              total,
                                                                          quantities:
                                                                              quantities)));
                                                        },
                                                        child: Text(
                                                          'Verification($length)',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 18.0),
                                                        ),
                                                      );
                                                    }
                                                    return Container();
                                                  },
                                                )
                                              : InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    LoginPage(
                                                                      redirection:
                                                                          CartPage(),
                                                                    )));
                                                  },
                                                  child: Text('Connectez-vous',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15.0)),
                                                );
                                        }
                                        return Center(
                                            child: CircularProgressIndicator());
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              )),
        ));
  }
}
