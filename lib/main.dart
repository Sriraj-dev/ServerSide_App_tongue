import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tongue_services/Orders.dart';
import 'package:tongue_services/Screens/NetworkError.dart';
import 'package:tongue_services/Screens/homePage.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:connectivity/connectivity.dart';
void main() {
  runApp(MaterialApp(
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
      await setCurrentOrders();
      await setPastOrders();
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
          return Scaffold(
            body: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Loading App',style: TextStyle(fontSize: 20),),
                  JumpingText('...',style: TextStyle(fontSize:20),)
                ],
              ),
            ),
          );
        }
        return Container();
      }
    );
  }

  Future<bool> checkNetwork()async {
    final result = await Connectivity().checkConnectivity();
    if(result == ConnectivityResult.none)
      return false;
    else return true;
  }
}

