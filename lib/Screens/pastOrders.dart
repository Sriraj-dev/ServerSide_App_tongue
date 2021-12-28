import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tongue_services/Orders.dart';
import 'package:tongue_services/Screens/orderDetails.dart';
import 'package:tongue_services/constants.dart';

class PastOrders extends StatefulWidget {
  const PastOrders({Key? key}) : super(key: key);

  @override
  _PastOrdersState createState() => _PastOrdersState();
}

class _PastOrdersState extends State<PastOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bgColor,
        title: Text(
          'Past Orders',
          style: GoogleFonts.lato(
            color: kTextColor,
            fontSize: 19,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          color: kTextColor,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          var reqOrder = pastOrders[index];
          print('sending new ReqOrder');
          return onGoingOrderContainer(reqOrder);
        },
        itemCount: pastOrders.length,
      ),
    );
  }
  onGoingOrderContainer(Map<String, dynamic> orderData) {
    var reqPartner;
    print(orderData['assignedTo']);
      reqPartner = deliveryPartners.firstWhere((element) {
        return orderData['assignedTo'] == element['_id'];
      });
    return  GestureDetector(
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
}
