library my_project.globals;

import 'package:client_bos_final/common/ENDPOINT.dart';
import 'package:client_bos_final/model/categories.dart';
import 'package:client_bos_final/model/products.dart';
import 'package:client_bos_final/model/promotions.dart';
import 'package:client_bos_final/model/shops.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

@override
void initState() {}

String imagePath(path) {
  return 'https://$imageEndPoint.bdconsulting-cm.com/public/images/$path';
}

getFavorite() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('favorites') == null
      ? []
      : prefs.getStringList('favorites').map((item) => json.decode(item));
}

storeFavorite(List items) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> favorites =
      items.map((item) => json.encode(item.toJson())).toList();
  await prefs.setStringList('favorites', favorites);
}

double parseIntToDouble(int value) {
  return value.toDouble();
}

getFlashSales() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('flashSales') == null
      ? []
      : prefs
          .getStringList('flashSales')
          .map((item) => Product.fromJson(json.decode(item)));
}

setFlashSales(List<Product> items) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> flashSales =
      items.map((item) => json.encode(item.toJson())).toList();
  await prefs.setStringList('flashSales', flashSales);
}

getDailyDeals() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('dailyDeals') == null
      ? []
      : prefs
          .getStringList('dailyDeals')
          .map((item) => Product.fromJson(json.decode(item)));
}

setDailyDeals(List<Product> items) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> _dailyDeals =
      items.map((item) => json.encode(item.toJson())).toList();
  await prefs.setStringList('dailyDeals', _dailyDeals);
}

getAllProducts() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('allProducts') == null
      ? []
      : prefs
          .getStringList('allProducts')
          .map((item) => Product.fromJson(json.decode(item)));
}

setAllProducts(List<Product> items) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> _allProducts =
      items.map((item) => json.encode(item.toJson())).toList();
  await prefs.setStringList('allProducts', _allProducts);
}

getShops() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('shops') == null
      ? []
      : prefs
          .getStringList('shops')
          .map((item) => Shop.fromJson(json.decode(item)));
}

setShops(List<Shop> items) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> _shops =
      items.map((item) => json.encode(item.toJson())).toList();
  await prefs.setStringList('shops', _shops);
}

getMainCategories() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('mainCategories') == null
      ? []
      : prefs
          .getStringList('mainCategories')
          .map((item) => Category.fromJson(json.decode((item))));
}

setMainCategories(List<Category> items) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> _mainCategories =
      items.map((item) => json.encode(item.toJson())).toList();
  await prefs.setStringList('mainCategories', _mainCategories);
}

getAllCategories() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('allCategories') == null
      ? []
      : prefs
          .getStringList('allCategories')
          .map((item) => Category.fromJson(json.decode((item))));
}

setAllCategories(List<Category> items) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> _allCategories =
      items.map((item) => json.encode(item.toJson())).toList();
  await prefs.setStringList('allCategories', _allCategories);
}

getParentCategories() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('parentCategories') == null
      ? []
      : prefs
          .getStringList('parentCategories')
          .map((item) => Category.fromJson(json.decode((item))));
}

setParentCategories(List<Category> items) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> _parentCategories =
      items.map((item) => json.encode(item.toJson())).toList();
  await prefs.setStringList('parentCategories', _parentCategories);
}

getBanners() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('banners') == null
      ? []
      : prefs
          .getStringList('banners')
          .map((item) => Promotion.fromJson(json.decode(item)));
}

setBanners(List<Promotion> items) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> _banners =
      items.map((item) => json.encode(item.toJson())).toList();
  await prefs.setStringList('banners', _banners);
}

isFirstConnexion() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isFirstConnexion') ?? true;
}

getDatabaseUrl() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('databaseUrl') ?? '';
}

getDatabaseImageUrl() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('databaseImageUrl') ?? '';
}

setDatabaseUrl(String url, String mode, String imageUrl) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('databaseUrl', url);
  await prefs.setString('databaseMode', mode);
  await prefs.setString('databaseImageUrl', imageUrl);
}

getDatabaseMode() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('databaseMode') ?? '';
}

setFirstConnexion() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isFirstConnexion', false);
}

Widget renderStars(int length) {
  return Container(
    width: 60.0,
    height: 20.0,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 5,
      itemBuilder: (BuildContext context, int index) {
        for (var i = 0; i < length; i++) {
          return Icon(Icons.star, color: Colors.orange, size: 12.0);
        }
        for (var i = 0; i < 5 - length; i++) {
          return Icon(Icons.star_border, color: Colors.orange, size: 12.0);
        }
        return null;
      },
    ),
  );
}

