import 'package:haloecg/global_var.dart';
import 'package:haloecg/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:haloecg/ChartECG.dart';
import 'package:haloecg/RiwayatDiagnosa.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:haloecg/widget/loading.dart';

class dashRiwayatECG extends StatefulWidget {
  @override
  _dashRiwayatECGState createState() => _dashRiwayatECGState();
}

final bulan = TextEditingController();
final tahun = TextEditingController();

class _dashRiwayatECGState extends State<dashRiwayatECG> {
  @override
  void initState() {
    //ambilDatadashRiwayatECG();
    super.initState();
  }

  Loading _load;
  List datadashRiwayatECG = [];

  void ambilDatadashRiwayatECG() async {
    var response;
    if (role == "0") {
      var url = link + "RiwayatECG.php";
      response = await http.post(url, body: {
        "id_pasien": "${id_pasien}",
        "bulan": "${bulan.text}",
        "tahun": "${tahun.text}"
      });
    } else {
      var url = link + "RiwayatECGuntukDokter.php";
      response = await http.post(url, body: {
        "id_dokter": "${id_doctor}",
        "bulan": "${bulan.text}",
        "tahun": "${tahun.text}"
      });
    }

    print(response);

    setState(() {
      datadashRiwayatECG = json.decode(response.body);

      print(datadashRiwayatECG);
    });
  }

  Widget ListdashRiwayatECG(BuildContext context, int index) {
    //print(datadashRiwayatECG[index]);
    return GestureDetector(
      onTap: () {
        role == "0"
            ? id_doctor = '${datadashRiwayatECG[index]["id_dokter"]}'
            : id_pasien = '${datadashRiwayatECG[index]["id_pasien"]}';
        doctor_name = '${datadashRiwayatECG[index]["nama_lengkap"]}';
        tanggallihatgrafik = '${datadashRiwayatECG[index]["tanggal"]}';
        jamlihatgrafik = "${datadashRiwayatECG[index]["clock"]}";
        print("id_pasien = " +
            id_pasien.toString() +
            " id_dokter = ${id_doctor}");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ChartECGsignal()));
      },
      child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <
                Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(
                    '${link}${datadashRiwayatECG[index]["profilePicture"]}'),
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
                                        '${datadashRiwayatECG[index]["nama_lengkap"]}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color:
                                              Color.fromRGBO(43, 112, 157, 1),
                                        )),
                                    SizedBox(height: 10),
                                    Text(
                                        '${datadashRiwayatECG[index]["tanggal"]}' +
                                            " " +
                                            '${datadashRiwayatECG[index]["clock"]}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 14)),
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
                                    SizedBox(
                                      height: 17,
                                    ),
                                    Text(
                                        '${datadashRiwayatECG[index]["nama_lengkap"]}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Color.fromRGBO(
                                                43, 112, 157, 1))),
                                    SizedBox(height: 10),
                                    Text(
                                        '${datadashRiwayatECG[index]["tanggal"]}' +
                                            " " +
                                            '${datadashRiwayatECG[index]["clock"]}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 14)),
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
        centerTitle: true,
        title: Text("Riwayat ECG"),
        backgroundColor:
            role == "0" ? Constants.darkOrange : Constants.darkGreen,
      ),
      backgroundColor:
          role == "0" ? Constants.lightYellow : Constants.lightGreen,
      body: Container(
          child: Column(
        children: [
          new Container(
            height: 70,
            //margin: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 3),
                    blurRadius: 5,
                    color: Color.fromRGBO(43, 112, 157, 1))
              ],
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                Flexible(
                    child: TextFormField(
                  controller: bulan,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Input bulan terlebih dahulu';
                    } else if (value.length != 10) {
                      return 'Input bulan dengan benar';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "masukkan bulan mm",
                  ),
                  inputFormatters: [
                    MaskedInputFormatter('00',
                        anyCharMatcher: RegExp(
                            r'^(0[1-9]|1[012])[-/.](0[1-9]|[12][0-9]|3[01])[-/.](19|20)\\d\\d$'))
                  ],
                )),
                SizedBox(
                  width: 20,
                ),
                Flexible(
                    child: TextFormField(
                  controller: tahun,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Input tahun terlebih dahulu';
                    } else if (value.length != 10) {
                      return 'Input tahun dengan benar';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "masukkan tahun yyyy",
                  ),
                  inputFormatters: [
                    MaskedInputFormatter('0000',
                        anyCharMatcher: RegExp(
                            r'^(0[1-9]|1[012])[-/.](0[1-9]|[12][0-9]|3[01])[-/.](19|20)\\d\\d$'))
                  ],
                )),
                SizedBox(
                  width: 20,
                ),
                IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () => {ambilDatadashRiwayatECG()}),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
          new Divider(
            height: 1.0,
            color: Colors.transparent,
          ),
          SizedBox(
            height: 10,
          ),
          Flexible(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.all(10),
                shrinkWrap: true,
                itemCount:
                    datadashRiwayatECG == null ? 0 : datadashRiwayatECG.length,
                itemBuilder: (BuildContext context, int index) =>
                    ListdashRiwayatECG(context, index)),
          ),
        ],
      )),
    );
  }
}
