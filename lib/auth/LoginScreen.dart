import 'package:churchapp_flutter/auth/ForgotPasswordScreen.dart';
import 'package:churchapp_flutter/auth/RegisterScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/AppStateManager.dart';
import '../i18n/strings.g.dart';
import '../utils/Alerts.dart';
import '../utils/TextStyles.dart';
import 'dart:convert';
import 'dart:async';
import '../utils/my_colors.dart';
import '../utils/ApiUrl.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import '../models/Userdata.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/login";
  LoginScreen();

  @override
  LoginScreenRouteState createState() => new LoginScreenRouteState();
}

class LoginScreenRouteState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  verifyFormAndSubmit() {
    String _email = emailController.text.trim();
    String _password = passwordController.text;

    if (_email == "" || _password == "") {
      Alerts.show(context, t.error, t.emptyfielderrorhint);
    } else if (EmailValidator.validate(_email) == false) {
      Alerts.show(context, t.error, t.invalidemailerrorhint);
    } else {
      loginUser(_email, _password);
    }
  }

  Future<void> loginUser(String email, String password) async {
    Alerts.showProgressDialog(context, t.processingpleasewait);
    try {
      var data = {
        "email": email,
        "password": password,
      };
      final response =
          await http.post(ApiUrl.LOGIN, body: jsonEncode({"data": data}));
      if (response.statusCode == 200) {
        // Navigator.pop(context);
        // If the server did return a 200 OK response,
        // then parse the JSON.
        Navigator.of(context).pop();
        print(response.body);
        Map<String, dynamic> res = json.decode(response.body);
        if (res["status"] == "error") {
          Alerts.show(context, t.error, res["message"]);
        } else {
          print(res["user"]);
          //Alerts.show(context, Strings.success, res["message"]);
          Provider.of<AppStateManager>(context, listen: false)
              .setUserData(Userdata.fromJson(res["user"]));

          Navigator.of(context).pop();
        }
        //print(res);
      }
    } catch (exception) {
      Navigator.of(context).pop();
      Alerts.show(context, t.error, exception.toString());
      // Navigator.pop(context);
      // I get no exception here
      print(exception);
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: true,
      //backgroundColor: Colors.white,
      appBar:
          PreferredSize(child: Container(), preferredSize: Size.fromHeight(0)),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          width: double.infinity,
          //height: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                height: 15,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0, 0, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      Icons.arrow_back,
                    ),
                  ),
                ),
              ),
              Container(
                height: 25,
              ),
              Column(
                children: [
                  Text(t.appname,
                      style: TextStyles.title(context).copyWith(
                          color: MyColors.primary,
                          fontWeight: FontWeight.bold)),
                  Container(height: 5),
                  Text(t.signintocontinue,
                      style: TextStyles.subhead(context).copyWith()),
                ],
              ),
              Container(height: 25),
              Container(height: 5),
              Container(height: 50),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(t.emailaddress,
                    style: TextStyles.caption(context).copyWith()),
              ),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.blueGrey[400], width: 1),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.blueGrey[400], width: 2),
                  ),
                ),
              ),
              Container(height: 25),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(t.password,
                    style: TextStyles.caption(context).copyWith()),
              ),
              TextField(
                controller: passwordController,
                keyboardType: TextInputType.text,
                obscureText: true,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.blueGrey[400], width: 1),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.blueGrey[400], width: 2),
                  ),
                ),
              ),
              Container(height: 8),
              Container(
                width: double.infinity,
                child: FlatButton(
                  child: Text(
                    t.forgotpassword,
                    style: TextStyle(color: MyColors.primary, fontSize: 15),
                  ),
                  color: Colors.transparent,
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(ForgotPasswordScreen.routeName);
                  },
                ),
              ),
              Container(height: 20),
              Container(
                width: double.infinity,
                height: 40,
                child: FlatButton(
                  child: Text(
                    t.signin,
                    style: TextStyle(color: Colors.white),
                  ),
                  color: MyColors.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(20)),
                  onPressed: () {
                    verifyFormAndSubmit();
                  },
                ),
              ),
              Container(
                width: double.infinity,
                child: FlatButton(
                  child: Text(
                    t.signinforanaccount,
                    style: TextStyle(color: MyColors.primary),
                  ),
                  color: Colors.transparent,
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(RegisterScreen.routeName);
                  },
                ),
              ),
              Container(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
