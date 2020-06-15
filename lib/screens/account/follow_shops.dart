import 'package:client_bos_final/common/globals.dart';
import 'package:client_bos_final/custom/navigation_bar.dart';
import 'package:client_bos_final/model/shops.dart';
import 'package:client_bos_final/screens/product/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class FollowShop extends StatefulWidget {
  @override
  _FollowShopState createState() => _FollowShopState();
}

class _FollowShopState extends State<FollowShop> {
  Future<List<Shop>> shops;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('Magasins suivis'),
        ),
        bottomNavigationBar: CustomNavigationBar(2),
        body: favoritesShops.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.layers_clear,
                      size: 150.0,
                    ),
                    Text(
                      'Aucun magasin suivi',
                    ),
                  ],
                ),
              )
            : StaggeredGridView.countBuilder(
                crossAxisCount: 4,
                itemCount: favoritesShops.length,
                itemBuilder: (BuildContext context, int index) => new Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductsPage(
                                        shop: favoritesShops[index],
                                      )));
                        },
                        child: Container(
                          height: index % 2 == 0
                              ? 205.0
                              : index % 3 == 0 ? 195.0 : 185.0,
                          child: Image.network(
                              imagePath('${favoritesShops[index].photo}'),
                              fit: BoxFit.fitHeight),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              favoritesShops[index].name.length > 17
                                  ? '${favoritesShops[index].name.substring(0, 17)}...'
                                  : favoritesShops[index].name,
                              style: TextStyle(fontSize: 13.0),
                            ),
                            SizedBox(
                                height: index % 2 == 0
                                    ? 7.2
                                    : index % 3 == 0 ? 7.1 : 7.0),
                            Row(
                              children: <Widget>[
                                Spacer(),
                                renderStars(favoritesShops[index].rate),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  parseIntToDouble(favoritesShops[index].rate)
                                      .toString(),
                                  style: TextStyle(fontSize: 13.0),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            favoritesShops.remove(favoritesShops[index]);
                            favoritesShops.remove(favoritesShops[index].name);
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Icon(Icons.delete_sweep),
                        ),
                      )
                    ],
                  ),
                ),
                staggeredTileBuilder: (int index) => new StaggeredTile.count(
                    2, index % 2 == 0 ? 3.2 : index % 3 == 0 ? 3.1 : 3),
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
              ));
  }
}
