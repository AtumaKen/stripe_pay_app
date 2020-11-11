import 'package:flutter/cupertino.dart';
import 'package:stripe_payment/stripe_payment.dart';

class CustomerModel {
  final String name;
  final String email;
  final String phone;
  final String Address;

  CustomerModel(
      {@required this.name, @required this.email, this.Address, this.phone});
}