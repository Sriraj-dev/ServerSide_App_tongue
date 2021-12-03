

import 'package:tongue_services/Services/APIservices.dart';

List currentOrders = [];
// list of maps = eachMap = {_id,customerName,customerAddress,customerPhone,latitude,longitude,amountPaid,orderItems=[],accepted}
List pastOrders = [];
// list of maps = eachMap = {orderId,customerName,customerAddress,customerPhone,latitude,longitude,amountPaid,orderItems=[]}
//both maps contain  = {createdAt: , updatedAt: }

setCurrentOrders()async{
  currentOrders = await ApiServices().getCurrentOrders();
}

setPastOrders()async{
  pastOrders = await ApiServices().getPastOrders();
}
