import 'dart:async';
import 'package:client_bos_final/common/globals.dart';
import 'package:client_bos_final/custom/sweetAlert.dart';
import 'package:client_bos_final/model/categories.dart';
import 'package:client_bos_final/model/products.dart';
import 'package:client_bos_final/model/promotions.dart';
import 'package:client_bos_final/model/shops.dart';
import 'package:client_bos_final/screens/first_connexion/splash.dart';
import 'package:client_bos_final/service/categoryService.dart';
import 'package:client_bos_final/service/homeService.dart';
import 'package:client_bos_final/service/productService.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:sweetalert/sweetalert.dart';

class LauncherPage extends StatefulWidget {
  @override
  _LauncherPageState createState() => _LauncherPageState();
}

class _LauncherPageState extends State<LauncherPage> {
  bool haveToStart = true;

  int _currentPage = 0;
  PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    _fillData();
  }

  startTime() {
    Duration _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationBar);
  }

  void navigationBar() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        haveToStart = false;
      });
      List<Shop> _shops = await fetchShops();
      List<Product> _products = await fetchAllProduct();
      List<Category> _mainCategories = await fetchMainCategory();
      List<Category> _allCategories = await fetchAllCategories();
      List<Product> _dailyDeals = await fetchDailyDeals();
      List<Product> _flashSales = await fetchFlashSales();
      List<Promotion> _banners = await fetchBanners();
      List<Category> _parentCategories = await fetchParentCategories();
      isLoggedIn = await isLogged();
      if (isLoggedIn) {
        Map _user = await getCurrentUser();
        token = await getUserToken();
        userCode = _user['code'];
        userId = _user['id'];
      }

      await setFlashSales(_flashSales);
      await setMainCategories(_mainCategories);
      await setAllCategories(_allCategories);
      await setShops(_shops);
      await setDailyDeals(_dailyDeals);
      await setBanners(_banners);
      await setAllProducts(_products);
      await setParentCategories(_parentCategories);

      Navigator.pushNamed(context, '/home');
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
      Navigator.pushNamed(context, '/home');
    }
  }

  _fillData() async {
    length = await getCartLength();
    total = await getCartTotal();
    quantities = await getCartQuantities();
    carts = (await getCart()).map((cart) => Product.fromJson(cart)).toList();
    favorites =
        (await getFavorite()).map((fav) => Product.fromJson(fav)).toList();
    favoritesShops =
        (await getFavoriteShops()).map((shop) => Shop.fromJson(shop)).toList();

    for (var item in carts) {
      cartDescription.add(item.description);
      cartNames.add(item.name);
      commandShopIds.add(item.shopId);
      shopNames.add(item.shopName);
    }
    for (var item in favorites) {
      favoriteDescriptions.add(item.description);
      favoriteNames.add(item.name);
    }

    setNumberOfShopInCommand();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: isFirstConnexion(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data) {
            return SafeArea(
              top: true,
              child: Container(
                color: Color(0xffede6ea),
                child: Stack(
                  children: <Widget>[
                    PageView.builder(
                      onPageChanged: (val) {
                        setState(() {
                          _currentPage = val;
                        });
                      },
                      controller: _pageController,
                      itemCount: list.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40.0),
                          child: Column(
                            children: <Widget>[
                              Spacer(),
                              list[index].widget,
                              Spacer(),
                              list[index].title == null
                                  ? Container()
                                  : Text('${list[index].title}',
                                      style: TextStyle(
                                          decoration: TextDecoration.none,
                                          fontSize: 30.0,
                                          fontFamily: 'Cocon',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 40.0, horizontal: 20.0),
                                child: Text('${list[index].text}',
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                        decoration: TextDecoration.none,
                                        fontFamily: 'Cocon',
                                        fontSize: 13.0,
                                        color: Colors.black87)),
                              ),
                              list[index].actionText == null
                                  ? Container()
                                  : RaisedButton(
                                      elevation: 10.0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30.0))),
                                      onPressed: () async {
                                        setFirstConnexion();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    list[index].actionText));
                                      },
                                      color: Color(0xff31275c),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('COMMENCER',
                                            style: TextStyle(
                                                decoration: TextDecoration.none,
                                                fontSize: 18.0,
                                                fontFamily: 'Cocon',
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white)),
                                      ),
                                    )
                            ],
                          ),
                        );
                      },
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: 50.0,
                        height: 30.0,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: list.length,
                            itemBuilder: (context, int index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  Icons.brightness_1,
                                  color: _currentPage == index
                                      ? Color(0xff31275c)
                                      : Colors.blueGrey.withOpacity(.3),
                                  size: 10.0,
                                ),
                              );
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            haveToStart ? startTime() : SizedBox();
            return Scaffold(
              body: Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset('img/loading_round.gif'),
                    ),
                    Text(
                      'BIENVENUE',
                      style: TextStyle(
                          fontFamily: 'Cocon',
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Buy, On Send',
                      style: TextStyle(
                          fontFamily: 'Overlock',
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            );
          }
        }
        return Scaffold(
          body: Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset('img/loading_round.gif'),
                ),
                Text(
                  'BIENVENUE',
                  style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cocon'),
                ),
                Text(
                  'Buy, On Send',
                  style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class LauncherSubPage {
  LauncherSubPage(
      {this.title,
      this.text,
      this.widget,
      this.actionText,
      this.showNext,
      this.showPrevious});

  final Widget actionText;
  final bool showNext;
  final bool showPrevious;
  final String text;
  final String title;
  final Widget widget;
}

List<LauncherSubPage> list = [
  LauncherSubPage(
      title: 'BIENVENUE',
      showNext: true,
      text:
          'Sur Buy, On Send. Ceci est votre premiere connexion sur la nouvelle plateforme de vente en ligne au cameroun. ',
      widget: Image.asset('img/welcome.jpg')),
  LauncherSubPage(
      title: 'ACHAT EN LIGNE',
      showNext: true,
      showPrevious: true,
      text:
          'Desormais commander tous vos articles sur Buy, On Send et faites vous livrez au pied de votre porte.',
      widget: Image.asset('img/presentation.jpg')),
  LauncherSubPage(
      title: 'ALLONS-Y',
      showPrevious: true,
      showNext: true,
      text: 'A vos marques, Pret, Commandez!',
      widget: Image.asset('img/start.gif'),
      actionText: SplashScreen()),
];
