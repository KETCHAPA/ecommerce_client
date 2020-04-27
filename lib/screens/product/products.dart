import 'package:client_bos_final/common/globals.dart';
import 'package:client_bos_final/custom/navigation_bar.dart';
import 'package:client_bos_final/custom/sweetAlert.dart';
import 'package:client_bos_final/icons/cart_icons.dart';
import 'package:client_bos_final/icons/favorite_icons.dart';
import 'package:client_bos_final/model/categories.dart';
import 'package:client_bos_final/model/products.dart';
import 'package:client_bos_final/model/shops.dart';
import 'package:client_bos_final/screens/product/showProduct.dart';
import 'package:client_bos_final/screens/search/search.dart';
import 'package:client_bos_final/service/categoryService.dart';
import 'package:client_bos_final/service/productService.dart';
import 'package:client_bos_final/service/shopService.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:sweetalert/sweetalert.dart';

class ProductsPage extends StatefulWidget {
  final Category category;
  final Shop shop;
  final List products;
  ProductsPage({this.category, this.shop, this.products});

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  Future products;
  bool bottom = true;
  List carts;

  _fetchData() async {
    if (widget.category != null) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ProductsPage(
                category: widget.category,
              )));
    } else if (widget.shop != null) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ProductsPage(
                shop: widget.shop,
              )));
    } else {
      List<Product> _products = await fetchAllProduct();
      await setAllProducts(_products);
      Navigator.of(context).popAndPushNamed('/products');
    }
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
  void initState() {
    super.initState();
    if (widget.category != null) {
      products = fetchCategoryProduct(widget.category.code);
      bottom = false;
    } else if (widget.shop != null) {
      products = fetchShopProducts(widget.shop.code);
      bottom = false;
    } else {
      products = getAllProducts();
      bottom = true;
    }

    if (widget.products != null) {
      bottom = false;
    }
  }

  _searchRedirection() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SearchPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: <Widget>[
          Container(
            width: 40.0,
            child: Stack(
              children: <Widget>[
                IconButton(
                  icon: Icon(Cart.shopping_cart_of_horizontal_lines_design),
                  color: Colors.black.withOpacity(.7),
                  onPressed: () {
                    Navigator.pushNamed(context, '/carts');
                  },
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 20.0,
                    height: 20.0,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [Colors.red, Colors.deepOrangeAccent]),
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    child: Center(
                        child: Text('$length',
                            style: TextStyle(
                              color: Colors.white,
                            ))),
                  ),
                )
              ],
            ),
          )
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  color: Colors.grey.withOpacity(.3)),
              child: TextFormField(
                decoration: new InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    fillColor: Colors.grey,
                    hintText: 'Recherche...',
                    border: InputBorder.none),
              ),
            ),
            InkWell(
              onTap: _searchRedirection,
              child: Container(
                color: Colors.transparent,
                width: MediaQuery.of(context).size.width,
                height: 50.0,
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: widget.category != null ||
              widget.shop != null ||
              widget.products != null
          ? SizedBox(
              height: 0,
            )
          : CustomNavigationBar(1),
      body: ListView(
        children: <Widget>[
          RefreshIndicator(
            onRefresh: () async {
              await _refreshData();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 20.0,
                  child: Row(
                    children: <Widget>[
                      widget.products == null
                          ? Padding(
                              padding: EdgeInsets.only(
                                  left: 10.0,
                                  top: 3.0,
                                  bottom: 3.0,
                                  right: 2.0),
                              child: Text(
                                'Triage par defaut',
                                style: TextStyle(fontSize: 10.0),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text('${widget.products[0].type ?? ''}'),
                            ),
                      widget.products != null
                          ? SizedBox(
                              height: 0,
                            )
                          : Column(
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
                      Column(
                        children: <Widget>[
                          (widget.shop != null || widget.category != null)
                              ? Container(
                                  width: 13.0,
                                  height: 12.0,
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(60.0)),
                                  ),
                                  child: widget.shop != null
                                      ? ClipOval(
                                          child: Image.network(
                                              imagePath(widget.shop.photo ??
                                                  'shops/clothes_shop.jpg'),
                                              fit: BoxFit.cover),
                                        )
                                      : widget.category != null
                                          ? ClipOval(
                                              child: Image.network(
                                                  imagePath(
                                                      widget.category.photo),
                                                  fit: BoxFit.cover),
                                            )
                                          : SizedBox(
                                              height: 0.0,
                                            ),
                                )
                              : SizedBox(
                                  height: 0.0,
                                ),
                          Text(
                              widget.shop != null
                                  ? widget.shop.name
                                  : widget.category != null
                                      ? widget.category.name.length > 5
                                          ? widget.category.name.substring(0, 5)
                                          : widget.category.name
                                      : '',
                              style: TextStyle(fontSize: 6.0))
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
                          style: TextStyle(
                              color: Colors.deepOrange, fontSize: 13.0),
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
                    child: widget.products == null
                        ? FutureBuilder(
                            future: products,
                            builder: (BuildContext context, snapshot) {
                              if (snapshot.hasError) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Center(
                                    child: Text(
                                      'Une erreur est survenue. Veuillez rafraichir la page',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              }
                              if (snapshot.hasData) {
                                List _data = [];
                                if (bottom) {
                                  for (var item in snapshot.data) {
                                    if (!_data.contains(item)) {
                                      _data.add(item);
                                    }
                                  }
                                } else {
                                  _data = snapshot.data;
                                }
                                return snapshot.data.isEmpty
                                    ? Center(child: Text('Aucun produit '))
                                    : View(
                                        products: _data,
                                        bottom: bottom,
                                        carts: carts);
                              }

                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          )
                        : View(
                            products: widget.products,
                            bottom: bottom,
                            carts: carts,
                          ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class View extends StatefulWidget {
  View({@required this.products, @required this.bottom, @required this.carts});
  final List products, carts;
  final bool bottom;
  @override
  _ViewState createState() => _ViewState();
}

class _ViewState extends State<View> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: widget.bottom
            ? MediaQuery.of(context).size.height - 191.0
            : MediaQuery.of(context).size.height - 135.0,
        child: ListView.builder(
          itemCount: widget.products.length,
          itemBuilder: (BuildContext context, index) {
            List data = widget.products;
            return InkWell(
              onLongPress: () {
                return showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          elevation: 30.0,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          title: Center(
                            child: Text(
                              'Plus d\'options'.toUpperCase(),
                              style: TextStyle(color: Colors.pink),
                            ),
                          ),
                          content: Container(
                            height: 72.0,
                            child: Row(
                              children: <Widget>[
                                Spacer(),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (favoriteDescriptions.contains(
                                              data[index].description) &&
                                          favoriteNames
                                              .contains(data[index].name)) {
                                        favorites.remove(data[index]);
                                        favoriteDescriptions
                                            .remove(data[index].description);
                                        favoriteNames.remove(data[index].name);
                                      } else {
                                        favorites.add(data[index]);
                                        favoriteNames.add(data[index].name);
                                        favoriteDescriptions
                                            .add(data[index].description);
                                      }
                                      storeFavorite(favorites);
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      Icon(
                                        AddToFavorites.add_to_favorite,
                                        color: favoriteDescriptions.contains(
                                                    data[index].description) &&
                                                favoriteNames
                                                    .contains(data[index].name)
                                            ? Colors.red
                                            : Colors.grey,
                                      ),
                                      Text(
                                        favoriteDescriptions.contains(
                                                    data[index].description) &&
                                                favoriteNames
                                                    .contains(data[index].name)
                                            ? 'Retirer des'
                                            : 'Ajouter aux',
                                        style: TextStyle(fontSize: 13.0),
                                      ),
                                      Text(
                                        'favoris',
                                        style: TextStyle(fontSize: 13.0),
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (canAddProduct(data[index])) {
                                        if (cartDescription.contains(data[index]
                                                .description
                                                .toLowerCase()) &&
                                            cartNames.contains(data[index]
                                                .name
                                                .toLowerCase())) {
                                          quantities[cartNames.lastIndexOf(
                                              data[index]
                                                  .name
                                                  .toLowerCase())]++;
                                          setCartQuantities(quantities);
                                          evaluateTotal(data[index].newPrice ==
                                                      0 ||
                                                  data[index].newPrice == null
                                              ? data[index].oldPrice
                                              : data[index].newPrice);
                                        } else {
                                          cartNames.add(
                                              data[index].name.toLowerCase());
                                          cartDescription.add(data[index]
                                              .description
                                              .toLowerCase());
                                          carts.add(data[index]);
                                          storeProductCart(carts);
                                          quantities.add(1);
                                          setCartQuantities(quantities);
                                          evaluateTotal(data[index].newPrice ==
                                                      0 ||
                                                  data[index].newPrice == null
                                              ? data[index].oldPrice
                                              : data[index].newPrice);
                                          commandShopIds
                                              .add(data[index].shopId);
                                          shopNames.add(data[index].shopName);
                                          setNumberOfShopInCommand();
                                        }
                                        new Future.delayed(
                                            new Duration(seconds: 2), () {
                                          SweetAlert.show(context,
                                              subtitle:
                                                  'Produit ajoute au panier',
                                              style: SweetAlertStyle.success);
                                        });
                                      } else {
                                        new Future.delayed(
                                            new Duration(seconds: 2), () {
                                          SweetAlert.show(context,
                                              subtitle:
                                                  'Vous ne pouvez pas commander\n        dans plus de 2 boutiques',
                                              style: SweetAlertStyle.confirm);
                                        });
                                      }
                                      Navigator.pop(context);
                                      SweetAlert.show(context,
                                          title: 'Un instant...',
                                          subtitle:
                                              'Ajout du produit au panier',
                                          style: SweetAlertStyle.loading);
                                    });
                                    setState(() {
                                      length = carts.length;
                                      setCartLength(length);
                                    });
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      Icon(Cart
                                          .shopping_cart_of_horizontal_lines_design),
                                      Text(
                                        'Ajouter au',
                                        style: TextStyle(fontSize: 13.0),
                                      ),
                                      Text(
                                        'panier',
                                        style: TextStyle(fontSize: 13.0),
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer()
                              ],
                            ),
                          ));
                    });
              },
              onDoubleTap: () {
                setState(() {
                  if (favoriteDescriptions.contains(data[index].description) &&
                      favoriteNames.contains(data[index].name)) {
                    favorites.remove(data[index]);
                    favoriteDescriptions.remove(data[index].description);
                    favoriteNames.remove(data[index].name);
                  } else {
                    favorites.add(data[index]);
                    favoriteNames.add(data[index].name);
                    favoriteDescriptions.add(data[index].description);
                  }
                  storeFavorite(favorites);
                });
              },
              onTap: () {
                if (!recents.contains(widget.products[index])) {
                  recents.add(widget.products[index]);
                }
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ShowProductPage(
                              code: widget.products[index].code,
                            )));
              },
              child: Container(
                  child: Padding(
                padding:
                    const EdgeInsets.only(top: 8.0, bottom: 20.0, left: 10.0),
                child: Row(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          width: 90,
                          height: 120.0,
                          child: Image.network(
                            imagePath('${widget.products[index].photo}'),
                            fit: BoxFit.fill,
                          ),
                        ),
                        widget.products[index].newPrice == 0
                            ? Container()
                            : Container(
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(10.0))),
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Text(
                                    '-${discountPercent(widget.products[index].oldPrice, widget.products[index].newPrice)}%',
                                    style: TextStyle(
                                        fontSize: 10.0, color: Colors.white),
                                  ),
                                ),
                              ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * .65,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  widget.products[index].name.length > 20
                                      ? '${widget.products[index].name.substring(0, 20)}...'
                                      : widget.products[index].name,
                                  style: TextStyle(
                                      color: Colors.pink, fontSize: 15.0),
                                ),
                                Spacer(),
                                Icon(
                                  AddToFavorites.add_to_favorite,
                                  color: favoriteDescriptions.contains(
                                              data[index].description) &&
                                          favoriteNames
                                              .contains(data[index].name)
                                      ? Colors.red
                                      : Colors.grey,
                                  size: 15.0,
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  widget.products[index].newPrice == 0
                                      ? '${widget.products[index].oldPrice} Fcfa'
                                      : '${widget.products[index].newPrice} Fcfa',
                                  style: TextStyle(fontSize: 15.0),
                                ),
                                Spacer(),
                                Text(
                                  widget.products[index].newPrice == 0
                                      ? ''
                                      : '${widget.products[index].oldPrice} Fcfa',
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.red),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              children: <Widget>[
                                renderStars(widget.products[index].rate),
                                Spacer(),
                                Text(
                                    'Disponible: ${widget.products[index].available}')
                              ],
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  widget.products[index].shopName.length > 16
                                      ? 'Boutique: ${widget.products[index].shopName.substring(0, 16)}...'
                                      : 'Boutique: ${widget.products[index].shopName}',
                                  style: TextStyle(fontSize: 13.0),
                                ),
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
            );
          },
        ),
      ),
    );
  }
}
