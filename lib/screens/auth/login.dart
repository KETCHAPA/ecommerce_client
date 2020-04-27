import 'package:client_bos_final/common/globals.dart';
import 'package:client_bos_final/custom/loading.dart';
import 'package:client_bos_final/custom/logPainter.dart';
import 'package:client_bos_final/custom/sweetAlert.dart';
import 'package:client_bos_final/screens/auth/register.dart';
import 'package:client_bos_final/service/authentication.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:sweetalert/sweetalert.dart';

class LoginPage extends StatefulWidget {
  final Widget redirection;
  LoginPage({@required this.redirection});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _loginController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  FocusNode _loginNode = new FocusNode();
  FocusNode _passwordNode = new FocusNode();

  ProgressDialog progress;

  submit(BuildContext context, progress) async {
    if (_loginController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      Map<String, dynamic> params = Map<String, dynamic>();
      print('${_loginController.text} ${_passwordController.text}');
      params['login'] = _loginController.text;
      params['password'] = _passwordController.text;
      progress = loadingWidget(context);
      progress.show();
      await login(params).then((success) {
        progress.hide();
        if (success) {
          setState(() {
            isLoggedIn = true;
          });
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => widget.redirection));
        } else {
          sweetalert(
              context: context,
              withConfirmation: false,
              title: 'Erreur',
              subtitle: errorMessageText,
              type: SweetAlertStyle.error);
        }
      });
    } else {
      sweetalert(
        context: context,
        subtitle: 'Remplissez tous les champs',
        withConfirmation: false,
        type: SweetAlertStyle.confirm,
      );
    }
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
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 120.0),
                        child: Container(
                          child: ListView(
                            children: <Widget>[
                              Container(
                                height: 70.0,
                                child: Image.asset('img/launcher.png'),
                              ),
                              Center(
                                  child: Text(
                                'Connexion',
                                style: TextStyle(fontSize: 30.0),
                              )),
                              Center(
                                child: Text('Buy, On Send'),
                              ),
                              SizedBox(
                                height: 50.0,
                              ),
                              Stack(
                                children: <Widget>[
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          .9,
                                      height: 50.0,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.blueGrey),
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(40.0))),
                                      child: TextFormField(
                                        onFieldSubmitted: (term) {
                                          _loginNode.unfocus();
                                          FocusScope.of(context)
                                              .requestFocus(_passwordNode);
                                        },
                                        focusNode: _loginNode,
                                        controller: _loginController,
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.supervisor_account,
                                            color: Colors.blueGrey,
                                          ),
                                          border: InputBorder.none,
                                          hintText: 'Nom d\'utilisateur',
                                          hintStyle:
                                              TextStyle(color: Colors.blueGrey),
                                          contentPadding:
                                              new EdgeInsets.fromLTRB(
                                                  10, 13, 10, 7),
                                        ),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 50.0),
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .9,
                                        height: 50.0,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.blueGrey),
                                            borderRadius: BorderRadius.only(
                                                bottomRight:
                                                    Radius.circular(40.0))),
                                        child: TextFormField(
                                          focusNode: _passwordNode,
                                          controller: _passwordController,
                                          obscureText: true,
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(
                                              Icons.lock,
                                              color: Colors.blueGrey,
                                            ),
                                            border: InputBorder.none,
                                            contentPadding:
                                                new EdgeInsets.fromLTRB(
                                                    10, 13, 10, 7),
                                            hintText: 'mot de passe',
                                            hintStyle: TextStyle(
                                                color: Colors.blueGrey),
                                          ),
                                          onFieldSubmitted: (val) {
                                            _passwordNode.unfocus();
                                            submit(context, progress);
                                          },
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 25.0, right: 15.0),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: InkWell(
                                        onTap: () {
                                          submit(context, progress);
                                        },
                                        child: Container(
                                          height: 50.0,
                                          width: 50.0,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30.0)),
                                              gradient: LinearGradient(colors: [
                                                Colors.cyan,
                                                Colors.greenAccent
                                              ])),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
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
                                height: 30.0,
                              ),
                              InkWell(
                                onTap: () {},
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: Text(
                                      'Mot de passe oublie ?',
                                      style: TextStyle(
                                          color:
                                              Colors.blueGrey.withOpacity(.7)),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              Stack(
                                children: <Widget>[
                                  RaisedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RegisterPage(
                                                      redirection:
                                                          widget.redirection)));
                                    },
                                    elevation: 10.0,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.horizontal(
                                            right: Radius.circular(30.0))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(7.0),
                                      child: Text(
                                        'Creer un compte',
                                        style: TextStyle(color: Colors.red),
                                      ),
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
