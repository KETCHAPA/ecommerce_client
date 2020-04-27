import 'dart:async';
import 'package:client_bos_final/common/globals.dart';
import 'package:client_bos_final/custom/navigation_bar.dart';
import 'package:client_bos_final/custom/sweetAlert.dart';
import 'package:client_bos_final/icons/favorite_icons.dart';
import 'package:client_bos_final/icons/socicon_icons.dart';
import 'package:client_bos_final/model/categories.dart';
import 'package:client_bos_final/model/products.dart';
import 'package:client_bos_final/model/promotions.dart';
import 'package:client_bos_final/model/shops.dart';
import 'package:client_bos_final/screens/category/category.dart';
import 'package:client_bos_final/screens/home/send_message.dart';
import 'package:client_bos_final/screens/product/products.dart';
import 'package:client_bos_final/screens/product/productsById.dart';
import 'package:client_bos_final/screens/product/showProduct.dart';
import 'package:client_bos_final/screens/search/search.dart';
import 'package:client_bos_final/service/homeService.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sweetalert/sweetalert.dart';

class HomePage extends StatefulWidget {
  HomePage();
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future _allProducts, _mainCategories, _flashSales, _shops, _dailyDeals;
  int _currentPage = 0;
  PageController _pageController = PageController();
  List<String> bannerImages = [];
  List<int> bannerRedirection = [];
  double maxDiscount;
  bool firstEntry = true;
  GlobalKey<RefreshIndicatorState> _refreshKey;

  _updateMaxDiscount(double value) {
    firstEntry = false;
    maxDiscount = value;
  }

