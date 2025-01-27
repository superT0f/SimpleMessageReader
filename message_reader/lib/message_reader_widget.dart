import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:message_reader/app_config.dart';

class MessageReaderWidget extends StatefulWidget {
  const MessageReaderWidget({super.key});
  final String title = 'Message Reader';

  @override
  State<MessageReaderWidget> createState() => _MessageReaderWidgetState();
}

class _MessageReaderWidgetState extends State<MessageReaderWidget> {
  List<Message> messages = List.empty();

  void _loadData() {
    if (messages.isEmpty) {
      downloadJson().then((jsonData) {
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
      debugPrint("load data");
    }

    _loadData();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MessagesListWidget(
              messages: messages,
            ),
          ],
        ),
      ),
    );
  }

  Future<String> downloadJson() async {
    try {
      var response = await http.get(AppConfig.apiUrl,
          headers: <String, String>{'authorization': AppConfig.basicAuth});
      if (kDebugMode) {
        debugPrint(" response : $response");
      }
      if (response.statusCode == 200) {
        if (kDebugMode) {
          debugPrint(response.body);
        }

        return response.body;
      } else {
        throw Exception(
            'Failed to load JSON data from the internet. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error downloading JSON: $e, $e.message');
    }
  }
}

class MessagesListWidget extends StatelessWidget {
  const MessagesListWidget({super.key, required this.messages});
  final List<Message> messages;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text("Message : ${messages.length}"),
        getContentWidgets()
      ],
    );
  }

  getContentWidgets() {
    List<Row> lines = [
    Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          getHeaderCell("email"),
          getHeaderCell("name"),
          getHeaderCell("phone"),
          getHeaderCell("message"),
      ])
    ];
    for (var message in messages) {
      var line = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
        getCell(message.email),
        getCell(message.name),
        getCell(message.phone),
        getCell(message.message),
      ]);
      lines.add(line);
    }
    return Column(children: lines);
  }
}
getHeaderCell(String data) {
  return Container(
    alignment: Alignment.center,
    width: 150,
    height: 50,
    margin: const EdgeInsets.all(1.0),
    padding: const EdgeInsets.all(3.0),
    decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        color: Colors.grey
    ),
    child: Text(data),
  );
}


getCell(String data) {
    return Container(
      width: 150,
    height: 50,
    margin: const EdgeInsets.all(1.0),
    padding: const EdgeInsets.all(3.0),
    decoration: BoxDecoration(
        border: Border.all(color: Colors.green),
            color: Colors.lightBlueAccent
    ),
    child: Text(data),
  );
}

class Message {
  final String name;
  final String phone;
  final String email;
  final String message;
  final String? debug;

  Message({
    required this.name,
    required this.phone,
    required this.email,
    required this.message,
    this.debug,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      name: json['name'] as String,
      phone: json['tel'] as String,
      email: json['email'] as String,
      message: json['message'] as String,
      debug: json['robot'] as String?,
    );
  }
  @override
  String toString() {
    return '$name | $email | $phone';
  }

  Future<String> downloadJson(String url) async {
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // if (kDebugMode){
        //   debugPrint(response.body);
        // }

        return response.body;
      } else {
        throw Exception(
            'Failed to load JSON data from the internet. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error downloading JSON: $e');
    }
  }
}
