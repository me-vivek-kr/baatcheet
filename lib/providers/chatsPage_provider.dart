import 'dart:async';
//Packages
import 'package:baatcheet/models/chat_message.dart';
import 'package:baatcheet/models/chat_user.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//Services
import 'package:baatcheet/services/database_service.dart';
//Models
import 'package:baatcheet/models/chat.dart';
//Providers
import 'package:baatcheet/providers/authentication_provider.dart';

class ChatsPageProvider extends ChangeNotifier {
  final AuthenticationProvider _auth;

  late final DatabaseService _db;

  List<Chat>? chats;

  StreamSubscription? _chatStream;

  ChatsPageProvider(this._auth) {
    _db = GetIt.instance.get<DatabaseService>();
    getChats();
  }

  @override
  void dispose() {
    _chatStream?.cancel(); // Safely cancel the stream if initialized
    super.dispose();
  }

  void getChats() async {
    try {
      _chatStream = _db.getChatsForUser(_auth.user.uid).listen(
        (_snapshot) async {
          chats = await Future.wait(
            _snapshot.docs.map(
              (d) async {
                Map<String, dynamic> _chatData =
                    d.data() as Map<String, dynamic>;

                // Get User in Chat
                List<ChatUser> _members = [];

                for (var uid in _chatData["members"]) {
                  DocumentSnapshot _userSnapshot = await _db.getUser(uid);
                  Map<String, dynamic> _userData =
                      _userSnapshot.data() as Map<String, dynamic>;
                  _userData["uid"] = _userSnapshot.id;
                  _members.add(ChatUser.fromJSON(_userData));
                }

                // Get Last Message for Chat
                List<ChatMessage> _messages = [];
                QuerySnapshot _chatMessage =
                    await _db.getLastMessageForChat(d.id);
                if (_chatMessage.docs.isNotEmpty) {
                  Map<String, dynamic> _messageData =
                      _chatMessage.docs.first.data()! as Map<String, dynamic>;
                  ChatMessage _message = ChatMessage.fromJSON(_messageData);
                  _messages.add(_message);
                }

                // Return Chat Instance
                return Chat(
                  uid: d.id,
                  currentUserUid: _auth.user.uid,
                  members: _members,
                  messages: _messages,
                  activity: _chatData["is_activity"],
                  group: _chatData["is_group"],
                );
              },
            ).toList(),
          );
          notifyListeners();
        },
      );
    } catch (e) {
      print("Error getting Chats");
      print(e);
    }
  }
}
