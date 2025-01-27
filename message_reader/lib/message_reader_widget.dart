import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/svg.dart';
import 'package:message_reader/app_config.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:http/http.dart' as http;

import 'message.dart';

class CustomTextStyle {
  static const TextStyle nameOfTextStyle = TextStyle(
    fontSize: 12,
    color: Colors.black54,
    fontWeight: FontWeight.bold,
  );
}

class MessageReaderWidget extends StatefulWidget {
  const MessageReaderWidget({super.key});
  final String title = 'Message Reader for Enver Naser Kostanica & Catherine Edona';

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
      debugPrint("before load data");
    }

    _loadData();

    return Scaffold(
        // backgroundColor: Colors.blueAccent,
        appBar: AppBar(
          backgroundColor: Colors.black87,
          centerTitle: true,
          title:
          SizedBox(
            child: TextButton.icon(
              label: Text(
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orangeAccent),
                  widget.title),
              onPressed: null,
              icon: SvgPicture.asset(
                'assets/images/logo.svg',
                width: 100,
                // colorFilter: ColorFilter.linearToSrgbGamma(),
                //   color: Colors.black87
              ),
          )
          ,


          ),
        ),
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
        Container(
          color: Colors.white70,
          child: TextButton.icon(

            icon: Icon(Icons.outgoing_mail, color: Colors.orange,),
            label: Text(
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                "Message : ${messages.length}"),
            onPressed: null,
          ),
        )
        ,
        // Text("Message : ${messages.length}"),
        getContentWidgets()
      ],
    );
  }

  getContentWidgets() {
    double messageWidth = 300;
    List<Row> lines = [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(width: 60,),
        getCell(Text("email"), height: 75, alignment: Alignment.center),
        getCell(Text("name"), height: 75, alignment: Alignment.center),
        getCell(Text("phone"), height: 75, width: 150, alignment: Alignment.center),
        getCell(Text("message"),
            height: 75, alignment: Alignment.center, width: messageWidth),
      ])
    ];
    for (var message in messages.reversed) {
      var phoneBtn = TextButton.icon(
          icon: Icon(Icons.call),
          onPressed: () => launchUrlString("tel://{$message.phone}"),
          label: Text(message.phone, style: CustomTextStyle.nameOfTextStyle));
      var color = Colors.lightBlueAccent;
      var line = Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
            alignment: Alignment.center,
            height: 100,
            width: 60,
            color: Colors.transparent,
            child:CircleAvatar(
              radius: 90,
              backgroundColor: Colors.white70,
              child: IconButton(
                icon: Icon(
                  Icons.delete_forever,
                  color: Colors.black87,
                ),
                onPressed: () {
                  // todo
                },
              ),
            ),
        )
        ,
        getCell(Text(message.email), color: color),
        getCell(Text(message.name), color: color),
        getCell(phoneBtn, color: color , width: 150),
        getCell(
            SingleChildScrollView(
                controller: ScrollController(),
                physics: ScrollPhysics(),
                child: Text(message.message)),
            color: Colors.white70,
            width: messageWidth
        ),
      ]);
      lines.add(line);
    }
    return Column(children: lines);
  }
}

getCell(Widget child,
    {alignment = Alignment.topLeft,
    color = Colors.orange,
    double width = 140,
    double height = 100}) {
  return Container(
    alignment: alignment,
    width: width,
    height: height,
    margin: const EdgeInsets.all(1.0),
    padding: const EdgeInsets.all(3.0),
    decoration:
        BoxDecoration(border: Border.all(color: Colors.blueGrey), color: color),
    child: child,
  );
}
