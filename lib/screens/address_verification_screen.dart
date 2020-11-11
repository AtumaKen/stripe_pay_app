import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:stripe_pay_app/models/coordinates_model.dart';
import 'package:stripe_pay_app/screens/payment_screen.dart';
import 'package:stripe_pay_app/services/address_validation_service.dart';
import 'package:stripe_payment/stripe_payment.dart';

class AccountVerificationScreen extends StatefulWidget {
  @override
  _AccountVerificationScreenState createState() =>
      _AccountVerificationScreenState();
}

class _AccountVerificationScreenState extends State<AccountVerificationScreen> {
  TextEditingController _addressController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();


  Future<CoordinatesModel> _getLocation() async {
    final locationData = await Location().getLocation();
    return CoordinatesModel(
        long: locationData.longitude.toString(),
        lat: locationData.latitude.toString());
  }

  bool _status = false;
  AddressValidationService _addressValidationService =
      AddressValidationService();
  final GlobalKey<State> _keyLoader = GlobalKey<State>();

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

  _checkAddress() {
    setState(() {
      _status = true;
    });
    _addressValidationService
        .validateAddress(_addressController.text)
        .then((value) {
          //checks if the address is a valid uk address.
      if(value["Items"].isEmpty){
        setState(() {
          _status = false;
        });
        _showDialog("Wrong Location");
        return;
      }
      //TODO: Put a check if the address is a valid uk address.
      setState(() {
        _status = false;
      });
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PaymentScreen()));
    });
  }

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

  _verifyAddressWithCoordiantes() async {
    showLoadingDialog(context, _keyLoader);
    final coords = await _getLocation();
    _addressValidationService
        .validateAddressByCoordinates(coords)
        .then((value) {
      if(value["Items"][0].containsKey("Error")){
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
        _showDialog("Wrong Location");
        return;
      }
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PaymentScreen()));
    });
  }


  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: EdgeInsets.only(bottom: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                    child: Text(
                      'Register',
                      style: TextStyle(
                          fontSize: 24.0,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                    child: Text(
                      'Name',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                    child: TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: "Enter Your Name",
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                    child: Text(
                      'Email',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                      padding:
                          EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                      child: TextFormField(
                        controller: _emailController,
                        decoration:
                            const InputDecoration(hintText: "Enter Email"),
                        // controller: editingController2,
                      )),
                  Padding(
                      padding:
                          EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                      child: Text(
                        'Mobile',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      )),
                  Padding(
                    padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Flexible(
                          child: TextFormField(
                            decoration: const InputDecoration(
                                hintText: "Enter Phone Number"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                      padding:
                          EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                'Address',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      )),
                  Padding(
                    padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Flexible(
                          child: TextFormField(
                            decoration: const InputDecoration(
                                hintText: "Enter Address Around The UK"),
                            controller: _addressController,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0, left: 18),
                    child: FlatButton.icon(
                        onPressed: _verifyAddressWithCoordiantes,
                        icon: Icon(
                          Icons.location_on,
                          color: Theme.of(context).primaryColor,
                        ),
                        label: Text(
                          "Or use live location",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        )),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _status == true
                            ? Padding(
                                padding: const EdgeInsets.only(right: 40),
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).primaryColor),
                                ),
                              )
                            : RaisedButton(
                                onPressed: _checkAddress,
                                child: Text(
                                  "Next",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 17),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30.0, vertical: 5),
                                color: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
