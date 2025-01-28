import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'utils.dart';
import 'widgets/customs.dart';
import 'message.dart';

class MessageReaderWidget extends StatefulWidget {
  const MessageReaderWidget({super.key});

  @override
  State<MessageReaderWidget> createState() => _MessageReaderWidgetState();
}

class _MessageReaderWidgetState extends State<MessageReaderWidget> {
  List<Message> messages = List.empty();
  void messageReaderRefresh() {
    messages = List.empty();
    _loadData();
  }
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
                  messages,
                  refreshFunc: messageReaderRefresh
                ),
              ],
            ),
          ),
        ));
  }
}

class MessagesListWidget extends StatefulWidget {
  const MessagesListWidget(this.messages, {super.key, required this.refreshFunc});
  final List<Message> messages;
  final Function refreshFunc;

  @override
  State<MessagesListWidget> createState() => _MessagesListWidgetState();
}

class _MessagesListWidgetState extends State<MessagesListWidget> {

    @override
    Widget build(BuildContext context) {
      return Column(
        children: <Widget>[
          Custom.introWidget(widget.messages.length, widget.refreshFunc),
          getContentWidgets(context)
        ],
      );
    }

    getContentWidgets(BuildContext context) {
      final size = MediaQuery.of(context).size;
      final orientation = MediaQuery.of(context).orientation.toString();
      List<Row> lines = [Custom.tableHead(orientation, size)];
      for (var message in Custom.getMessageWithOrder(widget.messages)) {

        var line = Row(mainAxisAlignment: MainAxisAlignment.center, children: [

          Column(
            children: [
              Custom.nameCell(message.name, orientation, size),
              Custom.emailCell(message.email, orientation, size),
              Custom.phoneCell(message.phone, orientation, size),
            ],
          ),
          Custom.messageCell(message.message, orientation, size),
        ]);
        lines.add(line);
      }
      return Column(children: lines);
    }
  }

