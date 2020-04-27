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
  Future _commands;
  String _errorMessage;

  @override
  void initState() {
    super.initState();
    if (widget.filter == 'en_attente') {
      _commands = fetchWaitingCommands(widget.code);
      _errorMessage = 'Aucune commande en attente';
    } else if (widget.filter == 'en_route') {
      _commands = fetchOnRoadCommands(widget.code);
      _errorMessage = 'Aucune commande en attente';
    } else {
      _commands = fetchAllCommands(widget.code);
      _errorMessage = 'Aucune commande';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(widget.title),
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
                                        : 'Cloturee';

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
