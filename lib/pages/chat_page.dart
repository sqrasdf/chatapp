import 'package:chatapp/components/chat_bubble.dart';
import 'package:chatapp/components/items.dart';
import 'package:chatapp/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String recieverUserEmail;
  final String recieverUserID;

  const ChatPage({
    super.key,
    required this.recieverUserEmail,
    required this.recieverUserID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final ScrollController _scrollController = ScrollController();

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.recieverUserID, _messageController.text);

      // clear text controller
      _messageController.clear();
    }
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recieverUserEmail),
      ),
      body: Column(
        children: [
          // messages
          Expanded(
            child: _buildMessageList(),
          ),

          // input
          const SizedBox(height: 8),
          _buildMessageInput(),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  // build message list
  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
          widget.recieverUserID, _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error ${snapshot.error}");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView(
          controller: _scrollController,
          reverse: true,
          children: snapshot.data!.docs
              .map((document) => _buildMessageItem(document))
              .toList(),
        );
      },
    );
  }

  // build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    // my message == right
    // not mine == left
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    var decoration = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(5),
            ),
            color: Colors.blue,
          )
        : const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(5),
              bottomRight: Radius.circular(16),
            ),
            color: Colors.blue,
          );

    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 3,
      ),
      child: Column(
          crossAxisAlignment: data['senderId'] == _firebaseAuth.currentUser!.uid
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            // Text(data['senderEmail']),
            // const SizedBox(height: 5),
            ChatBubble(
              message: data['message'],
              decoration: decoration,
            )
          ]),
    );
  }

  // build message input
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          // text field
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hintText: "Enter message",
              obscureText: false,
            ),
          ),

          // send button
          IconButton(
            onPressed: sendMessage,
            icon: const Icon(
              Icons.arrow_upward_rounded,
              size: 40,
            ),
          )
        ],
      ),
    );
  }
}
