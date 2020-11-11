import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stripe_pay_app/services/pay_service.dart';
import 'package:stripe_payment/stripe_payment.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {

  @override
  initState() {
    super.initState();

    StripePayment.setOptions(StripeOptions(
        publishableKey:
        "pk_test_51HbXY0In97M0GymUamkBnKCyOWVuT7ylEmsbLEXm4yEgVUor6mqP0mHvj5deW5kxbFqafowxPB9PtLYW1BN1xN1h00dcB0Koz8",
        merchantId: "Test",
        androidPayMode: 'test'));
  }

  TextEditingController _amountController = TextEditingController();
  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  Future<void> showLoadingDialog(BuildContext context, GlobalKey key) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  key: key,
                  backgroundColor: Colors.black54,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Please Wait....",
                          style:
                          TextStyle(color: Theme.of(context).primaryColor),
                        )
                      ]),
                    )
                  ]));
        });
  }
  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Info!"),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text("Okay"),
            onPressed: () => Navigator.of(ctx).pop(),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 100),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
              child: TextField(keyboardType: TextInputType.number,
                controller: _amountController,
                decoration: const InputDecoration(
                  hintText: "Enter Amount to pay (USD)",
                ),
              ),
            ),
            FlatButton(
              //create payment method
              //create payment intent
              //confirm payment
              onPressed: () async {
                showLoadingDialog(context, _keyLoader);
                var response = await PayService.pay(
                    amount: (int.parse(_amountController.text) *100).toString(),
                    currency: 'USD'
                ).then((value) {
                  Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
                  _showDialog(value.message);
                  print(value.message);
                });
              },
              child: Text("Pay With Card", style: TextStyle(fontSize: 20),),
            ),
          ],
        ),
      ),
    );
  }

}
