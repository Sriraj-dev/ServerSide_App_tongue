import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiServices {
  final baseUrl = 'https://stark-beach-59658.herokuapp.com/';

  Future getCurrentOrders(String branchId) async {
    Map<String, dynamic> branchData = {'branchId': "61a9b1c56a629f43c19616c0"};
    var res = await http.post(Uri.parse(baseUrl + 'tongue/currentOrders'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(branchData));
    var result = json.decode(res.body);
    return result['currentOrders'];
  }

  Future getPastOrders(String branchId) async {
    Map<String, dynamic> branchData = {'branchId': "61a9b1c56a629f43c19616c0"};
    var res = await http.post(Uri.parse(baseUrl + 'tongue/pastOrders'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(branchData));

    var result = json.decode(res.body);
    return result['pastOrders'];
  }

  Future acceptCurrentOrder(String orderId, String branchId) async {
    Map<String, dynamic> data = {
      'orderId': orderId,
      'branchId': "61a9b1c56a629f43c19616c0"
    };
    var res = await http.patch(
        Uri.parse(baseUrl + 'tongue/currentOrders/acceptOrder'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data));

    var result = json.decode(res.body);

    return result['status'];
  }

  Future getBranches(String cityName) async {
    Map<String, dynamic> data = {"cityName": cityName.toLowerCase()};
    var res = await http.post(Uri.parse(baseUrl + 'tongue/branches'),
        headers: {"Content-Type": "application/json"}, body: json.encode(data));

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

  Future assignPartner(
      String branchId, String partnerId, String orderId) async {
    Map<String, dynamic> data = {
      "branchId": branchId,
      "partnerId": partnerId,
      "orderId": orderId
    };
    var res = await http.patch(
      Uri.parse(baseUrl + 'tongue/currentOrders/assignPartner'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(data)
    );
    var result = json.decode(res.body);
    return result['status'];
  }

  Future informPartner(String partnerId,String branchId,String orderId)async{
    Map<String, dynamic> data = {
      "branchId": branchId,
      "partnerId": partnerId,
      "orderId": orderId
    };
    var res = await http.patch(
        Uri.parse(baseUrl + 'tongue/deliveryPartners/assignOrder'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data)
    );
    var result = json.decode(res.body);
    return result['status'];
  }

  

}
