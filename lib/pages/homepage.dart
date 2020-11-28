import 'package:cardpayment/services/payment_services.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  onItemPress(BuildContext context, int index) async {
    switch (index) {
      case 0:
        payViaNewCard(context);
        break;
      case 1:
        Navigator.pushNamed(context, '/existing-cards');
        break;
    }
  }

  payViaNewCard(BuildContext context) async {
    ProgressDialog dialog = ProgressDialog(context);
    dialog.style(message: "Please wait...");
    await dialog.show();
    var response =
        await StripeService.payViaNewCard(amount: '15000', currency: 'USD');
    await dialog.hide();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(response.message),
      duration: Duration(seconds: 2),
    ));
  }

  @override
  void initState() {
    super.initState();
    StripeService.init();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Container(
          padding: EdgeInsets.all(20),
          child: ListView.separated(
            separatorBuilder: (context, index) => Divider(
              color: theme.primaryColor,
              height: 25,
            ),
            itemCount: 3,
            itemBuilder: (context, index) {
              Icon icon;
              Text text;
              switch (index) {
                case 0:
                  icon = Icon(
                    Icons.add_circle,
                    color: theme.primaryColor,
                  );
                  text = Text('Pay Via New Card');
                  break;
                case 1:
                  icon = Icon(
                    Icons.credit_card,
                    color: theme.primaryColor,
                  );
                  text = Text('Pay Via Existing Card');
                  break;
              }
              return InkWell(
                onTap: () {
                  onItemPress(context, index);
                },
                child: ListTile(
                  title: text,
                  leading: icon,
                ),
              );
            },
          )),
    );
  }
}
