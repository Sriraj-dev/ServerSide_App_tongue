import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF476072);
const kPrimaryLightColor= Color(0x25476072);
const kSecondaryColor = Color(0xFFB5BFD0);
const kTextColor = Color(0xFF50505D);
const kTextLightColor = Color(0xFF6A727D);
const bgColor = Color(0xFFF2F2F2);


void showSnackBar(String isLogin, BuildContext context,Color color) { // isLogin == usernmae is incorrect or password is incorect;
  final snackBar  = SnackBar(
    content: Text(isLogin) ,
    backgroundColor: color,
    padding: EdgeInsets.only(left: 15,right: 15,bottom: 20),
    behavior: SnackBarBehavior.floating,
  );
  //Scaffold.of(context).showSnackBar(snackBar)
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}