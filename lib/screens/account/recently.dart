import 'package:client_bos_final/common/globals.dart';
import 'package:client_bos_final/screens/product/showProduct.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class RecentlyProductPage extends StatefulWidget {
  @override
  _RecentlyProductPageState createState() => _RecentlyProductPageState();
}

class _RecentlyProductPageState extends State<RecentlyProductPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('Vu Recemment'),
        ),
        body: recents.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.layers_clear,
                      size: 150.0,
                    ),
                    Text(
                      'Aucun produit recemment vu',
                    ),
                  ],
                ),
              )
            : StaggeredGridView.countBuilder(
                crossAxisCount: 4,
                itemCount: recents.length,
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
                                  builder: (context) => ShowProductPage(
                                        code: recents[index].code,
                                      )));
                        },
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height: index % 2 == 0
                                  ? 205.0
                                  : index % 3 == 0 ? 195.0 : 185.0,
                              child: Image.network(
                                  imagePath('${recents[index].photo}'),
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
                                  '-${discountPercent(recents[index].oldPrice, recents[index].newPrice)}%',
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
                              recents[index].name.length > 17
                                  ? '${recents[index].name.substring(0, 17)}...'
                                  : recents[index].name,
                              style: TextStyle(fontSize: 13.0),
                            ),
                            SizedBox(height: 3.0),
                            Text(
                              recents[index].newPrice == 0 ||
                                      recents[index].newPrice == null
                                  ? '${recents[index].oldPrice} Fcfa '
                                  : '${recents[index].newPrice} Fcfa',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18.0),
                            ),
                            SizedBox(height: 4.0),
                            Row(
                              children: <Widget>[
                                renderStars(recents[index].rate),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  parseIntToDouble(recents[index].rate)
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
                                        recents.removeAt(index);
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
