import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:flutter_paypal/models/paypal_response_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  TextEditingController _amountCtrl = TextEditingController();
  TextEditingController _descriptionCtrl = TextEditingController();

  PayPalResponse _payPalResponse;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('PayPal SDK example app', style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold)),
                    SizedBox(height: 5.0),
                    Text('Complete all the information below', style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 10.0),
                    TextField(
                      controller: _amountCtrl,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: "Amount to pay"
                      ),
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      controller: _descriptionCtrl,
                      decoration: InputDecoration(
                          hintText: "Description"
                      ),
                    ),
                    SizedBox(height: 40.0),
                    Container(
                      height: 45.0,
                      width: double.infinity,
                      child: RaisedButton(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)
                        ),
                        onPressed: () async {
                          try {
                            final result = await FlutterPaypal.initialization(
                                isEnvironmentSandbox: false,
                                payPalClientId: "AcQ2d8mC0Vvp-glNYDMBTjoHawVjwnUZwVnOgNzLO5_SD1h8bRf2C98drl55ScYadAEf6LHTc8zeNwLo"
                            );
                            print(result);
                          } catch (e) {
                            print("Error initializing PAYPAL: ${e.toString()}");
                          }
                        },
                        child: Text("Initialze PayPal", style: TextStyle(fontWeight: FontWeight.bold),),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      height: 45.0,
                      width: double.infinity,
                      child: RaisedButton(
                        color: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)
                        ),
                        onPressed: () async {
                          try {
                            final result = await FlutterPaypal.processPayment(
                                amount: double.parse(_amountCtrl.text),
                                currency: "MXN",
                                description: _descriptionCtrl.text
                            );
                            setState(() {
                              _payPalResponse = result;
                            });
                          } catch (e) {
                            print("Error in transaction with PAYPAL: ${e.toString()}");
                          }
                        },
                        child: Text("Pay with PayPal", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                      ),
                    ),
                    SizedBox(height: 40.0),
                    (_payPalResponse != null) ?
                    _buildPayPalResponse() :
                    Container()
                  ]
                ),
              ]
            ),
          ),
        ),
      ),
    );
  }

  _buildPayPalResponse() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('RESPONSE', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
          SizedBox(height: 10.0),
          Text(_payPalResponse.paymentAmount),
          Text(_payPalResponse.response.state),
          Text(_payPalResponse.response.id),
          Text(_payPalResponse.response.intent),
          Text(_payPalResponse.response.createTime),
          Text(_payPalResponse.client.productName),
          Text(_payPalResponse.client.environment),
          Text(_payPalResponse.client.paypalSdkVersion),
          Text(_payPalResponse.client.platform),
        ],
      ),
    );
  }

}
