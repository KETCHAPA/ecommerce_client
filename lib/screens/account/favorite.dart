import 'package:client_bos_final/common/globals.dart';
import 'package:client_bos_final/screens/product/showProduct.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class FavoriteItemPage extends StatefulWidget {
  @override
  _FavoriteItemPageState createState() => _FavoriteItemPageState();
}

class _FavoriteItemPageState extends State<FavoriteItemPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('Vos Favoris'),
        ),
        body: favorites.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.layers_clear,
                      size: 150.0,
                    ),
                    Text(
                      'Aucun favoris',
                    ),
                  ],
                ),
              )
            : StaggeredGridView.countBuilder(
                crossAxisCount: 4,
                itemCount: favorites.length,
                itemBuilder: (BuildContext context, int index) => new Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          if (recents.contains(favorites[index])) {
                            recents.add(favorites[index]);
                          }
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShowProductPage(
                                        code: favorites[index].code,
                                      )));
                        },
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height: index % 2 == 0
                                  ? 205.0
                                  : index % 3 == 0 ? 195.0 : 185.0,
                              child: Image.network(
                                  imagePath('${favorites[index].photo}'),
                                  fit: BoxFit.fitHeight),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(10.0))),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 7.0, vertical: 2.0),
                                child: Text(
                                  '-${discountPercent(favorites[index].oldPrice, favorites[index].newPrice)}%',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              favorites[index].name.length > 17
                                  ? '${favorites[index].name.substring(0, 17)}...'
                                  : favorites[index].name,
                              style: TextStyle(fontSize: 13.0),
                            ),
                            SizedBox(height: 3.0),
                            Text(
                              favorites[index].newPrice == 0 ||
                                      favorites[index].newPrice == null
                                  ? '${favorites[index].oldPrice} Fcfa '
                                  : '${favorites[index].newPrice} Fcfa',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18.0),
                            ),
                            SizedBox(height: 4.0),
                            Row(
                              children: <Widget>[
                                renderStars(favorites[index].rate),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  parseIntToDouble(favorites[index].rate)
                                      .toString(),
                                  style: TextStyle(fontSize: 13.0),
                                ),
                                Spacer(),
                                Container(
                                  width: 40.0,
                                  height: 27.0,
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        favorites.removeAt(index);
                                        storeFavorite(favorites);
                                      });
                                    },
                                    icon: Icon(Icons.delete,
                                        size: 20.0, color: Colors.red),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
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
