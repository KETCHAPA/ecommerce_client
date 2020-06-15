import 'package:client_bos_final/common/globals.dart';
import 'package:client_bos_final/screens/account/account.dart';
import 'package:client_bos_final/screens/account/favorite.dart';
import 'package:client_bos_final/screens/account/setting.dart';
import 'package:client_bos_final/screens/cart/carts.dart';
import 'package:client_bos_final/screens/category/category.dart';
import 'package:client_bos_final/screens/chooseDatabase.dart';
import 'package:client_bos_final/screens/first_connexion/launcher.dart';
import 'package:client_bos_final/screens/first_connexion/splash.dart';
import 'package:client_bos_final/screens/home/error_page.dart';
import 'package:client_bos_final/screens/home/home.dart';
import 'package:client_bos_final/screens/product/products.dart';
import 'package:client_bos_final/screens/shop/shops.dart';
import 'package:client_bos_final/style/styles.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  void initState() {
    favorites = getFavorite();
    favorites = getFavoriteShops();
    carts = getCart();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buy, On Send',
      color: Colors.white,
      onUnknownRoute: (context) =>
          MaterialPageRoute(builder: (context) => ErrorPage()),
      theme: themeData,
      initialRoute: '/choose',
      routes: {
        '/home': (context) => HomePage(),
        '/categories': (context) => CategoriesPage(),
        '/carts': (context) => CartPage(),
        '/account': (context) => AccountPage(),
        '/settings': (context) => SettingsPage(),
        '/favoriteItems': (context) => FavoriteItemPage(),
        '/products': (context) => ProductsPage(),
        '/shop': (context) => ShopPage(),
        '/': (context) => LauncherPage(),
        '/splash': (context) => SplashScreen(),
        '/choose': (context) => ChooseDataBase(),
      },
    );
  }
}
