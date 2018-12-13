import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'globals.dart' as globals;
import 'dart:convert';


const String name = 'Sam';

class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Home',
      home: new ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {

  @override
  State createState() => new ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> messages = <ChatMessage>[];
  final TextEditingController textController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Chat')
      ),
      body: new Column(
        children: <Widget>[
          new Flexible(
            child: new ListView.builder(
              padding: new EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) => messages[index],
              itemCount: messages.length,
            ),
          ),
          new Divider(height: 1.0),
          new Container(
            decoration: new BoxDecoration(
              color: Theme.of(context).cardColor
            ),
            child: buildTextComposer(),
          )
        ],
      ),
    );
  }

  void handleSubmitted(String text) {
    textController.clear();
    ChatMessage message = new ChatMessage(
      text: text,
    );
    setState(() {
      messages.insert(0, message);
    });
    var url = "https://counterproducktivechat.tk:8448/_matrix/client/r0/rooms/%21QTariydDPoGYvWlazW:counterproducktivechat.tk/send/m.room.message?access_token=${globals.token}";
    http.post(url, body: '{"msgtype":"m.text", "body":"${text}"}').then((response) {
      print("sent ${text} to ${response.body}");
    });
  }

  void downloadList() async {
    var toParse;
    var url = "https://counterproducktivechat.tk:8448/_matrix/client/r0/sync?access_token=${globals.token}";
    var response = await http.get(url);
    toParse = json.decode(response.body);
    print(toParse);
    var toList = toParse['rooms']['join']['!QTariydDPoGYvWlazW:counterproducktivechat.tk']['timeline']['events'];
    print(toList);
    for(var i = 0; i < toList.length; ++i) {
      var a = toList[i]['content']['body'];
      print(a);
      ChatMessage message = new ChatMessage(
        text: a,
      );
      messages.insert(0, message);
      print(messages);
    }
  }

  Widget buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: textController,
                onSubmitted: handleSubmitted,
                decoration: new InputDecoration.collapsed(
                hintText: 'Send a message'
                ),
              ),
            ),
          new Container(
            margin: new EdgeInsets.symmetric(horizontal: 4.0),
            child: new IconButton(
              icon: new Icon(Icons.send),
              onPressed: () => handleSubmitted(textController.text),
              ),
            )
          ],
        )
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: new CircleAvatar(child: new Text(name[0])),
          ),
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(
                name,
                style: Theme.of(context).textTheme.subhead,
              ),
              new Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: new Text(text),
              )
            ],
          )
        ],
      ),
    );
  }
}