import 'package:client_bos_final/custom/sweetAlert.dart';
import 'package:client_bos_final/icons/socicon_icons.dart';
import 'package:client_bos_final/model/clients.dart';
import 'package:client_bos_final/service/homeService.dart';
import 'package:flutter/material.dart';
import 'package:sweetalert/sweetalert.dart';

class NewMailPage extends StatefulWidget {
  final Client client;
  NewMailPage({this.client});
  @override
  _NewMailPageState createState() => _NewMailPageState();
}

class _NewMailPageState extends State<NewMailPage> {
  final _senderController = new TextEditingController(text: 'De: ');
  final _subjectController = new TextEditingController();
  final _contentController = new TextEditingController();

  final _senderNode = new FocusNode();
  final _subjectNode = new FocusNode();
  final _contentNode = new FocusNode();

  List<String> emails = [];
  String receiver = '';

  Future<List<Client>> clients;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    clients = fetchUsers();
    super.initState();
    if (widget.client != null) {
      _senderController.text = widget.client.email;
    }
  }

  _submit() {
    if (_formKey.currentState.validate()) {
      new Future.delayed(
          Duration(
            seconds: 3,
          ), () {
        SweetAlert.show(context,
            subtitle: 'Message envoye', style: SweetAlertStyle.success);
      });
      Navigator.pushNamed(context, '/home');
    } else {
      sweetalert(
          context: context,
          withConfirmation: false,
          subtitle: 'Remplissez tous les champs',
          type: SweetAlertStyle.confirm);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back)),
        title: Text(
          'Nouveau message',
        ),
        actions: <Widget>[
          InkWell(
              onTap: _submit,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(Socicon.telegram),
              )),
        ],
      ),
      body: SafeArea(
        top: true,
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: <Widget>[
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  controller: _senderController,
                  focusNode: _senderNode,
                  onFieldSubmitted: (_) {
                    _senderNode.unfocus();
                    FocusScope.of(context).requestFocus(_subjectNode);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Renseigner l\'adresse de l\'emetteur';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                FutureBuilder(
                    future: clients,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        for (var item in snapshot.data) {
                          if (!emails.contains(item.email)) {
                            emails.add(item.email);
                          }
                        }
                        return Container(
                          height: 35.0,
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey))),
                          child: Stack(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    'A: ',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                  Text(
                                    '$receiver',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                  Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.grey,
                                    ),
                                  )
                                ],
                              ),
                              DropdownButtonHideUnderline(
                                  child: ButtonTheme(
                                alignedDropdown: true,
                                child: DropdownButton<String>(
                                    iconEnabledColor: Colors.white,
                                    style: Theme.of(context).textTheme.title,
                                    items: emails.map((String value) {
                                      return DropdownMenuItem(
                                        child: new Text('$value'),
                                        value: value,
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        value = value;
                                        receiver = value;
                                      });
                                    }),
                              ))
                            ],
                          ),
                        );
                      }
                      return Container(
                        height: 35.0,
                        decoration: BoxDecoration(
                            border:
                                Border(bottom: BorderSide(color: Colors.grey))),
                        child: Stack(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  'A: ',
                                  style: TextStyle(fontSize: 16.0),
                                ),
                                Text(
                                  '$receiver',
                                  style: TextStyle(fontSize: 16.0),
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.grey,
                                  ),
                                )
                              ],
                            ),
                            DropdownButtonHideUnderline(
                                child: ButtonTheme(
                                    alignedDropdown: true,
                                    child: DropdownButton<String>(
                                      onChanged: null,
                                      iconEnabledColor: Colors.white,
                                      style: Theme.of(context).textTheme.title,
                                      items: [''].map((String value) {
                                        return DropdownMenuItem(
                                          child: new Text('$value'),
                                          value: value,
                                        );
                                      }).toList(),
                                    )))
                          ],
                        ),
                      );
                    }),
                SizedBox(
                  height: 5.0,
                ),
                TextFormField(
                  controller: _subjectController,
                  focusNode: _subjectNode,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (term) {
                    _subjectNode.unfocus();
                    FocusScope.of(context).requestFocus(_contentNode);
                  },
                  decoration: InputDecoration(
                      hintText: 'Objet',
                      hintStyle: TextStyle(color: Colors.black)),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  controller: _contentController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  maxLines: 5,
                  focusNode: _contentNode,
                  onFieldSubmitted: (term) {
                    _submit();
                  },
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Redigez votre message',
                      hintStyle: TextStyle(color: Colors.black)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
