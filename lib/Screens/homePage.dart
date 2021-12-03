import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:tongue_services/Orders.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{
  //Use currentOrders list in Orders.dart for now temporarily.
  //Just design the UI for now ... Will make the backend after completing User side App.
  late TabController _tabController;

  bool isLoading = false;
  @override
  void initState() {

    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                text: 'Current orders',
              ),
              Tab(
                text: 'Past orders',
              )
            ],
          ),
          title: Text('Your Orders'),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            (isLoading)?Center(
              child: FadingText('Loading...',
                style: TextStyle(fontSize: 20),),):ListView.builder(
                itemBuilder: (context,index){
                  return ListTile(
                    title: Text(currentOrders[index]['_id'].toString()),
                  );
                },
              itemCount: currentOrders.length,
            ),
            (isLoading)?Center(
              child: FadingText('Loading...',
                style: TextStyle(fontSize: 20),),):ListView.builder(
              itemBuilder: (context,index){
                return ListTile(
                  title: Text(pastOrders[index]['orderId'].toString()),
                );
              },
              itemCount: pastOrders.length,
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: ()async{
            setState(() {
              isLoading = true;
            });
            await setCurrentOrders();
            await setPastOrders();
            setState((){
              isLoading = false;
            });
          },
          child: Center(
            child: Icon(Icons.refresh_rounded),
          ),
        ),
      ),
    );
  }
}
