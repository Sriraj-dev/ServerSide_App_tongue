import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:tongue_services/Orders.dart';
import 'package:tongue_services/Screens/partnersDetails.dart';
import 'package:tongue_services/Screens/pastOrders.dart';
import 'package:tongue_services/constants.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDeliveryPartners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        title:  Text(
          'Tongue',
          style: GoogleFonts.lato(
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 19),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          color: kPrimaryColor,
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: bgColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(),
          Lottie.asset('assets/settings1.json'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Divider(),
          ),
          ListTile(
            onTap: (){
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context)=>PartnersDetails())
              );
            },
            leading: Icon(Icons.delivery_dining_rounded),
            title: Text('Delivery partner details'),
          ),
          ListTile(
            onTap: (){
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context)=>PastOrders())
              );
            },
            leading: Icon(Icons.history_rounded),
            title: Text('Past Orders'),
          )
        ],
      ),
    );
  }
}
