import 'dart:convert';
import 'dart:io';

import 'package:client_bos_final/common/globals.dart';
import 'package:client_bos_final/custom/loading.dart';
import 'package:client_bos_final/custom/logPainter.dart';
import 'package:client_bos_final/custom/sweetAlert.dart';
import 'package:client_bos_final/screens/account/account.dart';
import 'package:client_bos_final/screens/cart/finalisation.dart';
import 'package:client_bos_final/service/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:sweetalert/sweetalert.dart';

class UpdateData extends StatefulWidget {
  final Map user;
  final String secondParameter;
  final List items, quantities;
  final int total;
  final int userId;
  UpdateData(
      {this.user,
      this.secondParameter,
      this.items,
      this.userId,
      this.total,
      this.quantities});
  @override
  _UpdateDataState createState() => _UpdateDataState();
}

class _UpdateDataState extends State<UpdateData> {
  final _loginController = new TextEditingController();
  final _passwordController = new TextEditingController();
  final _emailController = TextEditingController();
  final _cPasswordController = TextEditingController();
  final _addressController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _countryController = TextEditingController();
  final _townController = TextEditingController();
  final _streetController = TextEditingController();

  int _currentPage = 0;

  final _emailNode = FocusNode();
  final _cPasswordNode = FocusNode();
  final _addressNode = FocusNode();
  final _nameNode = FocusNode();
  final _phoneNode = FocusNode();
  final _passwordNode = FocusNode();
  final _loginNode = new FocusNode();
  final _countryNode = FocusNode();
  final _townNode = FocusNode();
  final _streetNode = FocusNode();

  ProgressDialog progress;
  void _switchNode(context, FocusNode currentNode, FocusNode nextNode) {
    currentNode.unfocus();
    FocusScope.of(context).requestFocus(nextNode);
  }

  Future<File> file, compressFile;

  Future<File> compress(File file) async {
    var dir = await path_provider.getTemporaryDirectory();
    var result = await FlutterImageCompress.compressAndGetFile(
        file.path, dir.absolute.path + file.path.split('/').last,
        quality: 50);
    return result;
  }

