import 'package:flutter/material.dart';
import 'package:haloecg/SignUp.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:haloecg/global_var.dart';
import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:haloecg/HomePasien.dart';
import 'package:haloecg/utils/const.dart';

class IsiProfil_Dokter extends StatefulWidget {
  @override
  _IsiProfil_Dokter createState() => _IsiProfil_Dokter();
}

class _IsiProfil_Dokter extends State<IsiProfil_Dokter> {
  DateTime selectedDate = DateTime.now();
  int _radioVal = 0;
  File _image, _image_sertif, _image_surat;
  bool adaFoto = false, adaSertif = false, adaSurat = false;
  final picker = ImagePicker();

  final _key = new GlobalKey<FormState>();
  final namaLengkap = TextEditingController();
  final phone = TextEditingController();
  final alamat = TextEditingController();
  final noIdentitas = TextEditingController();

  Future getImageCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      _image = File(pickedFile.path);
      adaFoto = true;
    });
  }

  Future<Null> _selectedDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: new DateTime(1950),
        lastDate: DateTime(selectedDate.year + 1));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future getImageGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
      adaFoto = true;
    });
  }

  Future getImageSertif() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image_sertif = File(pickedFile.path);
      adaSertif = true;
    });
  }

  Future getImageSurat() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image_surat = File(pickedFile.path);
      adaSurat = true;
    });
  }

  Widget tampilkanFoto() {
    if (adaFoto == false) {
      return CircleAvatar(
        backgroundImage: AssetImage("assets/icon/user.png"),
        minRadius: 120,
        maxRadius: 120,
      );
    } else {
      return CircleAvatar(
        backgroundImage: FileImage(_image),
        minRadius: 120,
        maxRadius: 120,
      );
    }
  }

  Widget tampilkanSertif() {
    if (adaSertif == false) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20.0), //or 15.0
        child: Container(
          height: 70.0,
          width: 150.0,
          color: Colors.green[900],
          child: Icon(Icons.image, color: Colors.white, size: 50.0),
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20.0), //or 15.0
        child: Container(
          height: 70.0,
          width: 150.0,
          color: Colors.green[900],
          child: Image.file(_image_sertif),
        ),
      );
    }
  }

  Widget tampilkanSurat() {
    if (adaSurat == false) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20.0), //or 15.0
        child: Container(
          height: 70.0,
          width: 150.0,
          color: Colors.green[900],
          child: Icon(Icons.image, color: Colors.white, size: 50.0),
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20.0), //or 15.0
        child: Container(
          height: 70.0,
          width: 150.0,
          color: Colors.green[900],
          child: Image.file(_image_surat),
        ),
      );
    }
  }

  kirimData() async {
    var base64img = base64Encode(_image.readAsBytesSync());
    var base64imgsertif = base64Encode(_image_sertif.readAsBytesSync());
    var base64imgsurat = base64Encode(_image_surat.readAsBytesSync());
    String tanggal = DateFormat('yyyy-mm-dd').format(selectedDate);
    var usernameBaru = new_username.text;
    var fileName = '${usernameBaru}_${tanggal}.jpg';
    var sertifname = 'sertif_${usernameBaru}_${tanggal}.jpg';
    var suratname = 'surat_${usernameBaru}_${tanggal}.jpg';
    var url = link + "signUPregistrasiDokter.php";
    var response = await http.post(url, body: {
      "userid": id_user,
      "image": base64img,
      "images_camera": fileName,
      "namalengkap": namaLengkap.text,
      "gender": _radioVal.toString(),
      "phone": phone.text,
      "dob": selectedDate.toString(),
      "alamat": alamat.text,
      "no_identitas": noIdentitas.text,
      "image_sertif": base64imgsertif,
      "images_sertif_name": sertifname,
      "image_surat": base64imgsurat,
      "images_surat_name": suratname,
    });
    print(response.body);
    final respon = jsonDecode(response.body);
    int value = int.parse(respon['value']);
    if (value == 1) {
      Fluttertoast.showToast(msg: "Data Berhasil Disimpan");
      usernameBaru = usernameBaru;
      role = "1";
      name = namaLengkap.text;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => HomePasien(),
        ),
      );
      //Navigator.pushReplacementNamed(context, "/root_page");
      print("bisa");
    } else if (value == 0) {
      Fluttertoast.showToast(msg: "Gagal Menyimpan Data");
      print("gagal");
    }
  }

  pralogin() async {
    //_load.show();
    var url = link + "pralogin.php";
    var response = await http.post(url,
        body: {"email": new_email.text, "password": new_password.text});
    final data = jsonDecode(response.body);
    print(data);
    String value = data['value'];

    //_load.hide();
    if (value == "1") {
      //Navigator.pushReplacementNamed(context, '/root_page');
      id_user = data['id_user'];

      print("id baru ditambahkan");
    } else {
      print("id failed");
      Fluttertoast.showToast(msg: "ambil id gagal");
    }
  }

  @override
  void initState() {
    pralogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Constants.lightGreen,
        appBar: AppBar(
          centerTitle: true,
          title: Text("Lengkapi Profil Dokter"),
          backgroundColor: Constants.darkGreen,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          ),
        ),
        body:
            ListView(padding: EdgeInsets.only(left: 30, right: 30), children: <
                Widget>[
          Column(children: <Widget>[
            SizedBox(height: 30),
            tampilkanFoto(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                    icon: Icon(Icons.camera_alt, color: Colors.green[900]),
                    onPressed: () {
                      getImageCamera();
                    },
                    iconSize: 40),
                IconButton(
                    icon: Icon(Icons.image, color: Colors.green[900]),
                    onPressed: () {
                      getImageGallery();
                    },
                    iconSize: 40),
              ],
            ),
            SizedBox(height: 10),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  key: _key,
                  autocorrect: false,
                  controller: namaLengkap,
                  decoration: InputDecoration(
                    hintText: 'Nama Lengkap',
                    hintStyle:
                        new TextStyle(color: Colors.green[900], fontSize: 16.0),
                    filled: true,
                    fillColor: Color.fromRGBO(233, 232, 232, 1),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.green[900]),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.green[900]),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Tanggal Lahir :",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.green[900]),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  DateFormat('dd-MM-yyyy').format(selectedDate),
                  //"${selectedDate.toLocal()}".split(' ')[0],
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.green[900],
                  ),
                ),
                GestureDetector(
                  onTap: () => _selectedDate(context),
                  child: Container(
                    height: 30,
                    // margin: EdgeInsets.only(left: 100),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.green[900]
                        //Color.fromRGBO(49, 39, 79, 1),
                        ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Center(
                        child: Text(
                          "Atur Tanggal",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),

                // RaisedButton(
                //   color: Colors.green[900],
                //   onPressed: () => _selectedDate(context),
                //   child: const Text('Atur Tanggal',
                //       style: TextStyle(fontSize: 15, color: Colors.white)),
                // ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              "Jenis Kelamin :",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.green[900]),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [0, 1]
                  .map((int index) => Radio<int>(
                        value: index,
                        activeColor: Colors.green[900],
                        groupValue: this._radioVal,
                        onChanged: (int value) {
                          setState(() => this._radioVal = value);
                        },
                      ))
                  .toList(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  "Pria",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.green[900]),
                ),
                Text(
                  "Wanita",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.green[900]),
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  autocorrect: false,
                  controller: phone,
                  decoration: InputDecoration(
                    hintText: 'No. Telepon',
                    hintStyle:
                        new TextStyle(color: Colors.green[900], fontSize: 16.0),
                    filled: true,
                    fillColor: Color.fromRGBO(233, 232, 232, 1),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.green[900]),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.green[900]),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  autocorrect: false,
                  controller: alamat,
                  decoration: InputDecoration(
                    hintText: 'Alamat',
                    hintStyle:
                        new TextStyle(color: Colors.green[900], fontSize: 16.0),
                    filled: true,
                    fillColor: Color.fromRGBO(233, 232, 232, 1),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.green[900]),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.green[900]),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  autocorrect: false,
                  controller: noIdentitas,
                  decoration: InputDecoration(
                    hintText: 'No. Identitas',
                    hintStyle:
                        new TextStyle(color: Colors.green[900], fontSize: 16.0),
                    filled: true,
                    fillColor: Color.fromRGBO(233, 232, 232, 1),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.green[900]),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.green[900]),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Upload sertifikat:",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.green[900]),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                tampilkanSertif(),
                IconButton(
                    icon: Icon(Icons.image_search_sharp,
                        color: Colors.green[900]),
                    onPressed: () {
                      getImageSertif();
                    },
                    iconSize: 40),
              ],
            ),
            SizedBox(height: 20),
            Text(
              "Upload surat izin praktek:",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.green[900]),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                tampilkanSurat(),
                IconButton(
                    icon: Icon(Icons.image_search_sharp,
                        color: Colors.green[900]),
                    onPressed: () {
                      getImageSurat();
                    },
                    iconSize: 40),
              ],
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                kirimData();
              },
              child: Container(
                height: 50,
                margin: EdgeInsets.symmetric(horizontal: 60),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.green[900]
                    //Color.fromRGBO(49, 39, 79, 1),
                    ),
                child: Center(
                  child: Text(
                    "Simpan",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
          ])
        ]));
  }
}
