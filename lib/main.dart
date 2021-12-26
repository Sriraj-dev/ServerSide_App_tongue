import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:tongue_services/Orders.dart';
import 'package:tongue_services/Screens/NetworkError.dart';
import 'package:tongue_services/Screens/homePage.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:connectivity/connectivity.dart';
import 'package:tongue_services/Services/APIservices.dart';
import 'package:tongue_services/constants.dart';
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LaunchScreen(),
  ));
}

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({Key? key}) : super(key: key);

  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {

  late Future<int> route ;
  Future<int> loadApp()async{
    //TODO: Check network Connection
    final network = await checkNetwork();
    if(network){
      print('Network connection working');
      await getBranches();
      await setCurrentOrders();
      setPastOrders();
      setRejectedOrders();
      items = await ApiServices().getItems();
      initialiseCategoryItems();
      initialiseMenu();
      return 1;
    }else{
      return 0;
    }
  }

  @override
  void initState() {
    super.initState();

    route = loadApp();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: route,
      builder:(context,snapshot){
        if(snapshot.hasError){
          return Scaffold(
            body: Center(
              child: Text('${snapshot.error}',style: TextStyle(fontSize: 20),),
            ),
          );
        }
        else if(snapshot.hasData){
          switch(snapshot.data){
            case 0:
              return NetworkError();
            case 1:
              return HomePage();
          }
        }
        else{
          return splashScreen();
        }
        return Container();
      }
    );
  }

  Scaffold splashScreen() {
    return Scaffold(
      backgroundColor: bgColor,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(),
                Lottie.asset('assets/restLoading.json'),
                FadingText('Loading ...',style: GoogleFonts.lato(
                  color: kTextColor,
                  fontSize: 18,
                ),)
              ],
            ),
          ),
        );
  }

  Future<bool> checkNetwork()async {
    final result = await Connectivity().checkConnectivity();
    if(result == ConnectivityResult.none)
      return false;
    else return true;
  }
}

