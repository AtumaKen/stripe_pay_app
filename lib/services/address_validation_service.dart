import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stripe_pay_app/models/coordinates_model.dart';

class AddressValidationService {
  static const _key = "KR97-WB33-PF92-RD11";

  Future<Map<String, dynamic>> validateAddress(String address) async {
    var response;
    try {
      final url =
          "https://api.addressy.com/Capture/Interactive/Find/v1.10/json3.ws?Key=$_key&Text=$address&"
          "IsMiddleware=false&Container=GB|RM|NGA|ENG|3DA-WR5&Countries=GB,US,CA&Limit=10&Language=en";
      response = await http.get(url);
    } catch (error) {
      //TODO: error handling later
      throw error;
    }
    final val = jsonDecode(response.body) as Map<String, dynamic>;
    print(val);
    return val;
  }

  Future<Map<String, dynamic>> validateAddressByCoordinates(
      CoordinatesModel coordinates) async {
    var response;
    try {
      final url =
          "https://api.addressy.com/Capture/Interactive/GeoLocation/v1.00/json3.ws?Key=$_key&"
          "Latitude=${coordinates.lat}&Longitude=${coordinates.long}&Items=10&Radius=50";
      response = await http.get(url);
    } catch (error) {
      //TODO: error handling later
      throw error;
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
