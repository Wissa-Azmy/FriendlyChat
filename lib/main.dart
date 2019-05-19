import 'package:flutter/material.dart';

void main() => runApp(FriendlyChat());

class FriendlyChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: "Friendly Chat",
      home: ChatScreen()
    );
  }
}



class ChatScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ChatScreenState();
}

// The vsync prevents animations that are offscreen from consuming unnecessary resources.
// To use your ChatScreenState as the vsync include a TickerProviderStateMixin mixin
class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final _textFieldController = TextEditingController();
  final _messages = <ChatMessage>[];

  _handleSubmission(String text){
    _textFieldController.clear();

    AnimationController animation = AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    ChatMessage message = ChatMessage(text: text, animationController: animation,);

    setState(() {
      _messages.insert(0, message);
    });

    message.animationController.forward();
  }

  _buildTextFieldComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textFieldController,
                onSubmitted: _handleSubmission,
                decoration: InputDecoration.collapsed(hintText: "Send a message!"),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _handleSubmission(_textFieldController.text)
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Friendly Chat"),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              itemBuilder: (_, index) => _messages[index],
              itemCount: _messages.length,
              reverse: true, //to make the ListView start from the bottom of the screen
              padding: EdgeInsets.all(8.0),
            ),
          ),
          Divider(height: 1.0,),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextFieldComposer(),
          )
        ],
      )
    );
  }

  // Dispose of your animation controllers to free up your resources when they are no longer needed which is required only in single screens apps
  @override
  void dispose() {
    for (ChatMessage message in _messages)
      message.animationController.dispose();
    super.dispose();
  }
}



class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController});
  final String text;
  final AnimationController animationController;
  static const String _name = "Wissa Michael";

  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SizeTransition(
      sizeFactor: CurvedAnimation(parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 16.0),
              child: CircleAvatar(child: Text(_name[0]),), // Show the first char of the name
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(_name, style: Theme.of(context).textTheme.subhead),
                Container(
                  margin: EdgeInsets.only(top: 5.0),
                  child: Text(text),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}