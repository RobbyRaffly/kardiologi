import 'package:haloecg/widget/radial.dart';
import 'package:haloecg/widget/rounded_image.dart';
import 'package:haloecg/utils/text_style.dart';
import 'package:haloecg/global_var.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Info_dokter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RadialProgress(
              width: 4,
              goalCompleted: 0.9,
              child: CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(link + foto_profil_dok))
              // RoundedImage(
              //   imagePath: NetworkImage(link+foto_profil),
              //   size: Size.fromWidth(200.0),
              // ),
              ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                name_dok,
                style: whiteNameTextStyle,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
