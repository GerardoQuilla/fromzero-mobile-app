import 'package:flutter/material.dart';
import 'package:fromzero_app/api/chatService.dart';
import 'package:fromzero_app/api/profilesService.dart';
import 'package:fromzero_app/models/chat_model.dart';
import 'package:fromzero_app/views/messages/MessageView.dart';

class ChatListView extends StatefulWidget {
  final String profileId;
  final String role;

  const ChatListView({Key? key, required this.profileId, required this.role}) : super(key: key);

  @override
  _ChatListViewState createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  final ChatService _chatService = ChatService();
  final ProfilesService _profilesService = ProfilesService();
  List<Chat> _chats = [];
  Map<int, String> _chatNames = {};

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  Future<void> _loadChats() async {
    try {
      List<Chat> chats;
      if (widget.role == "COMPANY") {
        chats = await _chatService.getChatsForCompany(widget.profileId);
      } else {
        chats = await _chatService.getChatsForDeveloper(widget.profileId);
      }

      for (var chat in chats) {
        if (widget.profileId != chat.company) {
          var company = await _profilesService.getCompany(chat.company);
          _chatNames[chat.id] = company.companyName;
        } else if (widget.profileId != chat.developer) {
          var developer = await _profilesService.getDeveloper(chat.developer);
          _chatNames[chat.id] = "${developer.firstName} ${developer.lastName}";
        }
      }

      setState(() {
        _chats = chats;
      });
    } catch (e) {
      print("Error loading chats: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Chats"),
        backgroundColor: Colors.lightBlue,
      ),
      body: _chats.isNotEmpty?ListView.builder(
        itemCount: _chats.length,
        itemBuilder: (context, index) {
          final chat = _chats[index];
          final chatName = _chatNames[chat.id] ?? "Unknown";
          return Column(
            children: [
              Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text(chatName),
                  subtitle: Text("Created at: ${chat.createdAt}"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MessagesView(chatId: chat.id, senderId: widget.profileId),
                      ),
                    );
                  },
                ),
              ),
              Divider(),
            ],
          );
        },
      ):Center(child: Text("Aún no hay contactos"),),
    );
  }
}