import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:message_reader/message.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Custom {
  static var logo = SvgPicture.asset(
    'assets/images/logo.svg',
    width: 100,
  );
  static double messageWidth = 300;
  static String title =
      'Message Reader for Enver Naser Kostanica & Catherine Edona';
  static TextStyle h1TextStyle = TextStyle(
    fontSize: 12,
    color: Colors.black54,
    fontWeight: FontWeight.bold,
  );
  static TextStyle mailTextStyle = TextStyle(
    fontSize: 10,
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

  static Container deleteContainer =  Container(
      alignment: Alignment.center,
      height: 100,
      width: 60,
      color: Colors.transparent,
      child: Custom.deleteBtn
  );

  static var appBar =
  AppBar(
    backgroundColor: Colors.black87,
    centerTitle: true,
    title: SizedBox(
      child: TextButton.icon(
        label: Text(
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.orangeAccent),
            Custom.title),
        onPressed: null,
        icon: Custom.logo
      ),
    ),
  );

  static var tableHead =
  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    Container(width: 60),
    Custom.getCell(Text("email"), height: 75, alignment: Alignment.center),
    Custom.getCell(Text("name"), height: 75, alignment: Alignment.center),
    Custom.getCell(Text("phone"),
        height: 75, width: 150, alignment: Alignment.center),
    Custom.getCell(Text("message"),
        height: 75,
        alignment: Alignment.center,
        width: Custom.messageWidth),
  ]);

  static var emailCellColor = Colors.white60;
  static var phoneCellColor = Colors.white70;
  static var nameCellColor = Colors.white60;

  static Container introWidget(int messagesLength) {
    return Container(
      color: Colors.white70,
      child: TextButton.icon(
        icon: Icon(
          Icons.outgoing_mail,
          color: Colors.orange,
        ),
        label: Text(
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black),
            "Message : $messagesLength"),
        onPressed: null,
      ),
    );
  }

  static Widget phoneBtn(String phone) {
    return TextButton.icon(
        icon: Icon(Icons.call),
        onPressed: () => launchUrlString("tel://{$phone}"),
        label: Text(phone, style: Custom.h1TextStyle));
  }
  static Widget mailBtn(String mail) {
    return TextButton.icon(
        icon: Icon(Icons.mail),
        onPressed: () => launchUrlString("mailto:$mail"),
        label: Text("${mail.substring(0,15)}...", style: Custom.mailTextStyle,));
  }
  static Widget getMessageBox(String message) {
    return
    SingleChildScrollView(
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
      decoration:
      BoxDecoration(border: Border.all(color: Colors.blueGrey), color: color),
      child: child,
    );
  }

  static getMessageWithOrder(List<Message> messages) {
    return messages.reversed;
  }

  static emailCell(email) {
    return Custom.getCell(
        Custom.mailBtn(email),
        color: Custom.emailCellColor);
  }

  static nameCell(name) {
    return  getCell(Text(name), color: Custom.nameCellColor);
  }

  static phoneCell(phone) {
    return getCell(Custom.phoneBtn(phone),
        color: Custom.phoneCellColor, width: 150);
  }
}


