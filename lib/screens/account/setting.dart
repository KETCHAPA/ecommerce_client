import 'package:client_bos_final/common/ENDPOINT.dart';
import 'package:client_bos_final/common/globals.dart';
import 'package:client_bos_final/custom/loading.dart';
import 'package:client_bos_final/icons/icon_data.dart';
import 'package:client_bos_final/icons/socicon_icons.dart';
import 'package:client_bos_final/screens/chooseDatabase2.dart';
import 'package:client_bos_final/service/authentication.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  ProgressDialog progress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Parametres'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
              leading: Icon(Icons.language), title: Text('Modifier la langue')),
          ListTile(
            leading: Icon(Icons.developer_board),
            title:
                Text('Conditions Generales d\'utilisation de l\'application'),
            trailing: Text(''),
          ),
          InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => Container(
                        height: 300.0,
                        child: AlertDialog(
                          title: Text('Mode actuel'),
                          content: Container(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Text('$modeEndPoint'),
                          ),
                          actions: <Widget>[
                            OutlineButton(
                              child: Text(
                                'Modifier',
                                style: TextStyle(color: Colors.red),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ChooseDataBase2()));
                              },
                            )
                          ],
                        ),
                      ));
            },
            child: ListTile(
              leading: Icon(Icons.mode_edit),
              title: Text('consulter le mode d\'utilisation'),
              trailing: Text(''),
            ),
          ),
          ListTile(leading: Icon(Socicon.play), title: Text('Nous noter')),
          FutureBuilder(
            future: isLogged(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
              if (snapshot.hasData) {
                return snapshot.data == true
                    ? InkWell(
                        onTap: () async {
                          progress = loadingWidget(context);
                          progress.show();
                          await logout().then((success) async {
                            progress.dismiss();
                            if (success) {
                              setState(() {
                                isLoggedIn = false;
                              });
                              await logOut();
                              Navigator.pop(context);
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Erreur de deconnexion'),
                                      content: Text(
                                          'Verifier votre connexion puis reessayer'),
                                      actions: <Widget>[
                                        OutlineButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Okay',
                                              style: TextStyle(
                                                  color: Colors.pink)),
                                        )
                                      ],
                                    );
                                  });
                            }
                          });
                        },
                        child: ListTile(
                            leading: Icon(IconDatas.logout, color: Colors.red),
                            title: Text('Deconnexion',
                                style: TextStyle(
                                  color: Colors.red,
                                ))),
                      )
                    : SizedBox(
                        height: 0.0,
                      );
              }
              return null;
            },
          )
        ],
      ),
    );
  }
}
