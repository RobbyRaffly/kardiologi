import 'dart:convert';
import 'dart:io';
import 'package:haloecg/AddECGsignal.dart';
import 'package:haloecg/global_var.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
// import 'package:haloecg/ChartECG.dart';
import 'package:haloecg/utils/const.dart';
import 'package:haloecg/utils/text_style.dart';
import 'package:haloecg/widget/Profil_Card.dart';
import 'package:haloecg/widget/opaque_image.dart';
import 'package:haloecg/widget/my_info.dart';
import 'package:intl/intl.dart';

class Profile extends StatefulWidget {
  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Stack(
                  children: <Widget>[
                    OpaqueImage(
                      imageUrl: "assets/images/kardiologi.jpg",
                      //"assets/images/robby.jpg",
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.arrow_back),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  color: Colors.white,
                                  iconSize: 30,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Profil",
                                    textAlign: TextAlign.left,
                                    style: headingTextStyle,
                                  ),
                                ),
                              ],
                            ),
                            MyInfo(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                    color: role == "0"
                        ? Constants.lightYellow
                        : Constants.lightGreen,
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      padding: const EdgeInsets.all(8),
                      children: [
                        // Column(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   crossAxisAlignment: CrossAxisAlignment.end,
                        //   children: [
                        ProfilCard(
                          firstText: "Tanggal \n lahir",
                          secondText:
                              DateFormat('dd-MM-yyyy').format(tanggal_lahir),
                          icon: Icon(
                            Icons.calendar_today,
                            size: 30,
                          ),
                          widhh: 0.4,
                        ),
                        ProfilCard(
                          firstText: "Email",
                          secondText: eemail,
                          icon: Icon(
                            Icons.email,
                            size: 30,
                          ),
                          widhh: 0.4,
                        ),
                        ProfilCard(
                          firstText: "HP.",
                          secondText: phone,
                          icon: Icon(
                            Icons.phone,
                            size: 30,
                          ),
                          widhh: 0.4,
                        ),
                        ProfilCard(
                          firstText: "Alamat",
                          secondText: alamat,
                          icon: Icon(
                            Icons.home_outlined,
                            size: 30,
                          ),
                          widhh: 0.4,
                        )
                        //   ],
                        // )
                      ],
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
