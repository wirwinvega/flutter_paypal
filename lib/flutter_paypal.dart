
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_paypal/models/paypal_response_model.dart';
import 'package:meta/meta.dart';
import 'package:flutter/services.dart';

class FlutterPaypal {
  static const MethodChannel _channel =  const MethodChannel('flutter_paypal');

  static Future<String> initialization({
    @required bool isEnvironmentSandbox,
    @required String payPalClientId
  }) async {
    try {
      final String initResponse = await _channel.invokeMethod('initialization', {
        'isEnvironmentSandbox': isEnvironmentSandbox,
        'payPalClientId': payPalClientId,
      });
      return initResponse;
    } catch (e) {
      throw ErrorDescription(e.toString());
    }
  }

  static Future<PayPalResponse> processPayment({
    @required double amount,
    @required String currency,
    @required String description,
  }) async {
    try {
      final String paypalResponse = await _channel.invokeMethod('processPayment', {
        'amount': amount,
        'currency': currency,
        'description': description
      });
      return PayPalResponse.fromJson(jsonDecode(paypalResponse));
    } catch (e) {
      throw ErrorDescription(e.toString());
    }
  }

}
