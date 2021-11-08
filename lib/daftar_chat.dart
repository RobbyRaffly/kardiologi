import 'package:haloecg/global_var.dart';
import 'package:haloecg/chatting.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:haloecg/utils/const.dart';

class DaftarChat extends StatefulWidget {
  @override
  _DaftarChat createState() => _DaftarChat();
}

class _DaftarChat extends State<DaftarChat> {
  @override
  void initState() {
    ambilDataRiwayatChat();
    super.initState();
  }

  List dataRiwayatChat = [];

  void ambilDataRiwayatChat() async {
    var response;
    if (role == '0' || role == null) {
      var url = "${link}chat_pasien.php";
      response = await http.post(url, body: {
        "id_user": "${id_user}",
      });
      print(response);
      print("ambil data");
    } else {
      var url = "${link}chat_dokter.php";
      response = await http.post(url, body: {
        "id_dokter": "${id_user}",
      });
    }

    setState(() {
      dataRiwayatChat = json.decode(response.body);
      print(dataRiwayatChat);
    });
  }

  Widget listDaftarChat(BuildContext context, int index) {
    //print(dataRiwayatChat[index]);
    return GestureDetector(
      onTap: () {
        id_penerima = "${dataRiwayatChat[index]["id_user"]}";
        role == "0"
            ? {id_pasien = id_user, id_doctor = id_penerima}
            : {id_pasien = id_penerima, id_doctor = id_user};
        print("id pasien = " +
            id_pasien.toString() +
            ", id dokter = " +
            id_doctor.toString());
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ChatScreen()));
      },
      child: Card(
          child: Container(
        padding: const EdgeInsets.all(10),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          CircleAvatar(
            backgroundImage: NetworkImage(
                //'https://storage.googleapis.com/m-are-team-bucket/folder_gambar/MRT1A_05-30-2021_10:03:57.png'),
                '${link}${dataRiwayatChat[index]["profilePicture"]}'),
            maxRadius: 25,
          ),
          Container(
              child: role == '0'
                  ? Flexible(
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
                                Text(
                                    '${dataRiwayatChat[index]["nama_lengkap"]}',
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
                              ])))
                  : Flexible(
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
                                Text(
                                    '${dataRiwayatChat[index]["nama_lengkap"]}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color:
                                            Color.fromRGBO(43, 112, 157, 1))),
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
        title: Text("Chat"),
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
