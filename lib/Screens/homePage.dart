import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Use currentOrders list in Orders.dart for now temporarily.
  //Just design the UI for now ... Will make the backend after completing User side App.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: Center(
        child: Text('Show the list of orders here!!'),
      ),
    );
  }
}
