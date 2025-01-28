import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:message_reader/message.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Custom {
  static var logo = SvgPicture.asset(
    'assets/images/logo.svg',
    width: 100,
  );
  static String title =
      'Message Reader for Enver Naser Kostanica & Catherine Edona';
  static TextStyle h1TextStyle = TextStyle(
    fontSize: 08,
    color: Colors.black54,
    fontWeight: FontWeight.bold,
  );
  static TextStyle mailTextStyle = TextStyle(
    fontSize: 08,
  );

  static CircleAvatar deleteBtn = CircleAvatar(
      radius: 90,
      backgroundColor: Colors.white70,
      child: Custom._deleteBtnInside);

  static final IconButton _deleteBtnInside = IconButton(
    icon: Icon(
      Icons.delete_forever,
      color: Colors.black87,
    ),
    onPressed: () {
// todo
    },
  );

  static Container deleteContainer = Container(
      alignment: Alignment.center,
      // height: 30,
      // width: 60,
      child: Custom.deleteBtn);

  static var appBar = AppBar(
    backgroundColor: Colors.black87,
    centerTitle: true,
    title: SizedBox(
      child: TextButton.icon(
          label: Text(
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.orangeAccent),
              Custom.title),
          onPressed: null,
          icon: Custom.logo),
    ),
  );
  static Row tableHead(
    String orientation,
    Size size,
  ) {
    var height = 50.0;
    var width = size.width;
    var namePhoneMailWidth = width / 3.2;
    var messageWidth = width / 1.5;

    if (orientation == "Orientation.portrait") {
      height = 30.0;
      namePhoneMailWidth = width / 3.2;
      messageWidth = width / 1.46;
      return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Custom.getCell(Text("contact"),
            width: namePhoneMailWidth,
            height: height,
            alignment: Alignment.center),
        Custom.getCell(Text("message"),
            width: messageWidth, height: height, alignment: Alignment.center)
      ]);
    } // else if (orientation == "Orientation.landscape") {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(width: 60),
      //Custom.getCell(Text("email"), height: 75, alignment: Alignment.center),
      Custom.getCell(Text(orientation),
          height: height, alignment: Alignment.center),
      Custom.getCell(Text("phone / mail"),
          height: height, width: 250, alignment: Alignment.center),
      Custom.getCell(Text("message"),
          height: height, alignment: Alignment.center, width: messageWidth),
    ]);
  }

  static var emailCellColor = Colors.white70;
  static var phoneCellColor = Colors.white70;
  static var nameCellColor = Colors.white70;

  static Widget introWidget(int messagesLength, Function refreshFunc) {
    return Container(
        color: Colors.white70,
        child: Row(children: [
          TextButton.icon(
              icon: Icon(Icons.refresh),
              label: Text("refresh"),
              onPressed: () {
                refreshFunc();
              }),
          TextButton.icon(
            icon: Icon(
              Icons.outgoing_mail,
              // color: Colors.orange,
            ),
            label: Text("Message : $messagesLength"),
    onPressed: () {
    refreshFunc();
    })

        ]));
  }

  static Widget phoneBtn(String phone) {
    return TextButton.icon(
        icon: Icon(Icons.call),
        onPressed: () => launchUrlString("tel://{$phone}"),
        label: Text(phone, style: Custom.h1TextStyle));
  }

  static Widget mailBtn(String mail) {
    if (mail.length > 40) {
      mail = "${mail.substring(0, 37)}...";
    }
    return TextButton.icon(
        icon: Icon(Icons.mail),
        onPressed: () => launchUrlString("mailto:$mail"),
        label: Text(
          mail,
          style: Custom.mailTextStyle,
        ));
  }

  static Widget getMessageBox(String message) {
    return SingleChildScrollView(
        controller: ScrollController(),
        physics: ScrollPhysics(),
        child: Text(message));
  }

  static getCell(Widget child,
      {alignment = Alignment.topLeft,
      color = Colors.orange,
      double width = 140,
      double height = 100}) {
    return Container(
      alignment: alignment,
      width: width,
      height: height,
      margin: const EdgeInsets.all(0),
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.blueGrey), color: color),
      child: child,
    );
  }

  static getMessageWithOrder(List<Message> messages) {
    return messages.reversed;
  }

  static nameCell(name, String orientation, Size size) {
    var height = 50.0;
    var width = size.width / 3.2;
    if (orientation == "Orientation.portrait") {
      height = 30.0;
      width = size.width / 3.2;
    }

    // return  getCell(Text(name), width: width, height: height, color: Custom.nameCellColor, );
    return Container(
        alignment: Alignment.topCenter,
        color: Custom.phoneCellColor,
        width: width,
        height: height,
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(2),
        child: Text(name, style: Custom.mailTextStyle));
  }

  static emailCell(email, String orientation, Size size) {
    var height = 50.0;
    var width = size.width / 3;
    if (orientation == "Orientation.portrait") {
      height = 45.0;
      width = size.width / 3.2;
    }
    return Container(
      alignment: Alignment.topLeft,
      color: Custom.phoneCellColor,
      width: width,
      height: height,
      margin: const EdgeInsets.all(0),
      padding: const EdgeInsets.all(0),
      child: Custom.mailBtn(email),
    );
  }

  static phoneCell(phone, String orientation, Size size) {
    var height = 50.0;
    var width = size.width / 3;
    if (orientation == "Orientation.portrait") {
      height = 34.0;
      width = size.width / 3.2;
    }

    return Container(
      alignment: Alignment.topLeft,
      color: Custom.phoneCellColor,
      width: width,
      height: height,
      child: Custom.phoneBtn(phone),
    );
  }

  static messageCell(message, String orientation, Size size) {
    var height = 75.0;
    var width = size.width / 2.9;
    if (orientation == "Orientation.portrait") {
      height = 110.0;
      width = size.width / 1.46;
    }
    return Custom.getCell(Custom.getMessageBox(message),
        color: Colors.white70, width: width, height: height);
  }
}
