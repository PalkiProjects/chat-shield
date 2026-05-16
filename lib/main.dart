import 'package:flutter/material.dart';

void main() {
  runApp(ChatShieldApp());
}

class ChatShieldApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen());
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ChatShield")),
      body: Center(
        child: ElevatedButton(
          child: Text("Open Chat"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatScreen()),
            );
          },
        ),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();

  List<Map<String, String>> messages = [];

  String checkMessageType(String text) {
    List<String> toxicWords = ["hate", "stupid", "idiot", "angry"];
    List<String> goodWords = ["thank", "great", "nice", "love"];

    for (var word in toxicWords) {
      if (text.toLowerCase().contains(word)) {
        return "toxic";
      }
    }

    for (var word in goodWords) {
      if (text.toLowerCase().contains(word)) {
        return "good";
      }
    }

    return "normal";
  }

  bool isFakeMessage(String text) {
    List<String> fakeWords = [
      "win money",
      "click this",
      "urgent",
      "free",
      "offer",
    ];

    for (var word in fakeWords) {
      if (text.toLowerCase().contains(word)) {
        return true;
      }
    }

    return false;
  }

  void sendMessage() {
    if (messageController.text.trim().isEmpty) return;

    String type = checkMessageType(messageController.text);
    bool fake = isFakeMessage(messageController.text);

    setState(() {
      messages.add({
        "text": messageController.text,
        "type": type,
        "fake": fake.toString(),
      });
    });

    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: messages[index]["type"] == "toxic"
                          ? Colors.red
                          : messages[index]["type"] == "good"
                          ? Colors.green
                          : Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          messages[index]["text"]!,
                          style: TextStyle(color: Colors.white),
                        ),
                        if (messages[index]["fake"] == "true")
                          Text(
                            "⚠️ Suspicious message",
                            style: TextStyle(
                              color: Colors.yellow,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: messageController,
                  decoration: InputDecoration(hintText: "Type message..."),
                ),
              ),

              IconButton(icon: Icon(Icons.send), onPressed: sendMessage),
            ],
          ),
        ],
      ),
    );
  }
}
