import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum ConfirmAction { CANCEL, ACCEPT }

class Utility {

  static Future<ConfirmAction> asyncConfirmDialog(BuildContext context, String message) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message),
          actions: <Widget>[
            FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.CANCEL);
              },
            ),
            FlatButton(
              child: const Text('ACCEPT'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.ACCEPT);
              },
            )
          ],
        );
      },
    );
  }

  static String formatISO(String date){
    var datetime = DateTime.parse(date.replaceFirstMapped(RegExp("(\\.\\d{6})\\d+"), (m) => m[1]));
    return DateFormat.yMMMMd("en_US").format(datetime).toString();
  }

  static Future<DateTime> selectDate(BuildContext context) async {
    final DateTime today = DateTime.now();
    final DateTime expirationDate =  await showDatePicker(
        context: context,
        initialDate: today,
        firstDate: today,
        lastDate: DateTime.now().add(Duration(days: 356))
    );
    print(expirationDate);
    //asyncTest(context, expirationDate.toString());
    return expirationDate;
  }

  static Future<ConfirmAction> asyncManualBarcodeDialog(BuildContext context) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Sorry! There was an error."),
          content: Text("Would you like to add it manually?"),
          actions: <Widget>[
            FlatButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.CANCEL);
              },
            ),
            FlatButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.ACCEPT);
              },
            )
          ],
        );
      },
    );
  }

  static asyncError(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Sorry! There was an error."),
          content: Text("Please try again."),
          actions: [
            FlatButton(
              child: Text('Ok'),
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}