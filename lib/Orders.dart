

import 'dart:async';

import 'package:tongue_services/Services/APIservices.dart';

List currentOrders = [];
// list of maps = eachMap = {_id,customerName,customerAddress,customerPhone,latitude,longitude,amountPaid,orderItems=[],accepted}
List pastOrders = [];
// list of maps = eachMap = {orderId,customerName,customerAddress,customerPhone,latitude,longitude,amountPaid,orderItems=[]}
//both maps contain  = {createdAt: , updatedAt: }
bool incomingOrder = false;
List rejectedOrders = [];
String branchId = '';
List deliveryPartners = [];
List myBranches = [];
late var selectedBranch;
StreamController<bool> checkIncoming = StreamController<bool>.broadcast();

class BranchDetails{
  String branchCity,branchArea,branchLatitude,branchLongitude,branchAddress;
  BranchDetails({
    required this.branchArea,
    required this.branchCity,
    required this.branchLatitude,
    required this.branchLongitude,
    required this.branchAddress});
}

BranchDetails myBranch = new BranchDetails(branchArea: '',
    branchCity: '',
    branchLatitude: '',
    branchLongitude: '',
    branchAddress: '');

getBranches()async{
  myBranches = await ApiServices().getBranches();
  selectedBranch = myBranches[0];
  branchId = myBranches[0]['_id'];
  setBranchDetails(selectedBranch);
}

setBranchDetails(var branchDetails)async{
  myBranch.branchArea = branchDetails['branchArea'];
  myBranch.branchCity = branchDetails['branchCity'];
  myBranch.branchAddress = branchDetails['branchAddress'];
  myBranch.branchLatitude = branchDetails['latitude'];
  myBranch.branchLongitude = branchDetails['longitude'];

  deliveryPartners = await ApiServices().getDeliveryPartners(branchId);
}

getDeliveryPartners()async{
  deliveryPartners = await ApiServices().getDeliveryPartners(branchId);
}


setCurrentOrders()async{
  print('setting currentOrders');
  currentOrders = await ApiServices().getCurrentOrders(branchId);
  bool temp = false;
  currentOrders.forEach((element) {
    if(!(element['requestedTo']=="" || element['requestedTo']==null)){

    }else{
      temp = true;
    }
  });
  incomingOrder = temp;
  setPastOrders();
  getDeliveryPartners();
  checkIncoming.sink.add(true);
}

setPastOrders()async{
  pastOrders = await ApiServices().getPastOrders(branchId);
}

setRejectedOrders()async{
  rejectedOrders = await ApiServices().getRejectedOrders(branchId);
}

List categoryItems = [];
List<Map<String,dynamic>> menu = [];
List items = [];
initialiseCategoryItems(){
  categoryItems = [];
  items.forEach((e) {
    categoryItems.add(e['items']); // list of items. [biryaniitems , chineseitems ...]
  });
}

initialiseMenu(){
  menu = [];
  categoryItems.forEach((e) {
    e.forEach((item){
      menu.add({
        'id': item['id'],
        'item': item
      });
    });
  });
}

generateYourOrder(var orderItems) {
  String yourOrder = '';
  orderItems.forEach((map) {
    var req = menu.firstWhere((element) => element['id'] == map['id']);
    yourOrder +=
        map['count'].toString() + ' ' + req['item']['itemName'] + ',';
  });
  if(yourOrder.isNotEmpty)
  yourOrder = yourOrder.substring(0, yourOrder.length - 1);
  yourOrder += '.';
  return yourOrder;
}


