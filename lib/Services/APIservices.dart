import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiServices{
  final baseUrl = 'https://stark-beach-59658.herokuapp.com/';

  Future getCurrentOrders()async{
    var res = await http.get(Uri.parse(baseUrl + 'tongue/currentOrders'));

    var result = json.decode(res.body);

    return result['currentOrders'];
  }

  Future getPastOrders()async{
    var res = await http.get(Uri.parse(baseUrl + 'tongue/pastOrders'));

    var result = json.decode(res.body);
    return result['pastOrders'];
  }
  
  Future acceptCurrentOrder(String orderId)async{
    Map<String,dynamic> data = {
      'orderId': orderId
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


}