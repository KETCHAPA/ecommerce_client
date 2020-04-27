import 'dart:async';
import 'package:client_bos_final/common/ENDPOINT.dart';
import 'package:client_bos_final/common/globals.dart';
import 'package:client_bos_final/custom/sweetAlert.dart';
import 'package:client_bos_final/icons/socicon_icons.dart';
import 'package:client_bos_final/model/categories.dart';
import 'package:client_bos_final/screens/home/send_message.dart';
import 'package:client_bos_final/screens/product/products.dart';
import 'package:client_bos_final/screens/search/search.dart';
import 'package:client_bos_final/service/categoryService.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:sweetalert/sweetalert.dart';

class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  List<Category> recommandationData = [
    Category(name: 'Chaussures', photo: 'main_category_photos/baskets.jpg'),
    Category(name: 'Pantalons', photo: 'main_category_photos/pants.jpg'),
    Category(name: 'Robes', photo: 'main_category_photos/women.jpg'),
    Category(name: 'Chemises', photo: 'main_category_photos/clothes.jpg'),
    Category(name: 'Jupes', photo: 'main_category_photos/child.jpg'),
    Category(
        name: 'Boucles d\'oreille', photo: 'main_category_photos/watches.jpg'),
    Category(name: 'Enfants', photo: 'main_category_photos/child.jpg'),
    Category(name: 'Femmes', photo: 'main_category_photos/women.jpg')
  ],
      childrenCategories;
  String catName = '';
  int isSelected = 0;
  List<String> bannerImages = [];
  int _currentPage = 0;
  PageController _pageController = PageController();
  bool isLoadingChildren = false;
  Future _parentCategories;
  GlobalKey<RefreshIndicatorState> _refreshKey;

  _fetchCategoriesChildren(id) async {
    setState(() {
      isLoadingChildren = true;
    });
    try {
      final response = await http.get('$endPoint/childrenCategory/$id');
      if (response.statusCode == 200) {
        final res = json.decode(response.body);
        Iterable items = res['data'];
        childrenCategories.clear();
        items
            .map((item) => childrenCategories.add(new Category.fromJson(item)))
            .toList();
        setState(() {
          isLoadingChildren = false;
        });
      }
    } catch (e) {
      throw Exception('Erreur de recuperation des categories $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _refreshKey = GlobalKey<RefreshIndicatorState>();
    childrenCategories = recommandationData;
    _parentCategories = getParentCategories();

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

  _fetchData() async {
    List<Category> _parentCategories = await fetchParentCategories();
    await setParentCategories(_parentCategories);
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

  _searchRedirection() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SearchPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      top: true,
      child: RefreshIndicator(
        key: _refreshKey,
        onRefresh: () async {
          await _refreshData();
          Navigator.of(context).popAndPushNamed('/categories');
        },
        child: ListView(
          children: <Widget>[
            Stack(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.black,
                        size: 20.0,
                      ),
                      contentPadding: EdgeInsets.only(top: 20.0, left: 20.0),
                      suffixIcon: Icon(Socicon.telegram),
                      hintText: 'Recherche...',
                      hintStyle: TextStyle(color: Colors.grey)),
                ),
                Row(
                  children: <Widget>[
                    InkWell(
                      onTap: _searchRedirection,
                      child: Container(
                        width: MediaQuery.of(context).size.width * .86,
                        height: 50.0,
                        color: Colors.transparent,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NewMailPage()));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * .14,
                        height: 50.0,
                        color: Colors.transparent,
                      ),
                    ),
                  ],
                )
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 128.0,
              child: Row(
                children: <Widget>[
                  FutureBuilder(
                      future: _parentCategories,
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
                          List parentCategories = [];
                          parentCategories
                              .add(Category(name: 'Recommandations'));
                          for (var item in snapshot.data) {
                            if (!parentCategories.contains(item)) {
                              parentCategories.add(item);
                            }
                          }
                          return Container(
                            width: MediaQuery.of(context).size.width * .3,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.5)),
                            child: ListView.builder(
                              itemCount: parentCategories.length,
                              itemBuilder: (BuildContext context, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 0.1),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        isSelected = index;
                                        catName = parentCategories[index].name;
                                        childrenCategories =
                                            _fetchCategoriesChildren(
                                                parentCategories[index].id);
                                      });
                                    },
                                    child: Container(
                                        height: 60.0,
                                        color: isSelected == index
                                            ? Colors.white
                                            : Colors.grey.withOpacity(.5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Spacer(),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(3.0),
                                              child: Text(
                                                parentCategories[index].name,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.black,
                                                    fontSize:
                                                        isSelected == index
                                                            ? 12.0
                                                            : 11.0,
                                                    letterSpacing: 1.1),
                                              ),
                                            ),
                                            Spacer()
                                          ],
                                        )),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                        return Container();
                      }),
                  Container(
                    width: MediaQuery.of(context).size.width * .7,
                    height: MediaQuery.of(context).size.height,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 3.0, left: 3.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Container(
                                height: 100.0,
                                width: MediaQuery.of(context).size.width * .7,
                                child: FutureBuilder(
                                    future: getBanners(),
                                    builder: (BuildContext context, snapshot) {
                                      if (snapshot.hasData) {
                                        for (var item in snapshot.data) {
                                          if (!bannerImages
                                              .contains(item.photo)) {
                                            bannerImages.add(item.photo);
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
                                              itemBuilder:
                                                  (BuildContext context,
                                                      index) {
                                                return Image.network(
                                                    imagePath(
                                                        bannerImages[index]),
                                                    fit: BoxFit.cover);
                                              },
                                            ),
                                            Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Container(
                                                width: 80.0,
                                                height: 20.0,
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: ListView.builder(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount:
                                                        bannerImages.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            index) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(2.0),
                                                        child: Icon(
                                                          Icons.brightness_1,
                                                          size: index ==
                                                                  _currentPage
                                                              ? 8.0
                                                              : 7.0,
                                                          color: index ==
                                                                  _currentPage
                                                              ? Color(
                                                                  0xff31275c)
                                                              : Colors.blueGrey
                                                                  .withOpacity(
                                                                      .3),
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
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 10.0),
                              child: Text(
                                catName,
                                style: TextStyle(
                                    fontSize: 15.0, color: Colors.blueGrey),
                              ),
                            ),
                            isLoadingChildren
                                ? Center(child: CircularProgressIndicator())
                                : Container(
                                    width:
                                        MediaQuery.of(context).size.width * .7,
                                    height: MediaQuery.of(context).size.height -
                                        215.0,
                                    child: GridView.builder(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3),
                                      itemCount: childrenCategories.length,
                                      itemBuilder:
                                          (BuildContext context, index) {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProductsPage(
                                                            category:
                                                                childrenCategories[
                                                                    index])));
                                          },
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .23,
                                                  height: 55.0,
                                                  child: Image.network(imagePath(
                                                      '${childrenCategories[index].photo}'))),
                                              Container(
                                                  child: Text(
                                                childrenCategories[index]
                                                            .name
                                                            .length >
                                                        11
                                                    ? '${childrenCategories[index].name.substring(0, 11)}...'
                                                    : childrenCategories[index]
                                                        .name,
                                                style:
                                                    TextStyle(fontSize: 10.0),
                                              ))
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
