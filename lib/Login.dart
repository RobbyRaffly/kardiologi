import 'dart:ffi';

import 'package:haloecg/widget/FadeAnimation.dart';
import 'package:haloecg/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:haloecg/utils/const.dart';
import 'package:haloecg/utils/text_style.dart';
import 'package:haloecg/widget/opaque_imageHome.dart';
import 'package:haloecg/SignUp.dart';
import 'package:haloecg/HomePasien.dart';
import 'package:haloecg/global_var.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

enum LoginStatus { offline, online }

class _LoginState extends State<Login> {
  Loading _load;
  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  @override
  void initState() {
    setState(() {
      role = "0";
    });
  }

  final email = TextEditingController();
  final pass = TextEditingController();
  final _key = new GlobalKey<FormState>();
  int _pilihanVal = 0;
  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      print("sedang login");
      login();
    }
  }

  login() async {
    _load.show();
    var url = link + "login.php";
    var response = await http
        .post(url, body: {"email": email.text, "password": pass.text});
    final data = jsonDecode(response.body);
    print(data);
    String value = data['value'];
    String pesan = data['message'];
    String roleBaru = data['role'].toString();
    String id = data['id_user'].toString();
    String usernameBaru = data['username'].toString();
    String nameBaru = data['name'].toString();
    _load.hide();
    if (value == "1") {
      //Navigator.pushReplacementNamed(context, '/root_page');
      id_user = id;
      role = roleBaru;
      username = usernameBaru;
      name = nameBaru;
      foto_profil = data['foto_profil'].toString();
      phone = data['phone'].toString();
      alamat = data['alamat'].toString();
      tanggal_lahir = DateTime.parse(data['tanggal_lahir']);
      eemail = data['email'].toString();

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => HomePasien(),
        ),
      );
      print(pesan);
    } else {
      print(pesan);
      Fluttertoast.showToast(msg: "login gagal");
    }
  }

  Future<void> pilihan_signup() {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, //user must tap a button!
        builder: (BuildContext context) {
          return Container(
            margin: EdgeInsets.fromLTRB(50, 250, 50, 250),
            color: Colors.white,
            child: pilihan(context),
          );
        });
  }

  Widget pilihan(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            backgroundColor: Constants.lightYellow,
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context, false),
              ),
              backgroundColor: Constants.darkOrange,
              title: const Text('Create Account',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                      color: Colors.white)),
              centerTitle: true,
            ),
            body: ListView(
              padding: EdgeInsets.only(left: 0, right: 0),
              shrinkWrap: true,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        role = 0;
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SignUp(),
                          ),
                        );
                      },
                      child: Card(
                          child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Image.asset(
                                "assets/icon/pasien.png",
                                width: 30,
                                height: 30,
                              ),
                              Container(
                                  child: Flexible(
                                      child: Container(
                                          padding:
                                              const EdgeInsets.only(left: 20.0),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text('Patient',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      color: Color.fromRGBO(
                                                          43, 112, 157, 1),
                                                    )),
                                                SizedBox(height: 10),
                                              ]))))
                            ]),
                      )),
                    ),
                    GestureDetector(
                      onTap: () {
                        role = 1;
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SignUp(),
                          ),
                        );
                      },
                      child: Card(
                          child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Image.asset(
                                "assets/icon/Dokter.png",
                                width: 30,
                                height: 30,
                              ),
                              Container(
                                  child: Flexible(
                                      child: Container(
                                          padding:
                                              const EdgeInsets.only(left: 20.0),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text('Doctor',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      color: Color.fromRGBO(
                                                          43, 112, 157, 1),
                                                    )),
                                                SizedBox(height: 10),
                                              ]))))
                            ]),
                      )),
                    ),
                  ],
                )
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    _load = Loading(context: context);
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Constants.lightYellow,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 300,
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
                                  child: Text(
                                    "Login",
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
              height: 100,
              color: Colors.orangeAccent,
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
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
                                      controller: email,
                                      validator: (email) {
                                        if (email.isEmpty) {
                                          return "masukkan Email";
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Email",
                                          hintStyle:
                                              TextStyle(color: Colors.grey)),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    child: TextFormField(
                                        controller: pass,
                                        validator: (pass) {
                                          if (pass.isEmpty) {
                                            return "masukkan password";
                                          } else {
                                            return null;
                                          }
                                        },
                                        obscureText: _secureText,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Password",
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          suffixIcon: IconButton(
                                            onPressed: showHide,
                                            icon: Icon(_secureText
                                                ? Icons.visibility_off
                                                : Icons.visibility),
                                          ),
                                        )),
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
                      //       style: TextStyle(
                      //           color: Color.fromRGBO(196, 135, 198, 1)),
                      //     ))),
                      // SizedBox(
                      //   height: 30,
                      // ),
                      GestureDetector(
                        onTap: () {
                          check();
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (context) => HomePasien(),
                          //   ),
                          // );
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
                                  "Login",
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
                          pilihan_signup();
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (context) => SignUp(),
                          //   ),
                          // );
                        },
                        child: FadeAnimation(
                            2,
                            Center(
                                child: Text(
                              "Create Account",
                              style: TextStyle(
                                  color: Color.fromRGBO(49, 39, 79, .6)),
                            ))),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
