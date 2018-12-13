import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:background_fetch/background_fetch.dart';



const String name = 'Sam';

class Home extends StatelessWidget {
  Home(this.token);
  final String token;

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Home',
      home: new ChatScreen(token),
    );
  }
}

class ChatScreen extends StatefulWidget {
  ChatScreen(this.token);
  final String token;

  @override
  State createState() => new ChatScreenState(token);
}

class ChatScreenState extends State<ChatScreen> {
  ChatScreenState(this.token);
  final String token;
  final List<ChatMessage> messages = <ChatMessage>[];
  final TextEditingController textController = new TextEditingController();
  bool _enabled = true;
  int _status = 0;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

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
    print("The token is ${token}");
    var url = "https://counterproducktivechat.tk:8448/_matrix/client/r0/rooms/%21QTariydDPoGYvWlazW:counterproducktivechat.tk/send/m.room.message?access_token=MDAyN2xvY2F0aW9uIGNvdW50ZXJwcm9kdWNrdGl2ZWNoYXQudGsKMDAxM2lkZW50aWZpZXIga2V5CjAwMTBjaWQgZ2VuID0gMQowMDMxY2lkIHVzZXJfaWQgPSBAc2FtOmNvdW50ZXJwcm9kdWNrdGl2ZWNoYXQudGsKMDAxNmNpZCB0eXBlID0gYWNjZXNzCjAwMjFjaWQgbm9uY2UgPSA4aGx3Oko7bENNUTdxeW4mCjAwMmZzaWduYXR1cmUg_hav8l5IME_ian1CxcZ2psZeu4XpzAYumU32UoakmDUK";
    http.post(url, body: '{"msgtype":"m.text", "body":"${text}"}').then((response) {
      print("sent ${text} to ${response.body}");
    });
  }

  Future<void> initPlatformState() async {
    // Configure BackgroundFetch.
    BackgroundFetch.configure(BackgroundFetchConfig(
        minimumFetchInterval: 15,
        startOnBoot: true,
        stopOnTerminate: false,
        enableHeadless: true
    ), () async {
      // This is the fetch-event callback.
      print('[BackgroundFetch] Event received');
      setState(() {
        ChatMessage message = new ChatMessage(
          text: 'test',
        );
        messages.insert(0, message);
      });
      // IMPORTANT:  You must signal completion of your fetch task or the OS can punish your app
      // for taking too long in the background.
      BackgroundFetch.finish();
    }).then((int status) {
      print('[BackgroundFetch] SUCCESS: $status');
      setState(() {
        ChatMessage message = new ChatMessage(
          text: 'test',
        );
        messages.insert(0, message);
        _status = status;
      });
    }).catchError((e) {
      print('[BackgroundFetch] ERROR: $e');
      setState(() {
        _status = e;
      });
    });

    // Optionally query the current BackgroundFetch status.
    int status = await BackgroundFetch.status;
    setState(() {
      _status = status;
    });

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
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