  getGalleryImage() {
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.gallery);
    });
  }

  String _gender;
  String name = '', base64Image = '';

  setPage(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _update(BuildContext context) async {
    Map<String, dynamic> params = Map<String, dynamic>();
    params['name'] = _nameController.text ?? widget.user['name'];
    params['email'] = _emailController.text ?? widget.user['email'];
    params['login'] = _loginController.text ?? widget.user['login'];
    params['phone'] = _phoneController.text ?? widget.user['phone'];
    params['password'] = _passwordController.text ?? widget.user['password'];
    params['c_password'] = _cPasswordController.text ?? widget.user['password'];
    params['address'] = _addressController.text ?? widget.user['address'];
    params['country'] = _countryController.text ?? widget.user['country'];
    params['town'] = _townController.text ?? widget.user['town'];
    params['street'] = _streetController.text ?? widget.user['street'] ?? '';
    params['gender'] = _gender ?? widget.user['gender'] ?? '';
    if (name.isNotEmpty) {
      params['photo'] = name;
      params['photo_encode'] = base64Image;
    }
    progress = loadingWidget(context);
    progress.show();

    await update(params, widget.user['code']).then((success) {
      progress.hide();
      if (success) {
        widget.secondParameter == null
            ? Navigator.push(
                context, MaterialPageRoute(builder: (context) => AccountPage()))
            : Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FinalisationPage(
                          items: widget.items,
                          quantities: widget.quantities,
                          total: widget.total,
                          userId: widget.userId,
                        )));
      } else {
        sweetalert(
            context: context,
            withConfirmation: false,
            title: 'Erreur',
            subtitle: errorMessageText,
            type: SweetAlertStyle.error);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        body: Form(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: ListView(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.white,
                  child: Stack(
                    children: <Widget>[
                      Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          CustomPaint(
                            painter: LogPainter(Colors.orange.withOpacity(0.5),
                                Colors.red.withOpacity(0.5), false),
                            child: Container(
                              height: MediaQuery.of(context).size.height,
                            ),
                          ),
                          CustomPaint(
                            painter: LogPainter(
                                Colors.blue, Colors.cyan.withOpacity(.8), true),
                            child: Container(
                              height: MediaQuery.of(context).size.height,
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 100.0),
                        child: Container(
                          child: ListView(
                            children: <Widget>[
                              Stack(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Spacer(),
                                      RaisedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        elevation: 10.0,
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.horizontal(
                                                    left:
                                                        Radius.circular(30.0))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(7.0),
                                          child: Text(
                                            widget.secondParameter == null
                                                ? 'Mon Compte'
                                                : 'Verification',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Container(
                                height: 70.0,
                                child: Image.asset('img/launcher.png'),
                              ),
                              Center(
                                  child: Text(
                                'Mise a jour',
                                style: TextStyle(fontSize: 30.0),
                              )),
                              Center(
                                child: Text('Buy, On Send'),
                              ),
                              SizedBox(
                                height: 40.0,
                              ),
                              _currentPage == 0
                                  ? Stack(
                                      children: <Widget>[
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .9,
                                            height: 50.0,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.blueGrey),
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(40.0))),
                                            child: TextFormField(
                                              controller: _loginController,
                                              keyboardType: TextInputType.text,
                                              focusNode: _loginNode,
                                              textInputAction:
                                                  TextInputAction.next,
                                              onFieldSubmitted: (val) {
                                                _switchNode(context, _loginNode,
                                                    _passwordNode);
                                              },
                                              decoration: InputDecoration(
                                                prefixIcon: Icon(
                                                  Icons.supervisor_account,
                                                  color: Colors.blueGrey,
                                                ),
                                                hintText:
                                                    '${widget.user['login']}',
                                                hintStyle: TextStyle(
                                                    color: Colors.blueGrey),
                                              ),
                                            )),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 50.0),
                                          child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .9,
                                              height: 50.0,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.blueGrey),
                                              ),
                                              child: TextFormField(
                                                controller: _passwordController,
                                                textInputAction:
                                                    TextInputAction.next,
                                                focusNode: _passwordNode,
                                                obscureText: true,
                                                onFieldSubmitted: (val) {
                                                  _switchNode(
                                                      context,
                                                      _passwordNode,
                                                      _cPasswordNode);
                                                },
                                                decoration: InputDecoration(
                                                  prefixIcon: Icon(
                                                    Icons.lock,
                                                    color: Colors.blueGrey,
                                                  ),
                                                  border: InputBorder.none,
                                                  hintText: '******',
                                                  hintStyle: TextStyle(
                                                      color: Colors.blueGrey),
                                                ),
                                              )),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 100.0),
                                          child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .9,
                                              height: 50.0,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.blueGrey),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          bottomRight:
                                                              Radius.circular(
                                                                  40.0))),
                                              child: TextFormField(
                                                controller:
                                                    _cPasswordController,
                                                obscureText: true,
                                                focusNode: _cPasswordNode,
                                                textInputAction:
                                                    TextInputAction.done,
                                                onFieldSubmitted: (val) {
                                                  _cPasswordNode.unfocus();
                                                  if (_loginController
                                                          .text.isNotEmpty &&
                                                      _passwordController
                                                          .text.isNotEmpty &&
                                                      _passwordController
                                                          .text.isNotEmpty) {
                                                    setPage(1);
                                                  } else {
                                                    sweetalert(
                                                        context: context,
                                                        withConfirmation: false,
                                                        subtitle:
                                                            'Remplissez tous les champs',
                                                        type: SweetAlertStyle
                                                            .confirm);
                                                  }
                                                },
                                                decoration: InputDecoration(
                                                  prefixIcon: Icon(
                                                    Icons.lock,
                                                    color: Colors.blueGrey,
                                                  ),
                                                  border: InputBorder.none,
                                                  contentPadding:
                                                      new EdgeInsets.fromLTRB(
                                                          10, 13, 10, 7),
                                                  hintText: '******',
                                                  hintStyle: TextStyle(
                                                      color: Colors.blueGrey),
                                                ),
                                              )),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 75.0, right: 15.0),
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: InkWell(
                                              onTap: () {
                                                setPage(1);
                                              },
                                              child: Container(
                                                height: 50.0,
                                                width: 50.0,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                30.0)),
                                                    gradient: LinearGradient(
                                                        colors: [
                                                          Colors.cyan,
                                                          Colors.greenAccent
                                                        ])),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Icon(
                                                    Icons.arrow_forward,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  : _currentPage == 1
                                      ? Stack(
                                          children: <Widget>[
                                            Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .9,
                                                height: 50.0,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.blueGrey),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topRight:
                                                                Radius.circular(
                                                                    40.0))),
                                                child: TextFormField(
                                                  autofocus: true,
                                                  controller: _nameController,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  focusNode: _nameNode,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  onFieldSubmitted: (val) {
                                                    _switchNode(context,
                                                        _nameNode, _emailNode);
                                                  },
                                                  decoration: InputDecoration(
                                                    prefixIcon: Icon(
                                                      Icons.account_circle,
                                                      color: Colors.blueGrey,
                                                    ),
                                                    hintText:
                                                        '${widget.user['name'].toUpperCase()}',
                                                    hintStyle: TextStyle(
                                                        color: Colors.blueGrey),
                                                  ),
                                                )),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 50.0),
                                              child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .9,
                                                  height: 50.0,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.blueGrey),
                                                  ),
                                                  child: TextFormField(
                                                    controller:
                                                        _emailController,
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    focusNode: _emailNode,
                                                    keyboardType: TextInputType
                                                        .emailAddress,
                                                    onFieldSubmitted: (val) {
                                                      _switchNode(
                                                          context,
                                                          _emailNode,
                                                          _phoneNode);
                                                    },
                                                    decoration: InputDecoration(
                                                      prefixIcon: Icon(
                                                        Icons.email,
                                                        color: Colors.blueGrey,
                                                      ),
                                                      border: InputBorder.none,
                                                      hintText:
                                                          '${widget.user['email']}',
                                                      hintStyle: TextStyle(
                                                          color:
                                                              Colors.blueGrey),
                                                    ),
                                                  )),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 100.0),
                                              child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .9,
                                                  height: 50.0,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color:
                                                              Colors.blueGrey),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              bottomRight: Radius
                                                                  .circular(
                                                                      40.0))),
                                                  child: TextFormField(
                                                    controller:
                                                        _phoneController,
                                                    focusNode: _phoneNode,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    textInputAction:
                                                        TextInputAction.done,
                                                    onFieldSubmitted: (val) {
                                                      _phoneNode.unfocus();
                                                    },
                                                    decoration: InputDecoration(
                                                      prefixIcon: Icon(
                                                        Icons.phone,
                                                        color: Colors.blueGrey,
                                                      ),
                                                      border: InputBorder.none,
                                                      contentPadding:
                                                          new EdgeInsets
                                                                  .fromLTRB(
                                                              10, 13, 10, 7),
                                                      hintText:
                                                          '${widget.user['phone']}',
                                                      hintStyle: TextStyle(
                                                          color:
                                                              Colors.blueGrey),
                                                    ),
                                                  )),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 75.0, right: 15.0),
                                              child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: InkWell(
                                                  onTap: () {
                                                    setPage(2);
                                                  },
                                                  child: Container(
                                                    height: 50.0,
                                                    width: 50.0,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    30.0)),
                                                        gradient:
                                                            LinearGradient(
                                                                colors: [
                                                              Colors.cyan,
                                                              Colors.greenAccent
                                                            ])),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: Icon(
                                                        Icons.arrow_forward,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      : _currentPage == 2
                                          ? Stack(
                                              children: <Widget>[
                                                Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            .9,
                                                    height: 50.0,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors
                                                                .blueGrey),
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topRight: Radius
                                                                    .circular(
                                                                        40.0))),
                                                    child: TextFormField(
                                                      autofocus: true,
                                                      controller:
                                                          _countryController,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      focusNode: _countryNode,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      onFieldSubmitted: (val) {
                                                        _switchNode(
                                                            context,
                                                            _countryNode,
                                                            _townNode);
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        prefixIcon: Icon(
                                                          Icons.location_on,
                                                          color:
                                                              Colors.blueGrey,
                                                        ),
                                                        hintText:
                                                            '${widget.user['country'] ?? 'Non renseigne'}',
                                                        hintStyle: TextStyle(
                                                            color: Colors
                                                                .blueGrey),
                                                      ),
                                                    )),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 50.0),
                                                  child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              .9,
                                                      height: 50.0,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors
                                                                .blueGrey),
                                                      ),
                                                      child: TextFormField(
                                                        controller:
                                                            _townController,
                                                        textInputAction:
                                                            TextInputAction
                                                                .next,
                                                        focusNode: _townNode,
                                                        keyboardType:
                                                            TextInputType.text,
                                                        onFieldSubmitted:
                                                            (val) {
                                                          _switchNode(
                                                              context,
                                                              _townNode,
                                                              _addressNode);
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                          prefixIcon: Icon(
                                                            Icons.location_city,
                                                            color:
                                                                Colors.blueGrey,
                                                          ),
                                                          border:
                                                              InputBorder.none,
                                                          hintText:
                                                              '${widget.user['town'] ?? 'Non renseigne'}',
                                                          hintStyle: TextStyle(
                                                              color: Colors
                                                                  .blueGrey),
                                                        ),
                                                      )),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 100.0),
                                                  child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              .9,
                                                      height: 50.0,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: Colors
                                                                  .blueGrey),
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          40.0))),
                                                      child: TextFormField(
                                                        controller:
                                                            _addressController,
                                                        textInputAction:
                                                            TextInputAction
                                                                .next,
                                                        focusNode: _addressNode,
                                                        keyboardType:
                                                            TextInputType.text,
                                                        onFieldSubmitted:
                                                            (val) {
                                                          _switchNode(
                                                              context,
                                                              _addressNode,
                                                              _streetNode);
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                          prefixIcon: Icon(
                                                            Icons
                                                                .local_activity,
                                                            color:
                                                                Colors.blueGrey,
                                                          ),
                                                          border:
                                                              InputBorder.none,
                                                          hintText:
                                                              '${widget.user['address'] ?? 'Non renseigne'}',
                                                          hintStyle: TextStyle(
                                                              color: Colors
                                                                  .blueGrey),
                                                        ),
                                                      )),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 75.0,
                                                          right: 15.0),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          _currentPage++;
                                                        });
                                                      },
                                                      child: Container(
                                                        height: 50.0,
                                                        width: 50.0,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        30.0)),
                                                            gradient:
                                                                LinearGradient(
                                                                    colors: [
                                                                  Colors.cyan,
                                                                  Colors
                                                                      .greenAccent
                                                                ])),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: Icon(
                                                            Icons.arrow_forward,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          : Stack(
                                              children: <Widget>[
                                                Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            .9,
                                                    height: 50.0,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors
                                                                .blueGrey),
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topRight: Radius
                                                                    .circular(
                                                                        40.0))),
                                                    child: TextFormField(
                                                      controller:
                                                          _streetController,
                                                      focusNode: _streetNode,
                                                      textInputAction:
                                                          TextInputAction.done,
                                                      onFieldSubmitted: (val) {
                                                        _streetNode.unfocus();
                                                        _update(context);
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        prefixIcon: Icon(
                                                          Icons.pin_drop,
                                                          color:
                                                              Colors.blueGrey,
                                                        ),
                                                        border:
                                                            InputBorder.none,
                                                        contentPadding:
                                                            new EdgeInsets
                                                                    .fromLTRB(
                                                                10, 13, 10, 7),
                                                        hintText:
                                                            '${widget.user['street'] ?? 'Non renseigne'}',
                                                        hintStyle: TextStyle(
                                                            color: Colors
                                                                .blueGrey),
                                                      ),
                                                    )),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 50.0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      if (_gender == null) {
                                                        if (widget.user[
                                                                'gender'] ==
                                                            null) {
                                                          setState(() {
                                                            _gender = 'homme';
                                                          });
                                                        } else {
                                                          setState(() {
                                                            _gender = widget
                                                                        .user[
                                                                            'gender']
                                                                        .toUpperCase() ==
                                                                    'HOMME'
                                                                ? 'femme'
                                                                : 'homme';
                                                          });
                                                        }
                                                      } else {
                                                        setState(() {
                                                          _gender =
                                                              _gender.toUpperCase() ==
                                                                      'HOMME'
                                                                  ? 'femme'
                                                                  : 'homme';
                                                        });
                                                      }
                                                    },
                                                    child: Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            .9,
                                                        height: 50.0,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .blueGrey),
                                                            borderRadius:
                                                                BorderRadius.only(
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            40.0))),
                                                        child: Container(
                                                          child: Row(
                                                            children: <Widget>[
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10.0),
                                                                child: Icon(
                                                                  Icons
                                                                      .person_pin,
                                                                  color: Colors
                                                                      .blueGrey,
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            13.0),
                                                                child: Text(
                                                                  '${(_gender ?? widget.user['gender'] ?? 'Non Renseigne').toUpperCase()}',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16.0,
                                                                    color: Colors
                                                                        .blueGrey,
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .transparent),
                                                          ),
                                                        )),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 25.0,
                                                          right: 15.0),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          _update(context);
                                                        });
                                                      },
                                                      child: Container(
                                                        height: 50.0,
                                                        width: 50.0,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        30.0)),
                                                            gradient:
                                                                LinearGradient(
                                                                    colors: [
                                                                  Colors.cyan,
                                                                  Colors
                                                                      .greenAccent
                                                                ])),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: Icon(
                                                            Icons.arrow_forward,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  _currentPage > 2
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text('Photo de profil'),
                                              SizedBox(
                                                width: 10.0,
                                              ),
                                              InkWell(
                                                onTap: getGalleryImage,
                                                child: Container(
                                                  width: 55.0,
                                                  height: 55.0,
                                                  child: Stack(
                                                    children: <Widget>[
                                                      Container(
                                                        width: 50.0,
                                                        height: 50.0,
                                                        child: ClipOval(
                                                            child:
                                                                FutureBuilder(
                                                                    future:
                                                                        file,
                                                                    builder: (BuildContext
                                                                            context,
                                                                        AsyncSnapshot<File>
                                                                            snapshot) {
                                                                      if (snapshot.connectionState ==
                                                                              ConnectionState
                                                                                  .done &&
                                                                          null !=
                                                                              snapshot.data) {
                                                                        return FutureBuilder(
                                                                          future:
                                                                              compress(snapshot.data),
                                                                          builder:
                                                                              (BuildContext context, AsyncSnapshot<File> snapshot) {
                                                                            if (snapshot.connectionState == ConnectionState.done &&
                                                                                null != snapshot.data) {
                                                                              name = '${snapshot.data.path.split('/').last}';
                                                                              base64Image = '${base64Encode(snapshot.data.readAsBytesSync())}';
                                                                              return Image.file(
                                                                                snapshot.data,
                                                                                fit: BoxFit.fill,
                                                                                width: MediaQuery.of(context).size.width * .5,
                                                                              );
                                                                            } else if (null !=
                                                                                snapshot.error) {
                                                                              Scaffold.of(context).showSnackBar(SnackBar(
                                                                                content: Text('Erreur de compression de l\'image'),
                                                                              ));
                                                                            }
                                                                          },
                                                                        );
                                                                      }
                                                                      if (null !=
                                                                          snapshot
                                                                              .error) {
                                                                        Scaffold.of(context)
                                                                            .showSnackBar(SnackBar(
                                                                          content:
                                                                              Text('Erreur de recuperation de l\'image'),
                                                                        ));
                                                                      }
                                                                      return Image
                                                                          .network(
                                                                        imagePath(widget.user['photo'] !=
                                                                                null
                                                                            ? widget.user[
                                                                                'photo']
                                                                            : widget.user['gender'].toUpperCase() == 'FEMME'
                                                                                ? 'users/avatar2.jpg'
                                                                                : 'users/avatar.jpg'),
                                                                        fit: BoxFit
                                                                            .fill,
                                                                      );
                                                                    })),
                                                      ),
                                                      Align(
                                                        alignment: Alignment
                                                            .bottomRight,
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.blue,
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10.0))),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(3.0),
                                                            child: Icon(
                                                              Icons.mode_edit,
                                                              size: 15.0,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  _currentPage == 0
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15.0),
                                          child: Text('Retour',
                                              style: TextStyle(
                                                  color: Colors.grey)),
                                        )
                                      : InkWell(
                                          onTap: () {
                                            setPage(--_currentPage);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15.0),
                                            child: Text('Retour',
                                                style: TextStyle(
                                                    color: Colors.red)),
                                          ),
                                        )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
