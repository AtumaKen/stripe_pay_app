
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:http/http.dart' as http;

class StripeTransactionResponse {
  String message;
  bool success;
  StripeTransactionResponse({this.message, this.success});
}

class PayService{

  //Secret key is to be stored as an environment variable on the server
  static String _apiBase = 'https://api.stripe.com/v1';
  static String _paymentApiUrl = '${PayService._apiBase}/payment_intents';
  static String _secret = 'sk_test_51HbXY0In97M0GymU2sa8iAP6NoRIcMnM4JKJPbxg2wfVq0EjV4APtnjlurIfqN4hfNLCeE9tsT5N752Y6YlLqWdS00gSWw72eX';


  static Future<StripeTransactionResponse> pay({String amount, String currency}) async {
    try {
      final paymentMethod = await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest()
      );
      final paymentIntent = await PayService.createPaymentIntent(
          amount,
          currency
      );
      print(jsonEncode(paymentIntent));
      final response = await StripePayment.confirmPaymentIntent(
          PaymentIntent(
              clientSecret: paymentIntent['client_secret'],
              paymentMethodId: paymentMethod.id
          )
      );
      if (response.status == 'succeeded') {
        return new StripeTransactionResponse(
            message: 'Transaction successful',
            success: true
        );
      } else {
        return new StripeTransactionResponse(
            message: 'Transaction failed',
            success: false
        );
      }
    } on PlatformException catch(err) {
      return PayService.getPlatformExceptionErrorResult(err);
    } catch (err) {
      return new StripeTransactionResponse(
          message: 'Transaction failed: ${err.toString()}',
          success: false
      );
    }
  }

  static getPlatformExceptionErrorResult(err) {
    String message = 'Something went wrong';
    if (err.code == 'cancelled') {
      message = 'Transaction cancelled';
    }

    return new StripeTransactionResponse(
        message: message,
        success: false
    );
  }

  static Future<Map<String, dynamic>> createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(
          PayService._paymentApiUrl,
          body: body,
          headers: {
            'Authorization': 'Bearer ${PayService._secret}',
            'Content-Type': 'application/x-www-form-urlencoded'
          }
      );
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
    return null;
  }
}