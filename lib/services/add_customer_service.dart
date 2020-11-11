import 'dart:convert';

import 'package:http/http.dart' as http;

class AddCustomerService{

  //This is unsafe.
  // Secret key should be stored as environment variable on the server.
  static String _SecretKey = "sk_test_51HbXY0In97M0GymU2sa8iAP6NoRIcMnM4JKJPbxg2wfVq0EjV4APtnjlurIfqN4hfNLCeE9tsT5N752Y6YlLqWdS00gSWw72eX";


  static Future<void> validateAddress(String name, String email) async {
    final url =
        "https://api.stripe.com/v1/customers";
    final response = await http.post(url, body: jsonEncode({
      "name" : name,
      "email" : email
      // "description" : "customer1"
    }), headers: {
      "Authorization" : "Bearer $_SecretKey",
      'Content-Type': 'application/x-www-form-urlencoded'
    });
    print(jsonDecode(response.body));
  }
}