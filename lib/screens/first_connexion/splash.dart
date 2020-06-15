import 'dart:async';
import 'package:client_bos_final/common/globals.dart';
import 'package:client_bos_final/custom/sweetAlert.dart';
import 'package:client_bos_final/model/categories.dart';
import 'package:client_bos_final/model/products.dart';
import 'package:client_bos_final/model/promotions.dart';
import 'package:client_bos_final/model/shops.dart';
import 'package:client_bos_final/service/categoryService.dart';
import 'package:client_bos_final/service/homeService.dart';
import 'package:client_bos_final/service/productService.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:sweetalert/sweetalert.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void navigationBar() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {
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
      await setShops(_shops);
      await setAllCategories(_allCategories);
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
              'Pour votre premiere connexion, veuillez\n         activez votre connexion internet.',
          type: SweetAlertStyle.confirm,
        );
      });
      Navigator.pushNamed(context, '/splash');
    }
  }

  _fillData() async {
    length = await getCartLength();
    total = await getCartTotal();
    quantities = await getCartQuantities();
    carts = (await getCart()).map((cart) => Product.fromJson(cart)).toList();
    favorites =
        (await getFavorite()).map((cart) => Product.fromJson(cart)).toList();
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
    for (var item in favoritesShops) {
      favoritesShops.add(item.name);
    }

    setNumberOfShopInCommand();
  }

  startTime() {
    Duration _duration = new Duration(seconds: 1);
    return new Timer(_duration, navigationBar);
  }

  @override
  void initState() {
    super.initState();
    startTime();
    _fillData();
  }

  @override
  Widget build(BuildContext context) {
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
                  fontFamily: 'Cocon',
                  fontWeight: FontWeight.bold),
            ),
            Text(
              'Buy, On Send',
              style: TextStyle(
                  fontSize: 10.0,
                  fontFamily: 'Overlock',
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
