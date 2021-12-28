import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:tongue_services/Orders.dart';
import 'package:tongue_services/Services/APIservices.dart';
import 'package:tongue_services/constants.dart';


class PartnersDetails extends StatefulWidget {
  const PartnersDetails({Key? key}) : super(key: key);

  @override
  _PartnersDetailsState createState() => _PartnersDetailsState();
}

class _PartnersDetailsState extends State<PartnersDetails> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios_rounded),
          color: kPrimaryColor,
        ),
        title: Text('Delivery Partners',
          style: GoogleFonts.lato(
            fontSize: 17,
            color: kPrimaryColor
          ),
        ),
      ),
      backgroundColor: bgColor,
      body: ListView.builder(
        itemCount: deliveryPartners.length,
          itemBuilder:(context,index){
            return ListTile(
              leading: Icon(Icons.person_rounded),
              title: Text(deliveryPartners[index]['Name'],
                style: GoogleFonts.lato(
                  color: kPrimaryColor
                ),
              ),
              subtitle: Text((deliveryPartners[index]['cashReceived']??0).toStringAsFixed(1),
                style: GoogleFonts.lato(),
              ),
              trailing: ElevatedButton(
                onPressed: (isLoading)?(){}:()async{
                  setState(() {
                    isLoading = true;
                  });
                  bool received = await ApiServices().receiveCashFromPartner(deliveryPartners[index]['branchId'], deliveryPartners[index]['_id']);
                  getDeliveryPartners();
                  setState(() {
                    isLoading = false;
                  });
                  if(received){
                    AwesomeDialog(
                        context: context,
                        dismissOnTouchOutside: false,
                        dismissOnBackKeyPress: false,
                        showCloseIcon: true,
                        title: 'Amount Received!',
                        desc: ((deliveryPartners[index]['cashReceived']??0).toStringAsFixed(1)),
                        dialogType: DialogType.SUCCES,
                        btnOkOnPress: (){}
                    )..show();
                  }else{
                    AwesomeDialog(
                        context: context,
                        dismissOnTouchOutside: false,
                        dismissOnBackKeyPress: false,
                        title: 'Please Try again!',
                        desc: 'Try again or restart your app',
                        dialogType: DialogType.ERROR,
                        btnOkOnPress: (){}
                    )..show();
                  }
                },
                child: (isLoading)?JumpingText('...'):Text('Receive'),
                style: ElevatedButton.styleFrom(
                  primary: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                ),
              ),
            );
          }
      ),
    );
  }
}
