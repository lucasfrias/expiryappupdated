import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum ConfirmAction { CANCEL, ACCEPT, SCANNER, MANUAL }

class Utility {

  static Future<ConfirmAction> asyncConfirmDialog(BuildContext context, String content, String title) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: (){
                  Navigator.of(context).pop(ConfirmAction.CANCEL);
                },
                child: Text("Cancel")
            ),
            CupertinoDialogAction(
                textStyle: TextStyle(color: Colors.red),
                isDefaultAction: true,
                onPressed: () async {
                  Navigator.of(context).pop(ConfirmAction.ACCEPT);
                },
                child: Text("Accept")
            ),
            /**FlatButton(
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
            )**/
          ],
        );
      },
    );
  }

  static Future<ConfirmAction> asyncAddFoodDialog(BuildContext context) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: true, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Add food'),
          content: Text('Enter information manually or use barcode scanner?'),
          actions: <Widget>[
            CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: (){
                  Navigator.of(context).pop(ConfirmAction.MANUAL);
                },
                child: Text("Manually")
            ),
            CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () async {
                  Navigator.of(context).pop(ConfirmAction.SCANNER);
                },
                child: Text("Scanner")
            ),
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
        return CupertinoAlertDialog(
          title: Text('Sorry, food not found!'),
          content: Text('Would you like to add it manually?'),
          actions: <Widget>[
            CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: (){
                  Navigator.of(context).pop(ConfirmAction.CANCEL);
                },
              child: const Text('No')
            ),
            CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () async {
                  Navigator.of(context).pop(ConfirmAction.ACCEPT);
                },
               child: const Text('Yes')
            ),
       /** return AlertDialog(
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
            )**/
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
        return CupertinoAlertDialog(
          title: Text("Error"),
          content: Text("Please try again."),
          actions: <Widget>[
            CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: (){
                  Navigator.of(context).pop();
                },
                child: const Text('Ok')
            ),
          ],
        /**return AlertDialog(
          title: Text("Sorry! There was an error."),
          content: Text("Please try again."),
          actions: [
            FlatButton(
              child: Text('Ok'),
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),
          ],**/
        );
      },
    );
  }
}