import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:haloecg/global_var.dart';
import 'package:haloecg/AddECGsignal.dart';
import 'package:haloecg/RiwayatECG.dart';
import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'dart:async';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:haloecg/utils/const.dart';

class ChatScreen extends StatefulWidget {
  @override
  State createState() => new ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _textController = new TextEditingController();

  var tanggalsekarang = DateTime.now();
  ScrollController scroll = ScrollController(initialScrollOffset: 50);
  bool _isComposing = false;
  bool tampilkanProfil = false;
  List dataChat = [];
  String foto;
  String nama = ''; //biar text nya kagak error
  Timer _timer;
  bool visible = false;
  bool adaPesan = false;

  void ambilDataPasanganChat() async {
    var url = link + "penerimaChat.php";
    var response = await http.post(url, body: {
      "id_penerima": id_penerima.toString(),
    });
    // print(response.body);
    final profilpenerima = json.decode(response.body);

    setState(() {
      nama = profilpenerima['nama'];
      foto = profilpenerima['foto'];
    });
  }

  void ambilDataRiwayat() async {
    var url = link + "lihat_chat.php";
    var response = await http.post(url, body: {
      "id_penerima": id_penerima.toString(),
      "id_pengirim": id_user.toString()
    });

    setState(() {
      dataChat = json.decode(response.body);
    });
  }

  kirimChat() async {
    if (adaPesan == true) {
      TimeOfDay selectedTime = TimeOfDay.now();
      var waktu = selectedTime.format(context);
      var url = link + "kirimChat.php";
      var response = await http.post(url, body: {
        "id_pengirim": id_user.toString(),
        "id_penerima": id_penerima.toString(),
        "pesan": _textController.text,
        "waktu": waktu.toString(),
        "tanggal": tanggalsekarang.toString(),
      });
      _textController.clear();
      if (scroll.hasClients) {
        scroll.animateTo(0.0,
            duration: const Duration(milliseconds: 100), curve: Curves.easeOut);
      }
    } else {
      Fluttertoast.showToast(msg: "Masukkan pesan terlebih dahulu");
    }
  }

  Widget listChat(BuildContext context, int index) {
    if (dataChat[index]["id_pengirim"] == id_user) {
      return GestureDetector(
          child: Container(
        margin: const EdgeInsets.all(10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(43, 112, 157, 1),
                      border:
                          Border.all(color: Color.fromRGBO(43, 112, 157, 1)),
                      borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(30.0),
                          bottomLeft: const Radius.circular(30.0),
                          bottomRight: const Radius.circular(30.0))),
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text('${dataChat[index]["pesan"]}',
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
                        SizedBox(height: 5),
                        Text('${dataChat[index]["jam"]}',
                            style: TextStyle(
                                //fontWeight: FontWeight.bold,
                                fontSize: 10,
                                color: Color.fromRGBO(138, 205, 231, 1))),
                      ]))
            ]),
      )
          //),
          );
    } else {
      //print(dataChat[index]);
      return GestureDetector(
          child: Container(
        margin: const EdgeInsets.all(10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(link + foto),
                minRadius: 20,
                maxRadius: 20,
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white),
                      borderRadius: new BorderRadius.only(
                          topRight: const Radius.circular(30.0),
                          bottomLeft: const Radius.circular(30.0),
                          bottomRight: const Radius.circular(30.0))),
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('${dataChat[index]["pesan"]}',
                            style:
                                TextStyle(fontSize: 16, color: Colors.black)),
                        SizedBox(height: 5),
                        Text('${dataChat[index]["jam"]}',
                            style: TextStyle(
                                fontSize: 10,
                                color: Color.fromRGBO(43, 112, 157, 1))),
                      ])),
            ]),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    ambilDataPasanganChat();
    print(dataChat);
    _timer = Timer.periodic(new Duration(seconds: 1), (timer) {
      ambilDataRiwayat();
    });
    if (scroll.hasClients) {
      scroll.animateTo(scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100), curve: Curves.easeOut);
    }
    KeyboardVisibilityNotification().addNewListener(
      onChange: (visible) {
        print(visible);
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor:
            role == "0" ? Constants.darkOrange : Constants.darkGreen,
        title: new Text(nama),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        ),
        actions: role == "0"
            ? <Widget>[
                IconButton(
                    icon: Image.asset(
                      "assets/icon/pulse2.png",
                      width: 50,
                      height: 50,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AddECGsignal(),
                        ),
                      );
                    }),
                IconButton(
                    icon: Icon(
                      Icons.list,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => RiwayatECG(),
                        ),
                      );
                    })
              ]
            : <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.list,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => RiwayatECG(),
                        ),
                      );
                    })
              ],
      ),
      backgroundColor:
          role == "0" ? Constants.lightYellow : Constants.lightGreen,
      body: new Container(
        color: role == "0" ? Constants.lightYellow : Constants.lightGreen,
        child: new Column(
          children: <Widget>[
            new Flexible(
              child: new ListView.builder(
                controller: scroll,
                padding: new EdgeInsets.all(10.0),
                reverse: true,
                itemBuilder: (_, int index) => listChat(context, index),
                itemCount: dataChat.length,
              ),
            ),
            new Divider(
              height: 1.0,
              color: Colors.transparent,
            ),
            new Container(
              decoration: new BoxDecoration(color: Colors.white),
              child: tempatTulisPesan(),
            ),
          ],
        ),
        // decoration: Theme.of(context).platform == TargetPlatform.iOS
        //     ? new BoxDecoration(
        //         border: new Border(
        //           top: new BorderSide(color: Color.fromRGBO(43, 112, 157, 1)),
        //         ),
        //       )
        //: null
      ),
    );
  }

  @override
  Widget tempatTulisPesan() {
    return new IconTheme(
      data: new IconThemeData(color: Color.fromRGBO(43, 112, 157, 1)),
      child: new Container(
        height: 50,
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(35.0),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 3),
                blurRadius: 5,
                color: Color.fromRGBO(43, 112, 157, 1))
          ],
        ),
        child: new Row(
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            new Flexible(
              child: new TextField(
                controller: _textController,
                //onSubmitted: _handleSubmitted,
                onChanged: _handleChanged,
                decoration: InputDecoration(
                    hintText: 'Ketik pesan...',
                    hintStyle:
                        new TextStyle(color: Color.fromRGBO(43, 112, 157, 1)),
                    border: InputBorder.none),
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: Theme.of(context).platform == TargetPlatform.iOS
                  ? new RaisedButton(
                      child: new Text('Kirim'),
                      onPressed: _isComposing
                          ? () {
                              //_handleSubmitted(_textController.text);
                              kirimChat();
                            }
                          : null,
                    )
                  : new IconButton(
                      icon: new Icon(Icons.send),
                      onPressed: _isComposing
                          ? () {
                              //_handleSubmitted(_textController.text);
                              _textController.text.isEmpty
                                  ? adaPesan = false
                                  : adaPesan = true;
                              kirimChat();
                            }
                          : null,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleChanged(String text) {
    setState(() {
      _isComposing = text.length > 0;
    });
  }
}
