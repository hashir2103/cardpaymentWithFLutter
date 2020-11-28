import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:stripe_payment/stripe_payment.dart';

class StripeTransactionResponse {
  String message;
  bool success;
  StripeTransactionResponse({this.message, this.success});
}

class StripeService {
  static String apiBase = 'https://api.stripe.com/v1';
  static String publicKey =
      'pk_test_51HF4wvKWLNOK3rv1hlxaq8VMqu9fqfTmbwNkBxxEZHxznozlfoiicGxaMYiBCycIf3PrHYMBE5KYj25THoHEm65y00O6fCGDlq';
  static String secretKey =
      'sk_test_51HF4wvKWLNOK3rv1urq9RMf9Q77THiqb7jV0Ilr6ncFx7tERSl0x6zYG5FC9eGdTlFCwK0jHLHyEQSFjlmmZCE6300fGTXumiW';
  static String paymentApiUrl = '$apiBase/payment_intents';
  static Map<String, String> headers = {
    'Authorization': 'Bearer $secretKey',
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  static init() {
    StripePayment.setOptions(StripeOptions(
        publishableKey: publicKey, merchantId: "Test", androidPayMode: 'test'));
  }

  static Future<StripeTransactionResponse> payViaExistingCard(
      {String amount, String currency, CreditCard card}) async {
    try {
      //payment method for existing card
      var paymentMethod = await StripePayment.createPaymentMethod(
          PaymentMethodRequest(card: card));
      //to pay actually
      var paymentIntent =
          await StripeService.createPaymentIntent(amount, currency);
      //to confrim payment
      var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
          clientSecret: paymentIntent['client_secret'],
          paymentMethodId: paymentMethod.id));
      if (response.status == 'succeeded') {
        return StripeTransactionResponse(
            message: 'Transaction Successful', success: true);
      } else {
        return StripeTransactionResponse(
            message: 'Transaction Failed', success: false);
      }
    } on PlatformException catch (e) {
      return getPlatfromExceptionErrorResult(e);
    } catch (e) {
      return StripeTransactionResponse(
          message: 'Transaction Failed : ${e.toString()}', success: false);
    }
  }

  static Future<StripeTransactionResponse> payViaNewCard(
      {String amount, String currency}) async {
    try {
      //adding new card
      var paymentMethod = await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest());
      //to pay actually
      var paymentIntent =
          await StripeService.createPaymentIntent(amount, currency);
      //to confrim payment
      var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
          clientSecret: paymentIntent['client_secret'],
          paymentMethodId: paymentMethod.id));
      if (response.status == 'succeeded') {
        return StripeTransactionResponse(
            message: 'Transaction Successful', success: true);
      } else {
        return StripeTransactionResponse(
            message: 'Transaction Failed', success: false);
      }
    } on PlatformException catch (e) {
      return getPlatfromExceptionErrorResult(e);
    } catch (e) {
      return StripeTransactionResponse(
          message: 'Transaction Failed : ${e.toString()}', success: false);
    }
  }

  static getPlatfromExceptionErrorResult(e) {
    String message = 'Something went wrong';
    if (e.code == 'cancelled') {
      message = 'Transaction cancelled';
    }
    return StripeTransactionResponse(message: message, success: false);
  }

  static Future<Map<String, dynamic>> createPaymentIntent(
      String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response =
          await http.post(paymentApiUrl, body: body, headers: headers);
      return jsonDecode(response.body);
    } catch (e) {
      print('error charging user : ${e.toString()}');
    }
    return null;
  }
}
