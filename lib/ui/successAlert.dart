library flutter_awesome_alert_box;

import 'package:flutter/material.dart';

class SuccessBgAlertBox {
  final BuildContext context;
  final String title;
  final IconData icon;
  final String infoMessage;
  final Color titleTextColor;
  final Color messageTextColor;
  final Color buttonColor;
  final Color buttonTextColor;
  final String buttonText;
  SuccessBgAlertBox(
      {this.context,
      this.title,
      this.infoMessage,
      this.titleTextColor,
      this.messageTextColor,
      this.buttonColor,
      this.buttonText,
      this.buttonTextColor,
      this.icon}) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color(0xFF6ab04c),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0))),
            contentPadding:
                const EdgeInsets.only(bottom: 20, left: 20, right: 20, top: 8),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.check,
                  color: titleTextColor ?? Colors.white,
                  size: 90.0,
                ),
                Flexible(
                    child: Text(
                  title ?? "Your alert title",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: titleTextColor ?? Colors.white),
                )),
                SizedBox(
                  height: 4.0,
                ),
                Flexible(
                  child: Text(
                    infoMessage ?? "Alert message here",
                    style: TextStyle(color: messageTextColor ?? Colors.white),
                  ),
                ),
                FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(9.0))),
                  color: buttonColor ?? Colors.white,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        buttonText ?? "Close",
                        style:
                            TextStyle(color: buttonTextColor ?? Colors.black),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}

class DarkBgAlertBox {
  final BuildContext context;
  final String title;
  final IconData icon;
  final String infoMessage;
  final Color titleTextColor;
  final Color messageTextColor;
  final Color buttonColor;
  final Color buttonTextColor;
  final String buttonText;

  DarkBgAlertBox(
      {this.context,
      this.title,
      this.infoMessage,
      this.titleTextColor,
      this.messageTextColor,
      this.buttonColor,
      this.buttonText,
      this.buttonTextColor,
      this.icon}) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color(0xFF20242A),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0))),
            contentPadding:
                const EdgeInsets.only(bottom: 20, left: 20, right: 20, top: 8),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.close,
                  color: titleTextColor ?? Colors.red,
                  size: 90.0,
                ),
                Flexible(
                    child: Text(
                  title ?? "Your alert title",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: titleTextColor ?? Color(0xFF4E4E4E)),
                )),
                SizedBox(
                  height: 10.0,
                ),
                Flexible(
                  child: Text(
                    infoMessage ?? "Alert message here",
                    style:
                        TextStyle(color: messageTextColor ?? Color(0xFF4E4E4E)),
                  ),
                ),
                SizedBox(height: 10),
                FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(9.0))),
                  color: buttonColor ?? Color(0xFF4E4E4E),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        buttonText ?? "CLOSE",
                        style: TextStyle(color: buttonTextColor ?? Colors.red),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class WarningBgAlertBox {
  final BuildContext context;
  final String title;
  final IconData icon;
  final String infoMessage;
  final Color titleTextColor;
  final Color messageTextColor;
  final Color buttonColor;
  final Color buttonTextColor;
  final String buttonText;
  final Function ontap;
  final String buttontext2;
  WarningBgAlertBox(
      {this.context,
      this.title,
      this.infoMessage,
      this.titleTextColor,
      this.messageTextColor,
      this.buttonColor,
      this.buttonText,
      this.buttonTextColor,
      this.ontap,
      this.buttontext2,
      this.icon}) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color(0xFF22222b),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0))),
            contentPadding:
                const EdgeInsets.only(bottom: 10, left: 18, right: 18, top: 18),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.do_not_disturb_alt,
                  color: titleTextColor ?? Colors.white,
                  size: 90.0,
                ),
                Flexible(
                    child: Text(
                  title ?? "Your alert title",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: titleTextColor ?? Colors.white),
                )),
                SizedBox(
                  height: 10.0,
                ),
                Flexible(
                  child: Text(
                    infoMessage ?? "Alert message here",
                    style: TextStyle(color: messageTextColor ?? Colors.white),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    InkWell(
                        onTap: ontap,
                        child: Container(
                            height: 35,
                            width: 90,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                            child: Center(
                                child: Text(
                              'OK',
                              style: TextStyle(color: Colors.black),
                            )))),
                    FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      color: buttonColor ?? Colors.white,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            buttonText ?? "CLOSE",
                            style: TextStyle(
                                color: buttonTextColor ?? Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }
}
