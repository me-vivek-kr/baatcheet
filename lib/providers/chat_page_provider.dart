// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get_it/get_it.dart';

import 'package:baatcheet/models/chat_message.dart';
import 'package:baatcheet/providers/authentication_provider.dart';
import 'package:baatcheet/services/cloud_storage_service.dart';
import 'package:baatcheet/services/database_service.dart';
import 'package:baatcheet/services/media_service.dart';
import 'package:baatcheet/services/navigation_service.dart';

class ChatPageProvider extends ChangeNotifier {
  late DatabaseService _db;
  late CloudStorageService _storage;
  late MediaService _media;
  late NavigationService _navigation;

  AuthenticationProvider _auth;
  ScrollController _messageListViewController;

  String _chatId;
  List<ChatMessage>? messages;

  late StreamSubscription _messagesStream;
  late StreamSubscription _keyboardVisibilityStream;
  late KeyboardVisibilityController _keyboardVisibilityController;

  String? _message;

  String get message {
    return message;
  }

  void set message(String value) {
    _message = value;
  }

  ChatPageProvider({
    required String chatId,
    required AuthenticationProvider auth,
    required ScrollController messageListViewController,
  })  : _chatId = chatId,
        _auth = auth,
        _messageListViewController = messageListViewController {
    _db = GetIt.instance.get<DatabaseService>();
    _storage = GetIt.instance.get<CloudStorageService>();
    _media = GetIt.instance.get<MediaService>();
    _navigation = GetIt.instance.get<NavigationService>();
    _keyboardVisibilityController = KeyboardVisibilityController();
    listenToMessage();
    listenToKeyboardChanges();
  }

  @override
  void dispose() {
    _messagesStream.cancel();
    super.dispose();
  }

  void listenToMessage() {
    try {
      _messagesStream = _db.streamMessageForChat(_chatId).listen(
        (_snapshot) {
          List<ChatMessage> _messages = _snapshot.docs.map(
            (_m) {
              Map<String, dynamic> _messageData =
                  _m.data() as Map<String, dynamic>;
              return ChatMessage.fromJSON(_messageData);
            },
          ).toList();
          messages = _messages;
          notifyListeners();
          WidgetsBinding.instance.addPostFrameCallback(
            (_) {
              if (_messageListViewController.hasClients) {
                _messageListViewController.jumpTo(
                    _messageListViewController.position.maxScrollExtent);
              }
            },
          );
        },
      );
    } catch (e) {
      print("Getting Error Messages:");
      print(e);
    }
  }

  void listenToKeyboardChanges() {
    _keyboardVisibilityStream = _keyboardVisibilityController.onChange.listen(
      (event) {
        _db.updateChatData(_chatId, {"is_activity": event});
      },
    );
  }

  void sendTextMessage() {
    if (_message != null) {
      ChatMessage _messageToSend = ChatMessage(
        content: _message!,
        type: MessageType.TEXT,
        senderID: _auth.user.uid,
        sentTime: DateTime.now(),
      );
      _db.addMessageToChat(_chatId, _messageToSend);
    }
  }

  void sendImageMessage() async {
    try {
      PlatformFile? _file = await _media.pickImageFromLibrary();
      if (_file != null) {
        String? _downloadURL = await _storage.saveChatImagetoStorage(
            _chatId, _auth.user.uid, _file);
        ChatMessage _messageToSend = ChatMessage(
          content: _downloadURL!,
          type: MessageType.IMAGE,
          senderID: _auth.user.uid,
          sentTime: DateTime.now(),
        );
        _db.addMessageToChat(_chatId, _messageToSend);
      }
    } catch (e) {
      print("Error Sending Image Message:");
      print(e);
    }
  }

  void deleteChat() {
    goBack();
    _db.deleteChat(_chatId);
  }

  void goBack() {
    _navigation.goBack();
  }
}