  @override
  void initState() {
    super.initState();
    _refreshKey = GlobalKey<RefreshIndicatorState>();
    _allProducts = getAllProducts();
    _mainCategories = getMainCategories();
    _flashSales = getFlashSales();
    _shops = getShops();
    _dailyDeals = getDailyDeals();

    Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (bannerImages != null) {
        if (_currentPage < bannerImages.length) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
      }

      _pageController.animateToPage(_currentPage,
          duration: Duration(milliseconds: 350), curve: Curves.bounceOut);
    });
  }

  _fetchDataFromServer() async {
    List<Shop> _shop1 = await fetchShops();
    List<Category> _mainCategorie1 = await fetchMainCategory();
    List<Product> _dailyDeal1 = await fetchDailyDeals();
    List<Product> _flashSale1 = await fetchFlashSales();
    List<Promotion> _banner1 = await fetchBanners();

    await setFlashSales(_flashSale1);
    await setMainCategories(_mainCategorie1);
    await setShops(_shop1);
    await setDailyDeals(_dailyDeal1);
    await setBanners(_banner1);
  }

  Future<Null> _refreshData() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      await _fetchDataFromServer();
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

  _searchRedirection() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SearchPage()));
  }

  Future<bool> _onWillPop() async {
    bool returnValue;
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: <Widget>[
              FlatButton(
                onPressed: () => returnValue = false,
                child: Text('Annuler', style: TextStyle(color: Colors.pink)),
              ),
              FlatButton(
                onPressed: () => returnValue = true,
                child: Text('Continuer', style: TextStyle(color: Colors.pink)),
              ),
            ],
            title: Text('Sortie'),
            content: Text('Vous allez quitter l\'application'),
          );
        });
    return returnValue;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        bottomNavigationBar: CustomNavigationBar(0),
        body: RefreshIndicator(
          key: _refreshKey,
          onRefresh: () async {
            await _refreshData();
            Navigator.of(context).popAndPushNamed('/home');
          },
          child: SafeArea(
            top: true,
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  pinned: true,
                  expandedHeight: 190.0,
                  floating: false,
                  backgroundColor: Colors.white,
                  leading: InkWell(
                    onTap: _searchRedirection,
                    child: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                  ),
                  actions: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NewMailPage()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Icon(Socicon.telegram, color: Colors.black87),
                      ),
                    )
                  ],
                  centerTitle: true,
                  title: FutureBuilder(
                    future: _allProducts,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Stack(
                          children: <Widget>[
                            Container(
                              height: 40.0,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  color: Colors.white.withOpacity(0.5)),
                              child: TextFormField(
                                onTap: () {},
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                        left: 20.0, top: 0.0, bottom: 10.0),
                                    hintText: 'Recherche... ',
                                    hintStyle: TextStyle(color: Colors.black)),
                              ),
                            ),
                            InkWell(
                              onTap: _searchRedirection,
                              child: Container(
                                color: Colors.transparent,
                                height: 40.0,
                                width: MediaQuery.of(context).size.width * .9,
                              ),
                            ),
                          ],
                        );
                      }
                      return Stack(
                        children: <Widget>[
                          Container(
                            height: 40.0,
                            width: MediaQuery.of(context).size.width * .9,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0)),
                                color: Colors.white.withOpacity(0.5)),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(
                                      left: 20.0, top: 0.0, bottom: 10.0),
                                  hintText: 'Buy, On Send',
                                  hintStyle: TextStyle(color: Colors.black)),
                            ),
                          ),
                          Container(
                            color: Colors.blue,
                            height: 40.0,
                            width: MediaQuery.of(context).size.width * .9,
                          ),
                        ],
                      );
                    },
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                      background: FutureBuilder(
                          future: getBanners(),
                          builder: (BuildContext context, snapshot) {
                            if (snapshot.hasData) {
                              for (var item in snapshot.data) {
                                if (!bannerImages.contains(item.photo)) {
                                  bannerImages.add(item.photo);
                                  bannerRedirection.add(item.shopId);
                                }
                              }
                              return Stack(
                                children: <Widget>[
                                  PageView.builder(
                                    controller: _pageController,
                                    onPageChanged: (val) {
                                      setState(() {
                                        _currentPage = val;
                                      });
                                    },
                                    itemCount: bannerImages.length,
                                    itemBuilder: (BuildContext context, index) {
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProductsByIdPage(
                                                          bannerRedirection[
                                                              index])));
                                        },
                                        child: Image.network(
                                            imagePath(bannerImages[index]),
                                            fit: BoxFit.cover),
                                      );
                                    },
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      width: 12.0 * bannerImages.length,
                                      height: 20.0,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: bannerImages.length,
                                          itemBuilder:
                                              (BuildContext context, index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Icon(
                                                Icons.brightness_1,
                                                size: index == _currentPage
                                                    ? 7.2
                                                    : 7.0,
                                                color: index == _currentPage
                                                    ? Color(0xff31275c)
                                                    : Colors.blueGrey
                                                        .withOpacity(.3),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
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
                            return Container();
                          })),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Column(
                      children: <Widget>[
                        FutureBuilder(
                          future: _mainCategories,
                          builder: (BuildContext context, snapshot) {
                            if (snapshot.hasData) {
                              List<Category> _mainCategoriesData = [];
                              for (var item in snapshot.data) {
                                if (!_mainCategoriesData.contains(item)) {
                                  _mainCategoriesData.add(item);
                                }
                              }
                              return _mainCategoriesData.isEmpty
                                  ? SizedBox(
                                      height: 0.0,
                                    )
                                  : Column(
                                      children: <Widget>[
                                        SizedBox(
                                          height: 20.0,
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                              width: 350.0,
                                              height: 68.0,
                                              child: ListView.builder(
                                                itemExtent:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        .24,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount:
                                                    _mainCategoriesData.length >
                                                            4
                                                        ? 4
                                                        : _mainCategoriesData
                                                            .length,
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      ProductsPage(
                                                                        category:
                                                                            _mainCategoriesData[index],
                                                                      )));
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0),
                                                      child: Column(
                                                          children: <Widget>[
                                                            Container(
                                                                width: 50.0,
                                                                height: 50.0,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .grey),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              60.0)),
                                                                ),
                                                                child: ClipOval(
                                                                  child: Image
                                                                      .network(
                                                                    imagePath(_mainCategoriesData[
                                                                            index]
                                                                        .photo),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                )),
                                                            Text(
                                                              _mainCategoriesData[
                                                                              index]
                                                                          .name
                                                                          .length >
                                                                      13
                                                                  ? '${_mainCategoriesData[index].name.substring(0, 13)}...'
                                                                  : _mainCategoriesData[
                                                                          index]
                                                                      .name,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      11.0),
                                                            )
                                                          ]),
                                                    ),
                                                  );
                                                },
                                              )),
                                        ),
                                      ],
                                    );
                            }
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

                            return Container();
                          },
                        ),
                        FutureBuilder(
                          future: _mainCategories,
                          builder: (BuildContext context, snapshot) {
                            if (snapshot.hasData) {
                              List<Category> _mainCategoriesData = [];
                              for (var item in snapshot.data) {
                                if (!_mainCategoriesData.contains(item)) {
                                  _mainCategoriesData.add(item);
                                }
                              }
                              _mainCategoriesData.add(Category(
                                  name: 'Voir plus',
                                  photo: 'main_category_photos/plus.png'));
                              return _mainCategoriesData.isEmpty
                                  ? SizedBox(
                                      height: 0.0,
                                    )
                                  : Column(
                                      children: <Widget>[
                                        SizedBox(
                                          height: 20.0,
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                              width: 350.0,
                                              height: 68.0,
                                              child: ListView.builder(
                                                itemExtent:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        .24,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: 4,
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                    onTap: () {
                                                      _mainCategoriesData[
                                                                      index + 4]
                                                                  .photo ==
                                                              'main_category_photos/plus.png'
                                                          ? Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          CategoriesPage()))
                                                          : Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          ProductsPage(
                                                                            category:
                                                                                _mainCategoriesData[index],
                                                                          )));
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0),
                                                      child: Column(
                                                          children: <Widget>[
                                                            Container(
                                                                width: 50.0,
                                                                height: 50.0,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: _mainCategoriesData[index + 4]
                                                                              .photo ==
                                                                          'main_category_photos/plus.png'
                                                                      ? null
                                                                      : Border.all(
                                                                          color:
                                                                              Colors.grey),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              60.0)),
                                                                ),
                                                                child: ClipOval(
                                                                  child: Image
                                                                      .network(
                                                                    imagePath(_mainCategoriesData[
                                                                            index +
                                                                                4]
                                                                        .photo),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                )),
                                                            Text(
                                                              _mainCategoriesData[index +
                                                                              4]
                                                                          .name
                                                                          .length >
                                                                      13
                                                                  ? '${_mainCategoriesData[index + 4].name.substring(0, 13)}...'
                                                                  : _mainCategoriesData[
                                                                          index +
                                                                              4]
                                                                      .name,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      11.0),
                                                            )
                                                          ]),
                                                    ),
                                                  );
                                                },
                                              )),
                                        ),
                                      ],
                                    );
                            }
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

                            return Container();
                          },
                        ),
                      ],
                    ),
                    FutureBuilder(
                      future: _flashSales,
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.hasData) {
                          List _flashSalesData = [];
                          for (var item in snapshot.data) {
                            if (!_flashSalesData.contains(item)) {
                              _flashSalesData.add(item);
                            }
                          }
                          _flashSalesData.length > 4 ??
                              _flashSalesData.insert(
                                  4,
                                  Product(
                                      newPrice: -1,
                                      photo: 'main_category_photos/plus.jpg'));
                          return _flashSalesData.length == 0
                              ? SizedBox(
                                  height: 0.0,
                                )
                              : SingleChildScrollView(
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 13.0,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 23.0,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 9.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text('Ventes Flash',
                                                  style: TextStyle(
                                                      fontSize: 15.0)),
                                              SizedBox(
                                                width: 2.0,
                                              ),
                                              Column(
                                                children: <Widget>[
                                                  Spacer(),
                                                  maxDiscount == null
                                                      ? Text('')
                                                      : Text(
                                                          'Jusqu\'a -$maxDiscount%',
                                                          style: TextStyle(
                                                              fontSize: 9.0,
                                                              color: Colors.red
                                                                  .withOpacity(
                                                                      .8))),
                                                ],
                                              ),
                                              Spacer(),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 2.0),
                                                child: Column(
                                                  children: <Widget>[
                                                    Spacer(),
                                                    Text('expire dans',
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color: Colors
                                                                .blueGrey)),
                                                  ],
                                                ),
                                              ),
                                              Counter()
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 7.0,
                                      ),
                                      Container(
                                        height: 280,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: _flashSalesData.length < 5
                                              ? _flashSalesData.length
                                              : 5,
                                          itemBuilder:
                                              (BuildContext context, index) {
                                            if (firstEntry) {
                                              _updateMaxDiscount(double.parse(
                                                  discountPercent(
                                                      _flashSalesData[index]
                                                          .oldPrice,
                                                      _flashSalesData[index]
                                                          .newPrice)));
                                            } else {
                                              if (double.parse(discountPercent(
                                                      _flashSalesData[index]
                                                          .oldPrice,
                                                      _flashSalesData[index]
                                                          .newPrice)) >
                                                  maxDiscount) {
                                                _updateMaxDiscount(double.parse(
                                                    discountPercent(
                                                        _flashSalesData[index]
                                                            .oldPrice,
                                                        _flashSalesData[index]
                                                            .newPrice)));
                                              }
                                            }
                                            return InkWell(
                                              onTap: () {
                                                if (!(_flashSalesData[index]
                                                            .newPrice ==
                                                        -1) &&
                                                    !recents.contains(
                                                        _flashSalesData[
                                                            index])) {
                                                  recents.add(
                                                      _flashSalesData[index]);
                                                }
                                                _flashSalesData[index]
                                                            .newPrice ==
                                                        -1
                                                    ? Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ProductsPage(
                                                                  products:
                                                                      _flashSalesData,
                                                                )))
                                                    : Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ShowProductPage(
                                                                  code: _flashSalesData[
                                                                          index]
                                                                      .code,
                                                                )));
                                              },
                                              onDoubleTap: () {
                                                setState(() {
                                                  if (favoriteDescriptions
                                                          .contains(
                                                              _flashSalesData[
                                                                      index]
                                                                  .description) &&
                                                      favoriteNames.contains(
                                                          _flashSalesData[index]
                                                              .name)) {
                                                    favorites.remove(
                                                        _flashSalesData[index]);
                                                    favoriteDescriptions.remove(
                                                        _flashSalesData[index]
                                                            .description);
                                                    favoriteNames.remove(
                                                        _flashSalesData[index]
                                                            .name);
                                                  } else {
                                                    favorites.add(
                                                        _flashSalesData[index]);
                                                    favoriteNames.add(
                                                        _flashSalesData[index]
                                                            .name);
                                                    favoriteDescriptions.add(
                                                        _flashSalesData[index]
                                                            .description);
                                                  }
                                                  storeFavorite(favorites);
                                                });
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4.0),
                                                child: new Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.black),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.0))),
                                                  width: 130,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Stack(
                                                        children: <Widget>[
                                                          Container(
                                                              height: 185.0,
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .vertical(
                                                                            top:
                                                                                Radius.circular(10.0)),
                                                                child: Image.network(
                                                                    imagePath(
                                                                        '${_flashSalesData[index].photo}'),
                                                                    fit: BoxFit
                                                                        .fill),
                                                              )),
                                                          _flashSalesData[index]
                                                                      .newPrice ==
                                                                  -1
                                                              ? Container()
                                                              : Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .topRight,
                                                                  child:
                                                                      Container(
                                                                    decoration: BoxDecoration(
                                                                        color: Colors
                                                                            .red,
                                                                        borderRadius:
                                                                            BorderRadius.only(topRight: Radius.circular(6.0))),
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              7.0,
                                                                          vertical:
                                                                              2.0),
                                                                      child:
                                                                          Text(
                                                                        '-${discountPercent(_flashSalesData[index].oldPrice, _flashSalesData[index].newPrice)}%',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight: FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.all(5.0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            _flashSalesData[index]
                                                                        .newPrice ==
                                                                    -1
                                                                ? Center(
                                                                    child: Text(
                                                                        'Voir plus'))
                                                                : Text(
                                                                    _flashSalesData[index].name.length >
                                                                            20
                                                                        ? '${_flashSalesData[index].name.substring(0, 14)}...'
                                                                        : _flashSalesData[index]
                                                                            .name,
                                                                    style:
                                                                        TextStyle()),
                                                            SizedBox(
                                                              height: 5.0,
                                                            ),
                                                            Row(
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  '${_flashSalesData[index].newPrice} Fcfa ',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          10.0),
                                                                ),
                                                                Spacer(),
                                                                Text(
                                                                  '${_flashSalesData[index].oldPrice} Fcfa',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          8.0,
                                                                      decoration:
                                                                          TextDecoration
                                                                              .lineThrough),
                                                                )
                                                              ],
                                                            ),
                                                            SizedBox(
                                                                height: 6.0),
                                                            _flashSalesData[index]
                                                                        .newPrice ==
                                                                    -1
                                                                ? Container()
                                                                : Text(
                                                                    'Disponible: ${_flashSalesData[index].available}',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            13.0),
                                                                  ),
                                                            SizedBox(
                                                              height: 3.0,
                                                            ),
                                                            _flashSalesData[index]
                                                                        .newPrice ==
                                                                    -1
                                                                ? Container()
                                                                : Row(
                                                                    children: <
                                                                        Widget>[
                                                                      renderStars(
                                                                          _flashSalesData[index]
                                                                              .rate),
                                                                      Spacer(),
                                                                      Icon(
                                                                        AddToFavorites
                                                                            .add_to_favorite,
                                                                        size:
                                                                            10.0,
                                                                        color: favoriteDescriptions.contains(_flashSalesData[index].description) &&
                                                                                favoriteNames.contains(_flashSalesData[index].name)
                                                                            ? Colors.red
                                                                            : Colors.grey,
                                                                      )
                                                                    ],
                                                                  )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                );
                        }
                        if (snapshot.hasError) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Center(
                              child: Text(
                                'Une erreur est survenue. Veuillez rafraichir la page',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }

                        return Container();
                      },
                    ),
                    FutureBuilder(
                      future: _shops,
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.hasError) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Center(
                              child: Text(
                                'Une erreur est survenue. Veuillez rafraichir la page',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }
                        if (snapshot.hasData) {
                          List _shopsData = [];
                          for (var item in snapshot.data) {
                            if (!_shopsData.contains(item)) {
                              _shopsData.add(item);
                            }
                          }
                          return ShopView(_shopsData);
                        }

                        return Container();
                      },
                    ),
                    SizedBox(
                      height: 7.0,
                    ),
                    FutureBuilder(
                      future: _dailyDeals,
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.hasError) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Center(
                              child: Text(
                                'Une erreur est survenue. Veuillez rafraichir la page',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }
                        if (snapshot.hasData) {
                          List _dailyDealsData = [];
                          for (var item in snapshot.data) {
                            if (!_dailyDealsData.contains(item)) {
                              _dailyDealsData.add(item);
                            }
                          }
                          return _dailyDealsData.isEmpty
                              ? SizedBox(
                                  height: 0.0,
                                )
                              : Column(
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 23.0,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 9.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text('Meilleures offres',
                                                style:
                                                    TextStyle(fontSize: 15.0)),
                                            Spacer(),
                                            InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ProductsPage(
                                                                products:
                                                                    _dailyDealsData,
                                                              )));
                                                },
                                                child: Text('Tout voir ->',
                                                    style: TextStyle(
                                                        fontSize: 10.0)))
                                          ],
                                        ),
                                      ),
                                    ),
                                    SingleChildScrollView(
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(1.0),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(1.0),
                                                child: Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      .45,
                                                  child: StaggeredGridView
                                                      .countBuilder(
                                                    crossAxisCount: 4,
                                                    itemCount: _dailyDealsData
                                                                .length <=
                                                            7
                                                        ? snapshot.data.length
                                                        : 7,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                                int index) =>
                                                            InkWell(
                                                      onTap: () {
                                                        if (!recents.contains(
                                                            _dailyDealsData[
                                                                index])) {
                                                          recents.add(
                                                              _dailyDealsData[
                                                                  index]);
                                                        }
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ShowProductPage(
                                                                          code:
                                                                              _dailyDealsData[index].code,
                                                                        )));
                                                      },
                                                      onDoubleTap: () {
                                                        setState(() {
                                                          if (favoriteDescriptions.contains(
                                                                  _dailyDealsData[
                                                                          index]
                                                                      .description) &&
                                                              favoriteNames.contains(
                                                                  _dailyDealsData[
                                                                          index]
                                                                      .name)) {
                                                            favorites.remove(
                                                                _dailyDealsData[
                                                                    index]);
                                                            favoriteDescriptions.remove(
                                                                _dailyDealsData[
                                                                        index]
                                                                    .description);
                                                            favoriteNames.remove(
                                                                _dailyDealsData[
                                                                        index]
                                                                    .name);
                                                          } else {
                                                            favorites.add(
                                                                _dailyDealsData[
                                                                    index]);
                                                            favoriteNames.add(
                                                                _dailyDealsData[
                                                                        index]
                                                                    .name);
                                                            favoriteDescriptions.add(
                                                                _dailyDealsData[
                                                                        index]
                                                                    .description);
                                                          }
                                                          storeFavorite(
                                                              favorites);
                                                        });
                                                      },
                                                      child: new Container(
                                                        color: Colors.white,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Stack(
                                                              children: <
                                                                  Widget>[
                                                                Container(
                                                                  height: index %
                                                                              2 ==
                                                                          0
                                                                      ? 205.0
                                                                      : index % 3 ==
                                                                              0
                                                                          ? 195.0
                                                                          : 185.0,
                                                                  child: Image.network(
                                                                      imagePath(
                                                                          '${_dailyDealsData[index].photo}'),
                                                                      fit: BoxFit
                                                                          .fill),
                                                                ),
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .topRight,
                                                                  child:
                                                                      Container(
                                                                    decoration: BoxDecoration(
                                                                        color: Colors
                                                                            .red,
                                                                        borderRadius:
                                                                            BorderRadius.only(bottomLeft: Radius.circular(5.0))),
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              4.0,
                                                                          vertical:
                                                                              2.0),
                                                                      child:
                                                                          Text(
                                                                        '-${discountPercent(_dailyDealsData[index].oldPrice, _dailyDealsData[index].newPrice)}%',
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .white,
                                                                            fontSize:
                                                                                13.0,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          10.0,
                                                                      vertical:
                                                                          5.0),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                    _dailyDealsData[index].name.length >
                                                                            14
                                                                        ? '${_dailyDealsData[index].name.substring(0, 14)}...'
                                                                        : _dailyDealsData[index]
                                                                            .name,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            13.0),
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          3.0),
                                                                  Row(
                                                                    children: <
                                                                        Widget>[
                                                                      Text(
                                                                        '${_dailyDealsData[index].newPrice} Fcfa ',
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize: 13.0),
                                                                      ),
                                                                      Spacer(),
                                                                      Text(
                                                                        '${_dailyDealsData[index].oldPrice} Fcfa ',
                                                                        style: TextStyle(
                                                                            decoration:
                                                                                TextDecoration.lineThrough,
                                                                            color: Colors.red,
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 12.0),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          4.0),
                                                                  Row(
                                                                    children: <
                                                                        Widget>[
                                                                      renderStars(
                                                                          _dailyDealsData[index]
                                                                              .rate),
                                                                      SizedBox(
                                                                        width:
                                                                            5.0,
                                                                      ),
                                                                      Spacer(),
                                                                      Icon(
                                                                        AddToFavorites
                                                                            .add_to_favorite,
                                                                        size:
                                                                            15.0,
                                                                        color: favoriteDescriptions.contains(_dailyDealsData[index].description) &&
                                                                                favoriteNames.contains(_dailyDealsData[index].name)
                                                                            ? Colors.red
                                                                            : Colors.grey,
                                                                      )
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    staggeredTileBuilder: (int
                                                            index) =>
                                                        new StaggeredTile.count(
                                                            2,
                                                            index % 2 == 0
                                                                ? 3.2
                                                                : index % 3 == 0
                                                                    ? 3.1
                                                                    : 3),
                                                    mainAxisSpacing: 4.0,
                                                    crossAxisSpacing: 4.0,
                                                  ),
                                                ),
                                              ))
                                        ],
                                      ),
                                    )
                                  ],
                                );
                        }
                        return Container();
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Counter extends StatefulWidget {
  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this,
        duration: Duration(minutes: 59, seconds: 59, hours: 23),
        value: 1.0);
    _controller.reverse();
  }

  String get _timerString {
    Duration duration = _controller.duration * _controller.value;
    return '${duration.inHours}:${duration.inMinutes % 60}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(.85),
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget child) {
              return Text(_timerString, style: TextStyle(color: Colors.white));
            },
          )),
    );
  }
}

