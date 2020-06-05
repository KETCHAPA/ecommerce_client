import 'package:client_bos_final/common/globals.dart';
import 'package:client_bos_final/icons/awesome_icons.dart';
import 'package:client_bos_final/icons/cart_icons.dart';
import 'package:client_bos_final/icons/icon_data.dart';
import 'package:client_bos_final/icons/socicon_icons.dart';
import 'package:client_bos_final/screens/account/account.dart';
import 'package:client_bos_final/screens/account/follow_shops.dart';
import 'package:client_bos_final/screens/auth/login.dart';
import 'package:client_bos_final/screens/cart/carts.dart';
import 'package:client_bos_final/screens/home/home.dart';
import 'package:client_bos_final/screens/product/products.dart';
import 'package:flutter/material.dart';

class CustomNavigationBar extends StatefulWidget {
  CustomNavigationBar(this.index);
  final int index;
  @override
  _CustomNavigationBarState createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.index,
      items: _allDestinations.map((Destination destination) {
        return BottomNavigationBarItem(
            icon: destination.length == null
                ? Icon(
                    destination.icon,
                    color: destination.index == widget.index
                        ? Color(0xff31275c)
                        : Color(0xff31275c).withOpacity(.5),
                  )
                : Container(
                    width: 40.0,
                    height: 24.0,
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Icon(
                          destination.icon,
                          color: destination.index == widget.index
                              ? Color(0xff31275c)
                              : Color(0xff31275c).withOpacity(.5),
                        ),
                        Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              width: 15.0,
                              height: 15.0,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: [
                                        Colors.red,
                                        Colors.deepOrangeAccent
                                      ]),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
                              child: Center(
                                  child: Text('$length', 
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10.0))),
                            ))
                      ],
                    ),
                  ),
            title: Text(destination.title));
      }).toList(),
      selectedItemColor: Color(0xff31275c),
      onTap: (int index) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    _allDestinations[index].index == 2 && token.isEmpty
                        ? LoginPage(redirection: FollowShop())
                        : _allDestinations[index].redirection));
      },
    );
  }
}

class Destination {
  Destination(this.index, this.title, this.icon, this.redirection,
      {this.length});
  final int index;
  final String title;
  final IconData icon;
  int length;
  final Widget redirection;
}

List<Destination> _allDestinations = <Destination>[
  Destination(0, 'Accueil', Socicon.homes, HomePage()),
  Destination(1, 'Produits', Socicon.buffer, ProductsPage()),
  Destination(2, 'Boutiques', AwesomeIcons.followers, FollowShop()),
  Destination(
      3, 'Panier', Cart.shopping_cart_of_horizontal_lines_design, CartPage(),
      length: length),
  Destination(4, 'Compte', IconDatas.avatar, AccountPage())
];
