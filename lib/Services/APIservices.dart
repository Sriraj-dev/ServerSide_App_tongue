import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiServices {
  final baseUrl = 'https://stark-beach-59658.herokuapp.com/';

  Future getItems()async{
    var res = await http.get(
        Uri.parse(baseUrl+'tongue/items')
    );
    Map<String,dynamic> response = json.decode(res.body);
    return response['itemList'];
  }

  Future getCurrentOrders(String branchId) async {
    Map<String, dynamic> branchData = {'branchId': branchId};
    print('getting from $branchData');
    var res = await http.post(Uri.parse(baseUrl + 'tongue/currentOrders'),
        headers: {
          "Content-Type": "application/json",
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Methods": "GET, POST"
        },
        body: json.encode(branchData));
    print(res.body);
    var result = json.decode(res.body);
    return result['currentOrders'];
  }

  Future getPastOrders(String branchId) async {
    Map<String, dynamic> branchData = {'branchId': branchId};
    var res = await http.post(Uri.parse(baseUrl + 'tongue/pastOrders'),
        headers: {
          "Content-Type": "application/json",
          "Access-Control_Allow_Origin": "*",
          "Access-Control-Allow-Methods": "GET, POST"
        },
        body: json.encode(branchData));

    var result = json.decode(res.body);
    return result['pastOrders'];
  }

  Future getRejectedOrders(String branchId)async{
    Map<String, dynamic> branchData = {'branchId': branchId};
    var res = await http.post(Uri.parse(baseUrl + 'tongue/rejectedOrders'),
        headers: {
          "Content-Type": "application/json",
          "Access-Control_Allow_Origin": "*",
          "Access-Control-Allow-Methods": "GET, POST"
        },
        body: json.encode(branchData));
    var result = json.decode(res.body);
    return result['rejectedOrders'];
  }

  Future acceptCurrentOrder(String orderId, String branchId) async {
    Map<String, dynamic> data = {
      'orderId': orderId,
      'branchId': branchId
    };
    var res = await http.patch(
        Uri.parse(baseUrl + 'tongue/currentOrders/acceptOrder'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data));

    var result = json.decode(res.body);

    return result['status'];
  }

  Future rejectCurrentOrder(String orderId,String branchId)async{
    Map<String, dynamic> data = {
      'orderId': orderId,
      'branchId': branchId
    };
    var res = await http.post(
        Uri.parse(baseUrl + 'tongue/currentOrders/rejectOrder'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data));
    var response = json.decode(res.body);
    return response['status'];
  }

  Future getBranches() async {
    var res = await http.get(Uri.parse(baseUrl + 'tongue/getAllBranches'),
        headers: {"Content-Type": "application/json"},);

    var result = json.decode(res.body);
    return result['branches'];
  }

  Future getDeliveryPartners(String branchId) async {
    Map<String, dynamic> data = {"branchId": branchId};
    var res = await http.post(Uri.parse(baseUrl + 'tongue/deliveryPartners'),
        headers: {"Content-Type": "application/json"}, body: json.encode(data));
    var result = json.decode(res.body);

    return result['deliveryPartners'];
  }

  requestDeliveryPartner(String branchId,String partnerId,String orderId)async{
    Map<String,dynamic> data = {
      "branchId":branchId,
      "partnerId":partnerId,
      "orderId":orderId
    };
    var res = await http.patch(
        Uri.parse(baseUrl+'tongue/currentOrders/requestPartner'),
        headers: {"Content-Type": "application/json"},
      body: json.encode(data)
    );

    var result = json.decode(res.body);
    return result['status'];
  }


  // Future assignPartner(
  //     String branchId, String partnerId, String orderId) async {
  //   Map<String, dynamic> data = {
  //     "branchId": branchId,
  //     "partnerId": partnerId,
  //     "orderId": orderId
  //   };
  //   var res = await http.patch(
  //     Uri.parse(baseUrl + 'tongue/currentOrders/assignPartner'),
  //     headers: {"Content-Type": "application/json"},
  //     body: json.encode(data)
  //   );
  //   var result = json.decode(res.body);
  //   return result['status'];
  // }
  // Future informPartner(String partnerId,String branchId,String orderId)async{
  //   Map<String, dynamic> data = {
  //     "branchId": branchId,
  //     "partnerId": partnerId,
  //     "orderId": orderId
  //   };
  //   var res = await http.patch(
  //       Uri.parse(baseUrl + 'tongue/deliveryPartners/assignOrder'),
  //       headers: {"Content-Type": "application/json"},
  //       body: json.encode(data)
  //   );
  //   var result = json.decode(res.body);
  //   return result['status'];
  // }
}
