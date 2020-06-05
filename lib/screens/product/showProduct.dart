import 'package:client_bos_final/common/globals.dart';
import 'package:client_bos_final/icons/cart_icons.dart';
import 'package:client_bos_final/icons/favorite_icons.dart';
import 'package:client_bos_final/model/categories.dart';
import 'package:client_bos_final/model/products.dart';
import 'package:client_bos_final/service/productService.dart';
import 'package:flutter/material.dart';
import 'package:sweetalert/sweetalert.dart';

class ShowProductPage extends StatefulWidget {
  final String code;
  ShowProductPage({@required this.code});
  @override
  _ShowProductPageState createState() => _ShowProductPageState();
}

class _ShowProductPageState extends State<ShowProductPage> {
  Future<Map> productSpecs;
  Product product;
  List<Category> categories = [];
  List categoryMap = [], pics = [];
  int nbrPics = 0;
  Future _reviews;

  String format(String date) {
    DateTime data = DateTime.parse(date);
    return '${data.day} ${months[data.month - 1]} ${data.year}';
  }

  String estimateDate() {
    DateTime now = DateTime.now();
    DateTime firstDate, secondDate;
    firstDate = now.add(Duration(hours: 48));
    secondDate = now.add(Duration(hours: 144));

    return '${firstDate.day} ${months[firstDate.month - 1]} - ${secondDate.day} ${months[secondDate.month - 1]}';
  }

  @override
  void initState() {
    super.initState();
    productSpecs = fetchProduct(widget.code);
    _reviews = fetchAllReviews(widget.code);
  }

