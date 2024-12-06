import 'package:flutter/material.dart';
import 'package:fromzero_app/models/company_model.dart';
import '../../models/developer_model.dart';
import 'developerProjects.dart';
import 'package:fromzero_app/api/chatService.dart';
import 'package:fromzero_app/views/messages/MessageView.dart';
import 'package:fromzero_app/models/chat_model.dart';

class PreviewDeveloper extends StatelessWidget {
  final Developer developer;
  final Company currentUser;

  const PreviewDeveloper({
    super.key,
    required this.developer,
    required this.currentUser
  });

  Future<Chat?> _createOrOpenChat(String currentUserId, Developer developer) async {
    final ChatService chatService = ChatService();
    try {
      final chat = await chatService.getChatByDeveloperAndCompany(
          developer.profileId, currentUser.profileId);
      if (chat != null) {
        return chat;
      }
      final newChat = await chatService.createChat(
          currentUser.profileId, developer.profileId);
      return newChat;
    } catch (e) {
      print("Error creating or opening chat: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(developer.profileImgUrl),
                radius: 60,
              ),
              const SizedBox(height: 16),
              Text(
                '${developer.firstName} ${developer.lastName}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                developer.description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              _buildDetailRow(Icons.email, developer.email),
              _buildDetailRow(Icons.location_on, developer.country),
              _buildDetailRow(Icons.phone, developer.phone),
              _buildDetailRow(Icons.code, developer.specialties),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  final chat = await _createOrOpenChat(currentUser.profileId, developer);
                  if (chat != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MessagesView(chatId: chat.id, senderId: currentUser.profileId),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text(
                  "Chatear",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DeveloperProjectsScreen(
                        developerId: developer.profileId,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text(
                  'Ver Proyectos',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String detail) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              detail,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}