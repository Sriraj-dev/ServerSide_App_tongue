import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tongue_services/Orders.dart';
import 'package:tongue_services/Services/APIservices.dart';
import 'package:tongue_services/constants.dart';

class DeliveryPartners extends StatefulWidget {
  //const DeliveryPartners({Key? key}) : super(key: key);
  var order;

  DeliveryPartners(this.order);

  @override
  _DeliveryPartnersState createState() => _DeliveryPartnersState(order);
}

class _DeliveryPartnersState extends State<DeliveryPartners> with TickerProviderStateMixin{
  var order;

  _DeliveryPartnersState(this.order);

  List rejectedBy = [];
  bool showInactivePartners = false;
  late AnimationController _animationController;

  checkIfRejected() {
    deliveryPartners.forEach((element) {
      if (order['rejectedBy'].contains(element['_id'])) {
        rejectedBy.add(element);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    checkIfRejected();
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bgColor,
        title: Text(
          'Assign a Partner',
          style: GoogleFonts.lato(color: kTextColor, fontSize: 18),
        ),
        centerTitle: true,
        leading: IconButton(color: kPrimaryColor,
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: [
          (rejectedBy.length != 0)
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        'This order is rejected by:',
                        style: GoogleFonts.lato(
                            color: kTextLightColor,
                            fontSize: 17,
                            letterSpacing: 0.5),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            children:
                                rejectedBy.map((e) => partnerDetails(e,e['isActive'],false)).toList(),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'Active partners :',
              style: GoogleFonts.lato(
                  color: kTextLightColor, fontSize: 17, letterSpacing: 0.5),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children:
                    deliveryPartners.map((e) => partnerDetails(e,true,true)).toList(),
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Inactive partners :',
                  style: GoogleFonts.lato(
                      color: kTextLightColor, fontSize: 17, letterSpacing: 0.5),
                ),
              ),
              IconButton(
                  onPressed: () {
                    setState(() {
                      showInactivePartners = !showInactivePartners;
                      showInactivePartners
                          ? _animationController.forward()
                          : _animationController.reverse();
                    });
                  },
                  icon: AnimatedIcon(
                    icon: AnimatedIcons.menu_close,
                    progress: _animationController,
                  ))
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Visibility(
            visible: showInactivePartners,
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children:
                      deliveryPartners.map((e) => partnerDetails(e,false,false)).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

   Widget partnerDetails(reqPartner,active,assign) {
    return (reqPartner['isActive']==active)?ListTile(
      leading: Icon(Icons.person_rounded),
      title: Text(reqPartner['Name']),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (reqPartner['orderId'].length == 0)
              ? Container()
              : RichText(
                  text: TextSpan(
                      text: 'Assigned Orders :',
                      style: GoogleFonts.lato(
                          fontSize: 16,
                          color: kTextColor,
                          fontWeight: FontWeight.bold),
                      children: [
                      TextSpan(
                          text: '${reqPartner['orderId']}',
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                              fontSize: 16))
                    ])),
          SizedBox(
            height: 5,
          ),
          (reqPartner['requestedOrderId'].length == 0)
              ? Container()
              : RichText(
                  text: TextSpan(
                      text: 'Requested orders :',
                      style: GoogleFonts.lato(
                          fontSize: 16,
                          color: kTextColor,
                          fontWeight: FontWeight.bold),
                      children: [
                      TextSpan(
                          text: '${reqPartner['requestedOrderId']}',
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                              fontSize: 16))
                    ])),
          SizedBox(
            height: 5,
          ),
          Text(reqPartner['status']),
        ],
      ),
      trailing: (assign)?
      ElevatedButton(
        onPressed: ()async{
          bool requested = await ApiServices().requestDeliveryPartner(branchId, reqPartner['_id'], order['_id']);
          if(requested){
            setCurrentOrders();
            getDeliveryPartners();
            Navigator.of(context).pop();
          }else{
            AwesomeDialog(
                context: context,
                dismissOnTouchOutside: false,
                dismissOnBackKeyPress: false,
                title: 'Failed to request Partner',
                desc: 'Please Try again',
                dialogType: DialogType.ERROR,
                btnOkOnPress: (){}
            )..show();
          }
        },
        child: Text('Request'),
        style: ElevatedButton.styleFrom(
          primary: kPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
        ),
      ):Icon(Icons.disabled_by_default_rounded,color: Colors.white,
      ),
    ):Container();
  }
}
