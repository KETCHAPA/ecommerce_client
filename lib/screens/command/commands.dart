import 'package:client_bos_final/screens/command/show.dart';
import 'package:client_bos_final/service/commandService.dart';
import 'package:flutter/material.dart';

class CommandPage extends StatefulWidget {
  final String code;
  final String title;
  final String filter;
  CommandPage(
      {@required this.code, @required this.title, @required this.filter});
  @override
  _CommandPageState createState() => _CommandPageState();
}

class _CommandPageState extends State<CommandPage> {
  List commands;
  var client;
  List products;
  String statut;
  bool _isAllMode = false;
  Future _commands;
  String _errorMessage;
  List<OptionView> data;
  int currentDataIndex = 0;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    data = [
      OptionView("Toutes", fetchAllCommands(widget.code), 'Aucune commande'),
      OptionView("en attente", fetchWaitingCommands(widget.code),
          'Aucune commande en attente'),
      OptionView("en cours de traitement", fetchProcessedCommands(widget.code),
          'Aucune commande en cours de traitement'),
      OptionView("rejetees", fetchRejectedCommands(widget.code),
          'Aucune commande rejetee'),
      OptionView("cloturees", fetchOnRoadCommands(widget.code),
          'Aucune commande cloturee')
    ];

    if (widget.filter == 'en_attente') {
      _commands = fetchWaitingCommands(widget.code);
      _errorMessage = 'Aucune commande en attente';
    } else if (widget.filter == 'en_route') {
      _commands = fetchOnRoadCommands(widget.code);
      _errorMessage = 'Aucune commande en route';
    } else {
      _isAllMode = true;
      _commands = fetchAllCommands(widget.code);
      _errorMessage = 'Aucune commande';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(widget.title),
          actions: <Widget>[
            _isAllMode
                ? IconButton(
                    icon: Icon(Icons.sort),
                    tooltip: 'Filtrer',
                    onPressed: () =>
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                      backgroundColor: Colors.black87,
                      elevation: 10.0,
                      action: SnackBarAction(
                        textColor: Colors.redAccent,
                        label: 'Fermer',
                        onPressed: () =>
                            _scaffoldKey.currentState.hideCurrentSnackBar(),
                      ),
                      duration: new Duration(minutes: 1),
                      content: Container(
                        height: 30.0 * data.length,
                        child: ListView.builder(
                          itemBuilder: (context, int index) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  _commands = data[index].link;
                                  _errorMessage = data[index].error;
                                  currentDataIndex = index;
                                });
                                _scaffoldKey.currentState.hideCurrentSnackBar();
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 2.5),
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      index == currentDataIndex
                                          ? Icons.check_circle_outline
                                          : Icons.brightness_1,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Text(
                                      data[index].title,
                                      style: TextStyle(
                                          fontWeight: index == currentDataIndex
                                              ? FontWeight.bold
                                              : FontWeight.normal),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount: data.length,
                        ),
                      ),
                    )),
                  )
                : SizedBox()
          ],
        ),
        body: FutureBuilder(
            future: _commands,
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData) {
                commands = snapshot.data['commandes'];
                client = snapshot.data['client'];
                return commands.isEmpty || commands == null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.layers_clear,
                              size: 150.0,
                            ),
                            Text('$_errorMessage')
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: ListView.builder(
                          itemCount: commands.length,
                          itemBuilder: (context, index) {
                            products = commands[index]['products'];
                            statut = commands[index]['already_delivered'] == '0'
                                ? 'En Attente'
                                : commands[index]['already_delivered'] == '1'
                                    ? 'Validee'
                                    : commands[index]['already_delivered'] ==
                                            '2'
                                        ? 'En route'
                                        : 'Rejetee';

                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ShowCommand(
                                                commands[index]['code'],
                                              )));
                                },
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 22.0, vertical: 12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                            'Commande ${commands[index]['code']}'),
                                        SizedBox(height: 5.0),
                                        Text(
                                            'Client: ${client['name'].toUpperCase()}'),
                                        SizedBox(height: 5.0),
                                        Text('Statut: Commande $statut'),
                                        SizedBox(height: 5.0),
                                        Text(
                                            'Montant: ${commands[index]['amount']} Fcfa'),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
              }
              return Center(child: CircularProgressIndicator());
            }));
  }
}

class OptionView {
  String title;
  Future link;
  String error;
  OptionView(this.title, this.link, this.error);
}