  int _selectedItem = 0;
  Widget _pageSelectedIndex(int length) {
    return Container(
      width: 60.0,
      height: 20.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: ScrollPhysics(parent: null),
        itemCount: length,
        itemBuilder: (BuildContext context, int index) {
          return Icon(
            Icons.brightness_1,
            size: 7.0,
            color: index == _selectedItem ? Colors.black : Colors.blueGrey,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: FutureBuilder(
          future: productSpecs,
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                width: MediaQuery.of(context).size.width - 20.0,
                height: 50.0,
                child: Row(
                  children: <Widget>[
                    InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/carts');
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * .3,
                          height: 41.0,
                          child: Column(
                            children: <Widget>[
                              Container(
                                  width: 40.0,
                                  height: 23.0,
                                  child: Stack(fit: StackFit.expand, children: <
                                      Widget>[
                                    Icon(
                                        Cart.shopping_cart_of_horizontal_lines_design,
                                        color: Colors.black),
                                    Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                          width: 13.0,
                                          height: 13.0,
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                  begin: Alignment.topRight,
                                                  end: Alignment.bottomLeft,
                                                  colors: [
                                                    Colors.red,
                                                    Colors.deepOrangeAccent
                                                  ]),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20.0))),
                                          child: Center(
                                              child: Text('$length',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10.0))),
                                        ))
                                  ])),
                              Text('Panier')
                            ],
                          ),
                        )),
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (canAddProduct(product)) {
                            if (cartDescription.contains(
                                    product.description.toLowerCase()) &&
                                cartNames
                                    .contains(product.name.toLowerCase())) {
                              quantities[cartNames
                                  .lastIndexOf(product.name.toLowerCase())]++;
                              setCartQuantities(quantities);
                              evaluateTotal(product.newPrice == 0 ||
                                      product.newPrice == null
                                  ? product.oldPrice
                                  : product.newPrice);
                            } else {
                              cartNames.add(product.name.toLowerCase());
                              cartDescription
                                  .add(product.description.toLowerCase());
                              carts.add(product);
                              storeProductCart(carts);
                              quantities.add(1);
                              setCartQuantities(quantities);
                              length = carts.length;
                              setCartLength(length);
                              evaluateTotal(product.newPrice == 0 ||
                                      product.newPrice == null
                                  ? product.oldPrice
                                  : product.newPrice);
                              commandShopIds.add(product.shopId);
                              shopNames.add(product.shopName);
                              setNumberOfShopInCommand();
                            }
                            new Future.delayed(new Duration(seconds: 2), () {
                              SweetAlert.show(context,
                                  subtitle: 'Produit ajoute au panier',
                                  style: SweetAlertStyle.success);
                            });
                          } else {
                            new Future.delayed(new Duration(seconds: 2), () {
                              SweetAlert.show(context,
                                  subtitle:
                                      'Vous ne pouvez pas commander\n        dans plus de 2 boutiques',
                                  style: SweetAlertStyle.confirm);
                            });
                          }
                          SweetAlert.show(context,
                              title: 'Un instant...',
                              subtitle: 'Ajout du produit au panier',
                              style: SweetAlertStyle.loading);
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * .7,
                        color: Colors.orange,
                        child: Center(
                          child: Text(
                            'Ajouter au panier',
                            style: TextStyle(fontSize: 15.0),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
            return SizedBox(
              height: 0.0,
            );
          },
        ),
        body: Container(
          color: Colors.white,
          child: FutureBuilder(
            future: productSpecs,
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData) {
                product = Product.fromJson(snapshot.data['produit']);
                categoryMap = snapshot.data['categories'];
                categories =
                    categoryMap.map((cat) => Category.fromJson(cat)).toList();
                pics = snapshot.data['photos']['pics'];
                nbrPics = snapshot.data['photos']['count'];
                return SafeArea(
                  top: true,
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverAppBar(
                        floating: true,
                        expandedHeight: MediaQuery.of(context).size.height * .6,
                        title: Center(
                          child: Text('Details'),
                        ),
                        actions: <Widget>[
                          IconButton(
                            icon: Icon(Icons.more_vert),
                            onPressed: () {},
                          )
                        ],
                        flexibleSpace: FlexibleSpaceBar(
                          background: PageView.builder(
                            onPageChanged: (index) {
                              setState(() {
                                _selectedItem = index;
                              });
                            },
                            itemCount: nbrPics,
                            itemBuilder: (BuildContext context, index) {
                              return Image.network(
                                imagePath('${pics[index]}'),
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                        bottom: PreferredSize(
                          preferredSize: Size.fromHeight(50.0),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 10.0),
                              child: Row(
                                children: <Widget>[
                                  _pageSelectedIndex(nbrPics),
                                  Spacer(),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (favoriteDescriptions.contains(
                                                product.description) &&
                                            favoriteNames
                                                .contains(product.name)) {
                                          favorites.remove(product);
                                          favoriteDescriptions
                                              .remove(product.description);
                                          favoriteNames.remove(product.name);
                                        } else {
                                          favorites.add(product);
                                          favoriteNames.add(product.name);
                                          favoriteDescriptions
                                              .add(product.description);
                                        }
                                        storeFavorite(favorites);
                                      });
                                    },
                                    child: Container(
                                      width: 50.0,
                                      height: 50.0,
                                      child: Icon(
                                        AddToFavorites.add_to_favorite,
                                        color: favoriteNames
                                                    .contains(product.name) &&
                                                favoriteDescriptions.contains(
                                                    product.description)
                                            ? Colors.red
                                            : Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate([
                          Container(
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    '${product.name}',
                                    style: TextStyle(
                                        fontSize: 22.0, color: Colors.pink),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        product.newPrice == 0 ||
                                                product.newPrice == null
                                            ? '${product.oldPrice} Fcfa'
                                            : '${product.newPrice} Fcfa',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17.0),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                4,
                                      ),
                                      Text(
                                        product.newPrice == 0 ||
                                                product.newPrice == null
                                            ? ''
                                            : '${product.oldPrice} Fcfa',
                                        style: TextStyle(
                                            color: Colors.red,
                                            decoration:
                                                TextDecoration.lineThrough),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Row(
                                    children: <Widget>[
                                      product.newPrice == 0 ||
                                              product.newPrice == null
                                          ? Container()
                                          : Container(
                                              width: 50.0,
                                              height: 22.0,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(50.0)),
                                                color:
                                                    Colors.red.withOpacity(.3),
                                              ),
                                              child: Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(3.0),
                                                  child: Text(
                                                    '-${discountPercent(product.oldPrice, product.newPrice)}%',
                                                    style: TextStyle(
                                                        color: Colors.pink,
                                                        fontSize: 12.0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                      Spacer(),
                                      Text(
                                        'Boutique: ${product.shopName ?? 'Non renseigne'}',
                                        style:
                                            TextStyle(color: Colors.blueGrey),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 9,
                                    child: Text(
                                      '${product.description}',
                                      textAlign: TextAlign.justify,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Row(
                                    children: <Widget>[
                                      Text('Disponible: ${product.available}'),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Spacer(),
                                      Text('${parseIntToDouble(product.rate)}'),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      renderStars(product.rate)
                                    ],
                                  ),
                                ),
                                FutureBuilder(
                                    future: _reviews,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Center(
                                            child: Text(
                                              'Impossible de charger les avis pour le moment',
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        );
                                      }
                                      if (snapshot.hasData) {
                                        List data = [];
                                        double rate = 0.0;
                                        int rateInt = 0;
                                        for (var item in snapshot.data) {
                                          if (!data.contains(item)) {
                                            rate += double.parse(item['note']);
                                            data.add(item);
                                          }
                                        }
                                        rate /=
                                            data.isNotEmpty ? data.length : 1;
                                        rateInt = rate.toInt();
                                        return data.isEmpty
                                            ? SizedBox(
                                                height: 0.0,
                                              )
                                            : Column(
                                                children: <Widget>[
                                                  Divider(
                                                    thickness: 6.0,
                                                    color: Colors.grey,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8.0),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Text(
                                                          'Avis (${data.length})',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                        Spacer(),
                                                        Text(
                                                          'Tout voir',
                                                          style: TextStyle(
                                                              fontSize: 13.0),
                                                        ),
                                                        Icon(
                                                          Icons
                                                              .arrow_forward_ios,
                                                          size: 10.0,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8.0),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Text(
                                                          rate
                                                                      .toString()
                                                                      .length >
                                                                  3
                                                              ? '${rate.toString().substring(0, 3)}'
                                                              : rate.toString(),
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        renderStars(rateInt)
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                      height: 81,
                                                      child: PageView.builder(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          itemCount:
                                                              data.length,
                                                          itemBuilder: (context,
                                                              int index) {
                                                            return Column(
                                                              children: <
                                                                  Widget>[
                                                                SizedBox(
                                                                  height: 10.0,
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          8.0),
                                                                  child:
                                                                      Container(
                                                                    width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                    height:
                                                                        71.0,
                                                                    child: Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: <
                                                                          Widget>[
                                                                        Container(
                                                                          height:
                                                                              40.0,
                                                                          width:
                                                                              40.0,
                                                                          child:
                                                                              ClipOval(child: Image.network(imagePath(data[index]['client']['photo'] ?? data[index]['client']['gender'] == 'femme' ? 'users/avatar2.jpg' : 'users/avatar.jpg'))),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              20.0,
                                                                        ),
                                                                        Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: <
                                                                              Widget>[
                                                                            Text('${data[index]['client']['name']}'),
                                                                            Text('${format(data[index]['date'])}'),
                                                                            Text(data[index]['message'].length > 20
                                                                                ? '${data[index]['message'].substring(0, 20)}...'
                                                                                : data[index]['message']),
                                                                          ],
                                                                        ),
                                                                        Spacer(),
                                                                        Column(
                                                                          children: <
                                                                              Widget>[
                                                                            Spacer(),
                                                                            renderStars(int.parse(data[index]['note'])),
                                                                            Spacer()
                                                                          ],
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          }))
                                                ],
                                              );
                                      }

                                      return Center(child: Container());
                                    }),
                                Divider(
                                  thickness: 6.0,
                                  color: Colors.grey,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Row(
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text('Autres details utiles'),
                                        ],
                                      ),
                                      Spacer(),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 18.0,
                                        color: Colors.grey.withOpacity(.5),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        'Date estimee de livraison:',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Spacer(),
                                      Text(
                                        '${estimateDate()}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 30.0,
                                ),
                              ],
                            ),
                          ),
                        ]),
                      )
                    ],
                  ),
                );
              }
              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Center(
                    child: Text(
                      'Une erreur est survenue. Veuillez rafraichir la page',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              return Center(child: Image.asset('img/loading5.gif'));
            },
          ),
        ));
  }
}
