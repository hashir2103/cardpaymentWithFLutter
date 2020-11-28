import 'package:cardpayment/services/payment_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ExistingCards extends StatefulWidget {
  @override
  _ExistingCardsState createState() => _ExistingCardsState();
}

class _ExistingCardsState extends State<ExistingCards> {
  List cards = [
    {
      'cardNumber': '4242424242424242',
      'expiryDate': '04/24',
      'cardHolderName': 'Hashir',
      'cvvCode': '424',
      'showBackView': false,
    },
    {
      'cardNumber': '5555555555554444',
      'expiryDate': '05/23',
      'cardHolderName': 'Siddiqui',
      'cvvCode': '594',
      'showBackView': false,
    },
  ];

  payViaExistingCard(BuildContext context, card) async {
    ProgressDialog dialog = ProgressDialog(context);
    dialog.style(message: "Please wait...");
    await dialog.show();
    var expiryArr = card['expiryDate'].split('/');
    CreditCard stripecard = CreditCard(
      number: card['cardNumber'],
      expMonth: int.parse(expiryArr[0]),
      expYear: int.parse(expiryArr[1]),
    );
    var response = await StripeService.payViaExistingCard(
        amount: '2500', currency: 'USD', card: stripecard);
    await dialog.hide();
    Scaffold.of(context)
        .showSnackBar(SnackBar(
          content: Text(response.message),
          duration: Duration(seconds: 2),
        ))
        .closed
        .then((_) => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose Existing Card"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView.builder(
            itemCount: cards.length,
            itemBuilder: (BuildContext context, int index) {
              var card = cards[index];
              return InkWell(
                  onTap: () => payViaExistingCard(context, card),
                  child: CreditCardWidget(
                      cardNumber: card['cardNumber'],
                      expiryDate: card['expiryDate'],
                      cardHolderName: card['cardHolderName'],
                      cvvCode: card['cvvCode'],
                      showBackView: false));
            }),
      ),
    );
  }
}
