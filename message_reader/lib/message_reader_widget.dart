import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/svg.dart';
import 'package:message_reader/app_config.dart';
import 'package:message_reader/utils.dart';
import 'package:message_reader/widgets/customs.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:http/http.dart' as http;

import 'message.dart';

class MessageReaderWidget extends StatefulWidget {
  const MessageReaderWidget({super.key});

  @override
  State<MessageReaderWidget> createState() => _MessageReaderWidgetState();
}

class _MessageReaderWidgetState extends State<MessageReaderWidget> {
  List<Message> messages = List.empty();

  void _loadData() {
    if (messages.isEmpty) {
      Utils.downloadJson().then((jsonData) {
        setState(() {
          List<dynamic> jsonResponse = json.decode(jsonData);
          messages = jsonResponse
              .map((e) => Message.fromJson(e as Map<String, dynamic>))
              .toList();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      debugPrint("before load data");
    }

    _loadData();

    return Scaffold(
        appBar: Custom.appBar,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.webp"),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            controller: ScrollController(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MessagesListWidget(
                  messages: messages,
                ),
              ],
            ),
          ),
        ));
  }
}

class MessagesListWidget extends StatelessWidget {
  const MessagesListWidget({super.key, required this.messages});
  final List<Message> messages;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Custom.introWidget(messages.length),
        getContentWidgets()
      ],
    );
  }

  getContentWidgets() {
    List<Row> lines = [Custom.tableHead];
    for (var message in Custom.getMessageWithOrder(messages)) {

      var line = Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Custom.deleteContainer,
        Custom.emailCell(message.email),
        Custom.nameCell(message.name),
        Custom.phoneCell(message.phone),
        Custom.getCell(Custom.getMessageBox(message.message),
            color: Colors.white70, width: Custom.messageWidth),
      ]);
      lines.add(line);
    }
    return Column(children: lines);
  }
}
