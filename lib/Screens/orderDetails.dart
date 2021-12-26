import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tongue_services/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetails extends StatefulWidget {
  //const OrderDetails({Key? key}) : super(key: key);
  var orderData;
  int page;
  var partner;
  OrderDetails(this.orderData, this.page,this.partner);

  @override
  _OrderDetailsState createState() => _OrderDetailsState(orderData, page,partner);
}

class _OrderDetailsState extends State<OrderDetails> {
  var orderData;
  var partner;
  int page;

  _OrderDetailsState(this.orderData, this.page,this.partner);


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bgColor,
        title: Text(
          'Order Details',
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
      backgroundColor: bgColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 15,
            ),
            Text(
              '  Customer Details:',
              style: GoogleFonts.halant(
                  fontSize: 18,
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 8,
            ),
            Material(
              borderRadius: BorderRadius.circular(20),
              elevation: 5,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Row(
                    children: [
                      Icon(Icons.person_rounded),
                      SizedBox(
                        width: 10,
                      ),
                      Flexible(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                              text: TextSpan(
                                  text: '',
                                  style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: kTextColor,
                                      fontWeight: FontWeight.bold),
                                  children: [
                                TextSpan(
                                    text: orderData['customerName'],
                                    style: GoogleFonts.lato(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                        fontSize: 16))
                              ])),
                          SizedBox(
                            height: 8,
                          ),
                          Text(orderData['customerAddress'],
                              style: GoogleFonts.lato(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                  fontSize: 16)),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Text(orderData['customerPhone'],
                                  style: GoogleFonts.lato(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black,
                                      fontSize: 16)),
                              SizedBox(
                                width: 25,
                              ),
                              IconButton(
                                onPressed: () {
                                  launch(
                                      'tel://+91${orderData['customerPhone']}');
                                },
                                icon: Icon(Icons.call_rounded),
                                color: kPrimaryColor,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                        ],
                      ))
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            (page==1)?
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '  Partner Details:',
                  style: GoogleFonts.halant(
                      fontSize: 18,
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Material(
                  borderRadius: BorderRadius.circular(20),
                  elevation: 5,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      child: Row(
                        children: [
                          Icon(Icons.person_rounded),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                      text: TextSpan(
                                          text: '',
                                          style: GoogleFonts.lato(
                                              fontSize: 16,
                                              color: kTextColor,
                                              fontWeight: FontWeight.bold),
                                          children: [
                                            TextSpan(
                                                text: partner['Name'],
                                                style: GoogleFonts.lato(
                                                    fontWeight: FontWeight.normal,
                                                    color: Colors.black,
                                                    fontSize: 16))
                                          ])),
                                  SizedBox(
                                    height: 8,
                                  ),

                                  Row(
                                    children: [
                                      Text(partner['phone'],
                                          style: GoogleFonts.lato(
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black,
                                              fontSize: 16)),
                                      SizedBox(
                                        width: 25,
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          launch(
                                              'tel://+91${partner['phone']}');
                                        },
                                        icon: Icon(Icons.call_rounded),
                                        color: kPrimaryColor,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                ],
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15,)
              ],
            )
                :Container(),
            RichText(
                text: TextSpan(
                    text: 'orderId :',
                    style: GoogleFonts.lato(
                        fontSize: 16,
                        color: kTextColor,
                        fontWeight: FontWeight.bold),
                    children: [
                  TextSpan(
                      text: (page==2)?orderData['orderId']:orderData['_id'],
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
                    text: 'Status :',
                    style: GoogleFonts.lato(
                        fontSize: 16,
                        color: kTextColor,
                        fontWeight: FontWeight.bold),
                    children: [
                  TextSpan(
                      text: (orderData['accepted'])
                          ? (orderData['assigned'])
                              ? (orderData['outForDelivery'])
                                  ? (orderData['delivered'])
                                      ? 'Order Delivered!'
                                      : 'Out for delivery!'
                                  : 'Preparing food'
                              : (page==0)?'Delivery Partner is not yet assigned!':'Partner did\'nt accept the Order yet'
                          : (!orderData['rejected'])?'Order is not accepted yet!':'Order is Rejected',
                      style: GoogleFonts.lato(
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                          fontSize: 16))
                ])),
            SizedBox(
              height: 15,
            ),
            RichText(
                text: TextSpan(
                    text: 'Order Placed At :',
                    style: GoogleFonts.lato(
                        fontSize: 16,
                        color: kTextColor,
                        fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                          text: (DateTime.parse(orderData['createdAt'].toString()).toLocal()).toString(),
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                              fontSize: 16))
                    ])),
          ],
        ),
      ),
    );
  }
}
