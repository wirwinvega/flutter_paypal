package com.wirwin.flutter_paypal;

import android.app.Activity;
import android.content.Intent;

import androidx.annotation.NonNull;

import com.paypal.android.sdk.payments.PayPalConfiguration;
import com.paypal.android.sdk.payments.PayPalPayment;
import com.paypal.android.sdk.payments.PayPalService;
import com.paypal.android.sdk.payments.PaymentActivity;
import com.paypal.android.sdk.payments.PaymentConfirmation;

import org.json.JSONObject;

import java.math.BigDecimal;
import java.util.HashMap;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlutterPaypalPlugin */
public class FlutterPaypalPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {
  
  static Activity activity;
  Activity context;
  static  MethodChannel.Result sendBack;
  private MethodChannel channel;
  String amountBack;

  public static final int PAYPAL_REQUEST_CODE = 7171;
  private static PayPalConfiguration payPalConfig;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_paypal");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if (call.method.equals("initialization")) {
      HashMap<String, Object> data = (HashMap<String, Object>) call.arguments;

      // We can use both ways to get Map data in java from dart
      // boolean isEnvironmentSandbox = call.argument("isEnvironmentSandbox");
      boolean isEnvironmentSandbox = (boolean) data.get("isEnvironmentSandbox");
      String payPalClientId = (String) data.get("payPalClientId");
      initializePayPal(payPalClientId, isEnvironmentSandbox);
      result.success("initialization success isSandbox: " + isEnvironmentSandbox + " , payPalClientIdd: " + payPalClientId);
    } else if (call.method.equals("processPayment")) {
      double amount = call.argument("amount");
      String currency = call.argument("currency");
      String description = call.argument("description");
      proccessPayment(amount, currency, description, result);
    } else {
      result.notImplemented();
    }
  }

  private void initializePayPal(String clientId, boolean environment) {
    String env = PayPalConfiguration.ENVIRONMENT_SANDBOX;
    if (environment == true) {
      env = PayPalConfiguration.ENVIRONMENT_PRODUCTION;
    }
    payPalConfig = new PayPalConfiguration()
            .environment(env)
            .clientId(clientId);
  }

  private void proccessPayment(double amount, String currency, String description, Result result) {
    this.amountBack = String.valueOf(amount);
    sendBack = result;

    PayPalPayment payPalPayment = new PayPalPayment(
            new BigDecimal(String.valueOf(amount)),
            currency,
            description,
            PayPalPayment.PAYMENT_INTENT_SALE
    );

    Intent intent = new Intent(context, PaymentActivity.class);
    intent.putExtra(PayPalService.EXTRA_PAYPAL_CONFIGURATION, payPalConfig);
    intent.putExtra(PaymentActivity.EXTRA_PAYMENT, payPalPayment);
    context.startActivityForResult(intent, PAYPAL_REQUEST_CODE);
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    activity = binding.getActivity();
    binding.addActivityResultListener(this);
    context = FlutterPaypalPlugin.activity;
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {

  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

  }

  @Override
  public void onDetachedFromActivity() {
    activity = null;
  }

  @Override
  public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
    if(requestCode == PAYPAL_REQUEST_CODE) {
      if (resultCode == activity.RESULT_OK) {
        PaymentConfirmation confirmation = data.getParcelableExtra(PaymentActivity.EXTRA_RESULT_CONFIRMATION);
        if (confirmation != null) {
          try {
            JSONObject paymentDetails = confirmation.toJSONObject();
            paymentDetails.put("paymentAmount", amountBack);
            sendBack.success(paymentDetails.toString());
          } catch (Exception e) {
            e.printStackTrace();
          }
        } else if (resultCode == PaymentActivity.RESULT_CANCELED) {
          Log.i("flutterpaypal", "Canceled by user");
        }
      } else if (resultCode == PaymentActivity.RESULT_EXTRAS_INVALID) {
        Log.i("flutterpaypal", "Invalid payment");
      }
    }
    return true;
  }


}
