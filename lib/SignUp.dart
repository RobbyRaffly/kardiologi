import 'package:haloecg/widget/FadeAnimation.dart';
import 'package:flutter/material.dart';
import 'package:haloecg/utils/const.dart';
import 'package:haloecg/utils/text_style.dart';
import 'package:haloecg/global_var.dart';
import 'package:haloecg/widget/opaque_imageHome.dart';
import 'package:haloecg/Login.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:haloecg/Isi_profil.dart';
import 'package:haloecg/Isi_profil_Dokter.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

final new_username = TextEditingController();
final new_email = TextEditingController();
final new_password = TextEditingController();
final new_confirm_pass = TextEditingController();

class _SignUpState extends State<SignUp> {
  bool _secureText = true;
  final _key = new GlobalKey<FormState>();
  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      print("lengkapi profil anda");
      role == 0
          ? Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => IsiProfil(),
              ),
            )
          : Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => IsiProfil_Dokter(),
              ),
            );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Constants.lightYellow,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              // decoration: BoxDecoration(
              //     color: Constants.lightYellow,
              //     borderRadius: BorderRadius.only(
              //         bottomRight: Radius.circular(10),
              //         bottomLeft: Radius.circular(10))),
              height: 250,
              child: Stack(
                children: <Widget>[
                  Container(
                    //flex: 4,
                    child: Stack(
                      children: <Widget>[
                        OpaqueImageHome(
                          imageUrl: "assets/images/kardiologi.jpg",
                        ),
                        SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: role == 0
                                      ? Text(
                                          "Sign Up Patient",
                                          textAlign: TextAlign.left,
                                          style: headingTextStyle,
                                        )
                                      : Text(
                                          "Sign Up Doctor",
                                          textAlign: TextAlign.left,
                                          style: headingTextStyle,
                                        ),
                                ),
                                //MyInfo(),
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
            Container(
              height: 50,
              color: Colors.orangeAccent,
              // decoration: BoxDecoration(
              //     color: Colors.orangeAccent,
              //     borderRadius: BorderRadius.only(
              //         bottomRight: Radius.circular(10),
              //         bottomLeft: Radius.circular(10))),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  FadeAnimation(
                      1.7,
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(196, 135, 198, .3),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              )
                            ]),
                        child: Form(
                          key: _key,
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey[200]))),
                                child: TextFormField(
                                  validator: (new_username) {
                                    if (new_username.isEmpty) {
                                      return "masukkan username";
                                    } else {
                                      return null;
                                    }
                                  },
                                  controller: new_username,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Username",
                                      hintStyle: TextStyle(color: Colors.grey)),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: TextFormField(
                                  controller: new_email,
                                  validator: (new_email) {
                                    if (new_email.isEmpty) {
                                      return "masukkan email";
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Email",
                                      hintStyle: TextStyle(color: Colors.grey)),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: TextFormField(
                                    controller: new_password,
                                    validator: (new_password) {
                                      if (new_password.isEmpty) {
                                        return "masukkan password";
                                      } else {
                                        return null;
                                      }
                                    },
                                    obscureText: _secureText,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Password",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      suffixIcon: IconButton(
                                        onPressed: showHide,
                                        icon: Icon(_secureText
                                            ? Icons.visibility_off
                                            : Icons.visibility),
                                      ),
                                    )),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: TextFormField(
                                  controller: new_confirm_pass,
                                  validator: (new_confirm_pass) {
                                    if (new_confirm_pass.isEmpty) {
                                      return "masukkan konfirmasi password";
                                    } else {
                                      return null;
                                    }
                                  },
                                  obscureText: _secureText,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Konfirmasi Password",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    suffixIcon: IconButton(
                                      onPressed: showHide,
                                      icon: Icon(_secureText
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )),
                  SizedBox(
                    height: 40,
                  ),
                  // FadeAnimation(
                  //     1.7,
                  //     Center(
                  //         child: Text(
                  //       "Forgot Password?",
                  //       style:
                  //           TextStyle(color: Color.fromRGBO(196, 135, 198, 1)),
                  //     ))),
                  // SizedBox(
                  //   height: 30,
                  // ),
                  GestureDetector(
                    onTap: () {
                      check();
                    },
                    child: FadeAnimation(
                        1.9,
                        Container(
                          height: 50,
                          margin: EdgeInsets.symmetric(horizontal: 60),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.deepOrange
                              //Color.fromRGBO(49, 39, 79, 1),
                              ),
                          child: Center(
                            child: Text(
                              "Sign Up",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Login(),
                        ),
                      );
                    },
                    child: FadeAnimation(
                        2,
                        Center(
                            child: Text(
                          "Back",
                          style:
                              TextStyle(color: Color.fromRGBO(49, 39, 79, .6)),
                        ))),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
