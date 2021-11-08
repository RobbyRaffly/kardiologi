import 'dart:convert';
import 'dart:io';

///import 'package:flutter/gestures.dart';
import 'package:haloecg/dashboardkeAddECG.dart';
import 'package:haloecg/Profile.dart';
import 'package:haloecg/dashboardkeRiwayat.dart';
import 'package:haloecg/daftar_dokter.dart';
import 'package:haloecg/global_var.dart';
import 'package:haloecg/daftar_chat.dart';
import 'package:haloecg/Settings.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart'; // For using PlatformException

// For performing some operations asynchronously
import 'dart:async';
import 'dart:typed_data';
//import 'package:fluttertoast/fluttertoast.dart';
//import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
// import 'package:haloecg/ChartECG.dart';
import 'package:haloecg/utils/const.dart';
import 'package:haloecg/utils/text_style.dart';
import 'package:haloecg/widget/Menu_Card.dart';
import 'package:haloecg/widget/opaque_imageHome.dart';
import 'package:haloecg/widget/my_info.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:haloecg/widget/loading.dart';

class HomePasien extends StatefulWidget {
  @override
  _HomePasienPage createState() => _HomePasienPage();
}

class _HomePasienPage extends State<HomePasien> {
  Loading _load;
  pascalogin() async {
    var url = link + "pascalogin.php";
    //_load.show();
    var response = await http.post(url, body: {"id_user": id_user});
    final data = jsonDecode(response.body);
    print(data);
    String value = data['value'];
    String pesan = data['message'];
    String roleBaru = data['role'].toString();
    String id;
    role == "0"
        ? id = data['id_pasien'].toString()
        : id = data['id_dokter'].toString();
    String usernameBaru = data['username'].toString();
    String nameBaru = data['name'].toString();
    //_load.hide();
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
      print("id user = " + id_user);
      print(pesan);
    } else {
      print(pesan);
      Fluttertoast.showToast(msg: "login gagal");
    }
  }

  @override
  void initState() {
    pascalogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: role == "0" ? Constants.darkOrange : Constants.darkGreen,
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                flex: 4,
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
                                "Homepage" + " " + name.toString(),
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
              Expanded(
                  flex: 10,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                    child: Container(
                      padding: const EdgeInsets.only(top: 50),
                      color: role == "0"
                          ? Constants.lightYellow
                          : Constants.lightGreen,
                      child: role == "0"
                          ? Table(
                              children: [
                                TableRow(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DaftarDokter(),
                                          ),
                                        );
                                      },
                                      child: MenuCard(
                                          firstText: "",
                                          secondText: "Doctor",
                                          icon: Image.asset(
                                            "assets/icon/team.png",
                                            width: 50,
                                            height: 50,
                                          )),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => Profile(),
                                          ),
                                        );
                                      },
                                      child: MenuCard(
                                        firstText: "",
                                        secondText: "Profile",
                                        icon: Image.asset(
                                          "assets/icon/user.png",
                                          width: 50,
                                          height: 50,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                dashRiwayatECG(),
                                          ),
                                        );
                                      },
                                      child: MenuCard(
                                        firstText: "",
                                        secondText: "Riwayat",
                                        icon: Image.asset(
                                          "assets/icon/List.png",
                                          width: 50,
                                          height: 50,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => DaftarChat(),
                                          ),
                                        );
                                      },
                                      child: MenuCard(
                                        firstText: "",
                                        secondText: "Chat",
                                        icon: Image.asset(
                                          "assets/icon/chat.png",
                                          width: 50,
                                          height: 50,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => dashADDECG(),
                                          ),
                                        );
                                      },
                                      child: MenuCard(
                                        firstText: "",
                                        secondText: "Rekam ECG sinyal",
                                        icon: Image.asset(
                                          "assets/icon/pulse2.png",
                                          width: 50,
                                          height: 50,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      child: MenuCard(
                                          firstText: "",
                                          secondText: "Settings",
                                          icon: Image.asset(
                                            "assets/icon/settings.png",
                                            width: 50,
                                            height: 50,
                                          )),
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => Settings(),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : Table(
                              children: [
                                TableRow(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => Profile(),
                                          ),
                                        );
                                      },
                                      child: MenuCard(
                                        firstText: "",
                                        secondText: "Profile",
                                        icon: Image.asset(
                                          "assets/icon/user.png",
                                          width: 50,
                                          height: 50,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => DaftarChat(),
                                          ),
                                        );
                                      },
                                      child: MenuCard(
                                        firstText: "",
                                        secondText: "Riwayat Chat",
                                        icon: Image.asset(
                                          "assets/icon/chat.png",
                                          width: 50,
                                          height: 50,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                dashRiwayatECG(),
                                          ),
                                        );
                                      },
                                      child: MenuCard(
                                        firstText: "",
                                        secondText:
                                            "Riwayat ECG pasien & beri diagnosa",
                                        icon: Image.asset(
                                          "assets/icon/List.png",
                                          width: 50,
                                          height: 50,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      child: MenuCard(
                                          firstText: "",
                                          secondText: "Settings",
                                          icon: Image.asset(
                                            "assets/icon/settings.png",
                                            width: 50,
                                            height: 50,
                                          )),
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => Settings(),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                    ),
                  )),
            ],
          )
        ],
      ),
    );
  }
}