String discountPercent(int oldPrice, int newPrice) {
  double value = ((oldPrice - newPrice) / oldPrice) * 100;
  return value.toString().length > 3
      ? '${value.toString().substring(0, 4)}'
      : '${value.toString()}';
}

getCart() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('cart') == null
      ? []
      : prefs.getStringList('cart').map((item) => json.decode(item));
}

getCartLength() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt('cartLength') ?? 0;
}

setCartLength(int length) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  length = length;
  await prefs.setInt('cartLength', length);
}

getCartTotal() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt('cartTotal') ?? 0;
}

setCartTotal(List items) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  total = 0;
  for (int i = 0; i < items.length; i++) {
    total += items[i]?.newPrice == 0 || items[i]?.newPrice == null
        ? (items[i]?.oldPrice ?? 0) * quantities[i]
        : (items[i]?.newPrice ?? 0) * quantities[i];
  }

  await prefs.setInt('cartTotal', total);
}

storeProductCart(List items) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  carts = items;
  List<String> cart = [];
  items.map((item) => cart.add(json.encode(item.toJson()))).toList();
  await setCartTotal(items);
  await setCartLength(items.length);
  await prefs.setStringList('cart', cart);
}

getCartQuantities() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('quantities') == null
      ? []
      : prefs
          .getStringList('quantities')
          .map((value) => int.parse(value))
          .toList();
}

setCartQuantities(List quantities) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> qty = [];
  quantities.map((item) => qty.add(item.toString())).toList();
  await prefs.setStringList('quantities', qty);
}

clearTotal() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt('cartTotal', 0);
}

setTotal(int price, String sign) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int cartTotal = prefs.getInt('cartTotal') ?? 0;
  if (cartTotal > 0) {
    switch (sign) {
      case '-':
        cartTotal -= price;
        break;
      case '+':
        cartTotal += price;
    }
    prefs.setInt('cartTotal', cartTotal);
  }
  total = cartTotal;
}

evaluateTotal(int price) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int cartTotal = prefs.getInt('cartTotal') ?? 0;
  cartTotal += price;
  total = cartTotal;
  prefs.setInt('cartTotal', cartTotal);
}

isLogged() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLogged') ?? false;
}

getCurrentUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return json.decode(prefs.getString('currentClient'));
}

getUserToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}

logIn(client, String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String cli = json.encode(client);
  await prefs.setString('currentClient', cli);
  await prefs.setString('token', token);
  await prefs.setBool('isLogged', true);
}

logOut() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLogged', false);
}

bool canAddProduct(Product product) {
  List _shopIds = [];
  for (var item in commandShopIds) {
    if (!_shopIds.contains(item)) {
      _shopIds.add(item);
    }
  }
  int idOfShop = product.shopId;
  if (_shopIds.contains(idOfShop)) {
    return true;
  } else {
    if (numberOfShopInCommand < 2) {
      numberOfShopInCommand++;
      return true;
    } else {
      return false;
    }
  }
}

setNumberOfShopInCommand() {
  List _shopIds = [];
  for (var item in commandShopIds) {
    if (!_shopIds.contains(item)) {
      _shopIds.add(item);
    }
  }
  if (_shopIds.length > 1) {
    numberOfShopInCommand = 2;
  } else if (_shopIds.length == 1) {
    numberOfShopInCommand = 1;
  } else {
    numberOfShopInCommand = 0;
  }
}

clearShopInCommand() {
  numberOfShopInCommand = 0;
  commandShopIds = [];
  shopNames = [];
}

List favorites = [],
    carts = [],
    recents = [],
    quantities = [],
    commandShopIds = [];
String errorMessageText, token = '';
int length = 0, total = 0, numberOfShopInCommand;
List<String> cartNames = [],
    cartDescription = [],
    favoriteDescriptions = [],
    favoriteNames = [],
    shopNames = [];
String userCode = '';
int userId = 0;
bool isLoggedIn = false;
var months = [
  'Janv.',
  'Fevr.',
  'Mars',
  'Avr.',
  'Mai',
  'Juin',
  'Juil.',
  'Aout',
  'Sept.',
  'Oct.',
  'Nov',
  'Dec'
];