class ShopView extends StatefulWidget {
  ShopView(this.shops);

  final List shops;

  @override
  _ShopViewState createState() => _ShopViewState();
}

class _ShopViewState extends State<ShopView> {
  @override
  Widget build(BuildContext context) {
    return widget.shops.isEmpty
        ? SizedBox(
            height: 0.0,
          )
        : Column(
            children: <Widget>[
              SizedBox(
                height: 7.0,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 23.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 9.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('Boutiques', style: TextStyle(fontSize: 15.0)),
                      Spacer(),
                      InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/shop');
                          },
                          child: Text('Tout voir ->',
                              style: TextStyle(fontSize: 10.0)))
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Container(
                  height: 180.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount:
                        widget.shops.length > 4 ? 4 : widget.shops.length,
                    itemBuilder: (BuildContext context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductsPage(
                                        shop: widget.shops[index],
                                      )));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 2.0),
                          child: Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                  Colors.blueGrey,
                                  Colors.purple,
                                  Colors.blueAccent
                                ])),
                            width: MediaQuery.of(context).size.width * .37,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    height: 125.0,
                                    child: Image.network(
                                      imagePath(widget.shops[index].photo ??
                                          'shops/clothes_shop.jpg'),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Container(
                                    child: Text(
                                      widget.shops[index].name,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
  }
}
