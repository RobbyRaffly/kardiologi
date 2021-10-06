import 'package:haloecg/global_var.dart';
import 'package:haloecg/chatting.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:haloecg/utils/const.dart';

import 'package:haloecg/utils/text_style.dart';
import 'package:haloecg/widget/Profil_Card.dart';
import 'package:haloecg/widget/opaque_image.dart';
import 'package:haloecg/widget/Info_dokter.dart';

class DaftarDokter extends StatefulWidget {
  @override
  _DaftarDokter createState() => _DaftarDokter();
}

class _DaftarDokter extends State<DaftarDokter> {
  @override
  void initState() {
    ambilDataDokter();
    super.initState();
  }

  List dataRiwayatChat = [];

  void ambilDataDokter() async {
    var response;

    var url = "${link}ambildataDokter.php";
    response = await http.post(url, body: {
      "tipe_user": "1",
    });

    setState(() {
      dataRiwayatChat = json.decode(response.body);
      print(dataRiwayatChat);
    });
  }

  Future<void> prof_dokter() {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, //user must tap a button!
        builder: (BuildContext context) {
          return Container(
            margin: EdgeInsets.fromLTRB(30, 50, 30, 50),
            color: Colors.white,
            child: profil_dokter(context),
          );
        });
  }

  Widget profil_dokter(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
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
                        padding: const EdgeInsets.all(0),
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
                            Info_dokter(),
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
                          secondText: DateFormat('dd-MM-yyyy')
                              .format(tanggal_lahir_dok),
                          icon: Icon(
                            Icons.calendar_today,
                            size: 30,
                          ),
                          widhh: 0.3,
                        ),

                        ProfilCard(
                          firstText: "Email",
                          secondText: eemail_dok,
                          icon: Icon(
                            Icons.email,
                            size: 30,
                          ),
                          widhh: 0.2,
                        ),
                        ProfilCard(
                          firstText: "HP.",
                          secondText: phone_dok,
                          icon: Icon(
                            Icons.phone,
                            size: 30,
                          ),
                          widhh: 0.3,
                        ),
                        ProfilCard(
                          firstText: "Alamat",
                          secondText: alamat_dok,
                          icon: Icon(
                            Icons.home_outlined,
                            size: 30,
                          ),
                          widhh: 0.2,
                        )
                        //   ],
                        // )
                      ],
                    )),
              ),
              new Divider(
                height: 10.0,
                color: Colors.transparent,
              ),
              new Container(
                decoration: new BoxDecoration(color: Colors.white),
                child: GestureDetector(
                    child: Icon(
                      Icons.chat,
                      color: Constants.darkOrange,
                      size: 30,
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ChatScreen(),
                      ));
                    }),
              ),
            ],
          ),
        ],
      ),
    ));
  }

  Widget listDaftarChat(BuildContext context, int index) {
    //print(dataRiwayatChat[index]);
    return GestureDetector(
      onTap: () {
        id_doctor = '${dataRiwayatChat[index]["id_user"]}';
        id_penerima = "${dataRiwayatChat[index]["id_user"]}";
        name_dok = '${dataRiwayatChat[index]["nama_lengkap"]}';
        foto_profil_dok = '${dataRiwayatChat[index]["profilePicture"]}';
        tanggal_lahir_dok =
            DateTime.parse('${dataRiwayatChat[index]["tanggal_lahir"]}');
        phone_dok = '${dataRiwayatChat[index]["no_telepon"]}';
        alamat_dok = '${dataRiwayatChat[index]["alamat"]}';
        eemail_dok = '${dataRiwayatChat[index]["email"]}';
        prof_dokter();
      },
      child: Card(
          child: Container(
        padding: const EdgeInsets.all(10),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          CircleAvatar(
            backgroundImage: NetworkImage(
                '${link}${dataRiwayatChat[index]["profilePicture"]}'),
            maxRadius: 25,
          ),
          Container(
              child: Flexible(
                  child: Container(
                      // constraints: BoxConstraints(
                      //   maxWidth: MediaQuery.of(context).size.width * 0.9,
                      //   minHeight: MediaQuery.of(context).size.width * 0.15,
                      //   maxHeight: MediaQuery.of(context).size.width * 0.15,
                      // ),
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('${dataRiwayatChat[index]["nama_lengkap"]}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color.fromRGBO(43, 112, 157, 1),
                                )),
                            SizedBox(height: 10),
                            // Text('${dataRiwayatChat[index]["hospital"]}',
                            //     maxLines: 1,
                            //     overflow: TextOverflow.ellipsis,
                            //     style: TextStyle(fontSize: 14)),
                          ]))))
        ]),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        ),
        backgroundColor:
            role == "0" ? Constants.darkOrange : Constants.darkGreen,
        centerTitle: true,
        title: Text("Daftar Dokter"),
      ),
      backgroundColor:
          role == "0" ? Constants.lightYellow : Constants.lightGreen,
      body: ListView.builder(
          padding: EdgeInsets.only(left: 0, right: 0),
          shrinkWrap: true,
          itemCount: dataRiwayatChat == null ? 0 : dataRiwayatChat.length,
          itemBuilder: (BuildContext context, int index) =>
              listDaftarChat(context, index)),
    );
  }
}
