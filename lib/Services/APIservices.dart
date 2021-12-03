import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiServices{
  final baseUrl = 'https://stark-beach-59658.herokuapp.com/';

  Future getCurrentOrders(String branchId)async{
    Map<String,dynamic> branchData = {
      'branchId':"61a9b1c56a629f43c19616c0"
    };
    var res = await http.post(
        Uri.parse(baseUrl + 'tongue/currentOrders'),
      headers: {
        "Content-Type": "application/json"
      },
        body: json.encode(branchData)
    );

    var result = json.decode(res.body);

    return result['currentOrders'];
  }

  Future getPastOrders(String branchId)async{
    Map<String,dynamic> branchData = {
      'branchId':"61a9b1c56a629f43c19616c0"
    };
    var res = await http.post(
        Uri.parse(baseUrl + 'tongue/pastOrders'),
        headers: {
          "Content-Type": "application/json"
        },
        body: json.encode(branchData)
    );

    var result = json.decode(res.body);
    return result['pastOrders'];
  }
  
  Future acceptCurrentOrder(String orderId,String branchId)async{
    Map<String,dynamic> data = {
      'orderId': orderId,
      'branchId':"61a9b1c56a629f43c19616c0"
    };
    var res = await http.patch(
        Uri.parse(baseUrl + 'tongue/currentOrders/update'),
      headers: {
        "Content-Type": "application/json"
      },
      body: json.encode(data)
    );

    var result  = json.decode(res.body);

    return result['status'];
  }

  Future getBranches(String cityName)async{
    Map<String,dynamic> data = {
      "cityName": cityName
    };
    var res = await http.post(
        Uri.parse(baseUrl+'tongue/branches'),
        headers: {
          "Content-Type": "application/json"
        },
        body: json.encode(data)
    );

    var result = json.decode(res.body);
    return result['branches'];
  }
}