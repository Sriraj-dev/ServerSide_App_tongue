import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:tongue_services/Orders.dart';
import 'package:tongue_services/Screens/AssignPartner.dart';
import 'package:tongue_services/Screens/orderDetails.dart';
import 'package:tongue_services/Screens/pastOrders.dart';
import 'package:tongue_services/Screens/settings.dart';
import 'package:tongue_services/Services/APIservices.dart';
import 'package:tongue_services/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;

  bool isLoading = false;

  List tabs = ['Incoming orders', 'Ongoing orders', 'rejectedOrders'];

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          centerTitle: true,
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: [
              StreamBuilder(
                  stream: checkIncoming.stream,
                  builder: (context, snapshot) {
                    return Tab(
                      child: (incomingOrder)
                          ? HeartbeatProgressIndicator(
                              child: Text(
                                'Incoming orders',
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                ),
                              ),
                              startScale: 0.8,
                              endScale: 1.2,
                            )
                          : Text(
                              'Incoming orders',
                              style: GoogleFonts.lato(
                                fontSize: 17,
                              ),
                            ),
                    );
                  }),
              Tab(
                child: Text(
                  'Ongoing orders',
                  style: GoogleFonts.lato(
                    fontSize: 16,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Rejected orders',
                  style: GoogleFonts.lato(
                    fontSize: 16,
                  ),
                ),
              )
            ],
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropdownButton(
                dropdownColor: kPrimaryColor,
                focusColor: Colors.white,
                items: myBranches
                    .map((e) => DropdownMenuItem(
                          child: Text(
                            e['branchArea'],
                            style: GoogleFonts.lato(color: Colors.white),
                          ),
                          value: e,
                        ))
                    .toList(),
                value: selectedBranch,
                onChanged: (newValue) async {
                  selectedBranch = newValue;
                  if (branchId == selectedBranch['_id']) {
                  } else {
                    branchId = selectedBranch['_id'];
                    setState(() {
                      isLoading = true;
                    });
                    await setCurrentOrders();
                    await setRejectedOrders();
                    setPastOrders();
                    setState(() {
                      isLoading = false;
                    });
                  }
                },
              ),
              Center(
                child: Text(
                  'Tongue',
                  style: GoogleFonts.lato(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 19),
                ),
              ),
              IconButton(
                  onPressed: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context)=>Settings())
                    );
                  },
                  icon: Icon(Icons.settings))
            ],
          ),
        ),
        backgroundColor: bgColor,
        body: (isLoading)
            ? loadingscreen()
            : StreamBuilder(
                stream: getNewOrders(),
                builder: (context, snapshot) {
                  print('Im Running again');
                  return TabBarView(
                    controller: _tabController,
                    children: tabs.map((e) {
                      return (isLoading)
                          ? loadingScreen()
                          : (e == 'Incoming orders' || e == 'Ongoing orders')
                              ? ListView.builder(
                                  itemBuilder: (context, index) {
                                    var reqOrder = currentOrders[index];
                                    print('sending new ReqOrder');
                                    return (e == 'Incoming orders')
                                        ? incomingOrderContainer(reqOrder)
                                        : onGoingOrderContainer(reqOrder);
                                  },
                                  itemCount: currentOrders.length,
                                )
                              : ListView.builder(
                                  itemBuilder: (context, index) {
                                    return rejectedOrderContainer(
                                        rejectedOrders[index]);
                                  },
                                  itemCount: rejectedOrders.length,
                                );
                    }).toList(),
                  );
                }),
      ),
    );
  }

  Center loadingscreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(),
          Lottie.asset('assets/restLoading.json'),
          FadingText(
            'Loading ...',
            style: GoogleFonts.lato(
              color: kTextColor,
              fontSize: 18,
            ),
          )
        ],
      ),
    );
  }

  Center loadingScreen() {
    return loadingscreen();
  }

  Future<void> onAcceptingOrder(Map<String, dynamic> orderData) async {
    AwesomeDialog(
      context: context,
      title: 'Do you want to Accept the Order?',
      dialogType: DialogType.QUESTION,
      btnOkText: 'Yes',
      dismissOnBackKeyPress: false,
      dismissOnTouchOutside: false,
      btnOkOnPress: () async {
        bool isAccepted = await ApiServices()
            .acceptCurrentOrder(orderData['_id'], orderData['branchId']);
        if (isAccepted) {
          await setCurrentOrders();
          setState(() {});
        } else {
          AwesomeDialog(
              context: context,
              dismissOnTouchOutside: false,
              dismissOnBackKeyPress: false,
              title: 'Failed to accept Order',
              desc: 'Please Try again',
              dialogType: DialogType.ERROR,
              btnOkOnPress: () {})
            ..show();
        }
      },
      btnCancelOnPress: () {},
    )..show();
  }

  Future<void> onRejectingOrder(Map<String, dynamic> orderData) async {
    AwesomeDialog(
        context: context,
        dismissOnBackKeyPress: false,
        dismissOnTouchOutside: false,
        btnOkOnPress: () async {
          Map<String, dynamic> data = {
            'branchId': orderData['branchId'],
            'orderId': orderData['_id']
          };
          bool isRejected = await ApiServices()
              .rejectCurrentOrder(orderData['_id'], orderData['branchId']);
          if (isRejected) {
            setCurrentOrders();
            setRejectedOrders();
            AwesomeDialog(
                context: context,
                dialogType: DialogType.SUCCES,
                title: 'Order Rejected.',
                btnOkOnPress: () {
                  checkIncoming.sink.add(false);
                },
                dismissOnTouchOutside: false,
                dismissOnBackKeyPress: false,
                showCloseIcon: false)
              ..show();
          } else {
            AwesomeDialog(
                context: context,
                dialogType: DialogType.ERROR,
                title: 'Failed to reject Order!',
                btnOkOnPress: () {},
                dismissOnTouchOutside: false,
                dismissOnBackKeyPress: false,
                showCloseIcon: false)
              ..show();
          }
        },
        btnCancelOnPress: () {},
        btnOkText: 'Yes',
        btnCancelText: 'No',
        title: 'Do you want to reject the Order?',
        dialogType: DialogType.QUESTION)
      ..show();
  }

  rejectedOrderContainer(Map<String, dynamic> orderData) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => OrderDetails(orderData, 2, false)));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: GestureDetector(
          child: Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Row(
                  children: [
                    Icon(Icons.home_rounded),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                              text: TextSpan(
                                  text: 'orderId :',
                                  style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: kTextColor,
                                      fontWeight: FontWeight.bold),
                                  children: [
                                TextSpan(
                                    text: orderData['orderId'],
                                    style: GoogleFonts.lato(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                        fontSize: 16))
                              ])),
                          SizedBox(
                            height: 8,
                          ),
                          RichText(
                              text: TextSpan(
                                  text: 'order :',
                                  style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: kTextColor,
                                      fontWeight: FontWeight.bold),
                                  children: [
                                TextSpan(
                                    text: generateYourOrder(
                                        orderData['orderItems']),
                                    style: GoogleFonts.lato(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                        fontSize: 16))
                              ])),
                          SizedBox(
                            height: 8,
                          ),
                          RichText(
                              text: TextSpan(
                                  text: 'Distance :',
                                  style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: kTextColor,
                                      fontWeight: FontWeight.bold),
                                  children: [
                                TextSpan(
                                    text: (Geolocator.distanceBetween(
                                                    double.parse(myBranch
                                                        .branchLatitude),
                                                    double.parse(myBranch
                                                        .branchLongitude),
                                                    double.parse(
                                                        orderData['latitude']),
                                                    double.parse(orderData[
                                                        'longitude'])) /
                                                1000)
                                            .toStringAsFixed(1) +
                                        ' Km',
                                    style: GoogleFonts.lato(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                        fontSize: 16))
                              ])),
                          SizedBox(
                            height: 8,
                          ),
                          RichText(
                              text: TextSpan(
                                  text: 'Delivery Address :',
                                  style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: kTextColor,
                                      fontWeight: FontWeight.bold),
                                  children: [
                                TextSpan(
                                    text: orderData['customerAddress'],
                                    style: GoogleFonts.lato(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                        fontSize: 16))
                              ])),
                          SizedBox(
                            height: 8,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  onGoingOrderContainer(Map<String, dynamic> orderData) {
    var reqPartner;
    if (!(orderData['requestedTo'] == "" || orderData['requestedTo'] == null)) {
      reqPartner = deliveryPartners.firstWhere((element) {
        return orderData['requestedTo'] == element['_id'];
      });
    }
    return ((orderData['requestedTo'] == "" ||
            orderData['requestedTo'] == null))
        ? Container()
        : GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      OrderDetails(orderData, 1, reqPartner)));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: GestureDetector(
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      child: Row(
                        children: [
                          Icon(Icons.home_rounded),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                    text: TextSpan(
                                        text: 'orderId :',
                                        style: GoogleFonts.lato(
                                            fontSize: 16,
                                            color: kTextColor,
                                            fontWeight: FontWeight.bold),
                                        children: [
                                      TextSpan(
                                          text: orderData['_id'],
                                          style: GoogleFonts.lato(
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black,
                                              fontSize: 16))
                                    ])),
                                SizedBox(
                                  height: 8,
                                ),
                                RichText(
                                    text: TextSpan(
                                        text: 'order :',
                                        style: GoogleFonts.lato(
                                            fontSize: 16,
                                            color: kTextColor,
                                            fontWeight: FontWeight.bold),
                                        children: [
                                      TextSpan(
                                          text: generateYourOrder(
                                              orderData['orderItems']),
                                          style: GoogleFonts.lato(
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black,
                                              fontSize: 16))
                                    ])),
                                SizedBox(
                                  height: 8,
                                ),
                                RichText(
                                    text: TextSpan(
                                        text: 'Distance :',
                                        style: GoogleFonts.lato(
                                            fontSize: 16,
                                            color: kTextColor,
                                            fontWeight: FontWeight.bold),
                                        children: [
                                      TextSpan(
                                          text: (Geolocator.distanceBetween(
                                                          double.parse(myBranch
                                                              .branchLatitude),
                                                          double.parse(myBranch
                                                              .branchLongitude),
                                                          double.parse(
                                                              orderData[
                                                                  'latitude']),
                                                          double.parse(orderData[
                                                              'longitude'])) /
                                                      1000)
                                                  .toStringAsFixed(1) +
                                              ' Km',
                                          style: GoogleFonts.lato(
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black,
                                              fontSize: 16))
                                    ])),
                                SizedBox(
                                  height: 8,
                                ),
                                RichText(
                                    text: TextSpan(
                                        text: 'Delivery Address :',
                                        style: GoogleFonts.lato(
                                            fontSize: 16,
                                            color: kTextColor,
                                            fontWeight: FontWeight.bold),
                                        children: [
                                      TextSpan(
                                          text: orderData['customerAddress'],
                                          style: GoogleFonts.lato(
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black,
                                              fontSize: 16))
                                    ])),
                                SizedBox(
                                  height: 8,
                                ),
                                RichText(
                                    text: TextSpan(
                                        text: (orderData['assigned'])
                                            ? 'Assigned To :'
                                            : 'Requested To :',
                                        style: GoogleFonts.lato(
                                            fontSize: 16,
                                            color: kTextColor,
                                            fontWeight: FontWeight.bold),
                                        children: [
                                      TextSpan(
                                          text: (orderData['assigned'])
                                              ? reqPartner['Name']
                                              : reqPartner['Name'],
                                          style: GoogleFonts.lato(
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black,
                                              fontSize: 16))
                                    ])),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  incomingOrderContainer(Map<String, dynamic> orderData) {
    return (!(orderData['requestedTo'] == "" ||
            orderData['requestedTo'] == null))
        ? Container()
        : GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => OrderDetails(orderData, 0, false)));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: GestureDetector(
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      child: Row(
                        children: [
                          Icon(Icons.home_rounded),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                    text: TextSpan(
                                        text: 'orderId :',
                                        style: GoogleFonts.lato(
                                            fontSize: 16,
                                            color: kTextColor,
                                            fontWeight: FontWeight.bold),
                                        children: [
                                      TextSpan(
                                          text: orderData['_id'],
                                          style: GoogleFonts.lato(
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black,
                                              fontSize: 16))
                                    ])),
                                SizedBox(
                                  height: 8,
                                ),
                                RichText(
                                    text: TextSpan(
                                        text: 'order :',
                                        style: GoogleFonts.lato(
                                            fontSize: 16,
                                            color: kTextColor,
                                            fontWeight: FontWeight.bold),
                                        children: [
                                      TextSpan(
                                          text: generateYourOrder(
                                              orderData['orderItems']),
                                          style: GoogleFonts.lato(
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black,
                                              fontSize: 16))
                                    ])),
                                SizedBox(
                                  height: 8,
                                ),
                                RichText(
                                    text: TextSpan(
                                        text: 'Distance :',
                                        style: GoogleFonts.lato(
                                            fontSize: 16,
                                            color: kTextColor,
                                            fontWeight: FontWeight.bold),
                                        children: [
                                      TextSpan(
                                          text: (Geolocator.distanceBetween(
                                                          double.parse(myBranch
                                                              .branchLatitude),
                                                          double.parse(myBranch
                                                              .branchLongitude),
                                                          double.parse(
                                                              orderData[
                                                                  'latitude']),
                                                          double.parse(orderData[
                                                              'longitude'])) /
                                                      1000)
                                                  .toStringAsFixed(1) +
                                              ' Km',
                                          style: GoogleFonts.lato(
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black,
                                              fontSize: 16))
                                    ])),
                                SizedBox(
                                  height: 8,
                                ),
                                RichText(
                                    text: TextSpan(
                                        text: 'Delivery Address :',
                                        style: GoogleFonts.lato(
                                            fontSize: 16,
                                            color: kTextColor,
                                            fontWeight: FontWeight.bold),
                                        children: [
                                      TextSpan(
                                          text: orderData['customerAddress'],
                                          style: GoogleFonts.lato(
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black,
                                              fontSize: 16))
                                    ])),
                                SizedBox(
                                  height: 8,
                                ),
                                (!orderData['accepted'])
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              await onAcceptingOrder(orderData);
                                            },
                                            child: Container(
                                              height: 40,
                                              width: 130,
                                              //color: kPrimaryColor,
                                              decoration: BoxDecoration(
                                                color: kPrimaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                              ),
                                              child: Center(
                                                  child: Text(
                                                'Accept Order',
                                                style: GoogleFonts.lato(
                                                    color: Colors.white),
                                              )),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              await onRejectingOrder(orderData);
                                            },
                                            child: Container(
                                              height: 40,
                                              width: 130,
                                              //color: kPrimaryColor,
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                              ),
                                              child: Center(
                                                  child: Text(
                                                'Reject Order',
                                                style: GoogleFonts.lato(
                                                    color: Colors.white),
                                              )),
                                            ),
                                          ),
                                        ],
                                      )
                                    : InkWell(
                                        onTap: () async {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DeliveryPartners(
                                                          orderData)));
                                        },
                                        child: Container(
                                          height: 50,
                                          width: 240,
                                          //color: kPrimaryColor,
                                          decoration: BoxDecoration(
                                            color: kPrimaryColor,
                                            borderRadius:
                                                BorderRadius.circular(27),
                                          ),
                                          child: Center(
                                              child: Text(
                                            'Assign a delivery Partner',
                                            style: GoogleFonts.lato(
                                                color: Colors.white),
                                          )),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  Stream getNewOrders() => Stream.periodic(Duration(seconds: 3))
      .asyncMap((event) => setCurrentOrders());
}
