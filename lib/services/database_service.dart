import 'package:baatcheet/models/chat_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const String USER_COLLECTION = "Users";
const String CHAT_COLLECTION = "Chats";
const String MESSAGES_COLLECTION = "messages";

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DatabaseService();

  /// Creates a new user document in Firestore
  Future<void> creatUser(
      String uid, String email, String name, String imageURL) async {
    try {
      await _db.collection(USER_COLLECTION).doc(uid).set({
        "email": email,
        "name": name,
        "last_active": DateTime.now().toUtc(),
        "image": imageURL,
      });
      print("User document created successfully.");
    } catch (e) {
      print("Error creating user document: $e");
      rethrow;
    }
  }

  /// Retrieves user document by UID
  Future<DocumentSnapshot> getUser(String uid, {String? name}) {
    return _db.collection(USER_COLLECTION).doc(uid).get();
  }

  //Retrives all Users by Name
  Future<QuerySnapshot> getUsers({String? name}) {
    Query _query = _db.collection(USER_COLLECTION);
    if (name != null) {
      _query = _query
          .where("name", isGreaterThanOrEqualTo: name)
          .where("name", isLessThanOrEqualTo: name + "z");
    }
    return _query.get();
  }

  Stream<QuerySnapshot> getChatsForUser(String uid) {
    return _db
        .collection(CHAT_COLLECTION)
        .where('members', arrayContains: uid)
        .snapshots();
  }

  Future<QuerySnapshot> getLastMessageForChat(String chatID) {
    return _db
        .collection(CHAT_COLLECTION)
        .doc(chatID)
        .collection(MESSAGES_COLLECTION)
        .orderBy("sent_time", descending: true)
        .limit(1)
        .get();
  }

  //Chat Message Read
  Stream<QuerySnapshot> streamMessageForChat(String chatID) {
    return _db
        .collection(CHAT_COLLECTION)
        .doc(chatID)
        .collection(MESSAGES_COLLECTION)
        .orderBy("sent_time", descending: false)
        .snapshots();
  }

  //Creating Chat Messages
  Future<void> addMessageToChat(String chatID, ChatMessage _message) async {
    try {
      await _db
          .collection(CHAT_COLLECTION)
          .doc(chatID)
          .collection(MESSAGES_COLLECTION)
          .add(_message.toJson());
    } catch (e) {
      print(e);
    }
  }

  //Update Chat Messages
  Future<void> updateChatData(String chatID, Map<String, dynamic> _data) async {
    try {
      await _db.collection(CHAT_COLLECTION).doc(chatID).update(_data);
    } catch (e) {
      print(e);
    }
  }

  /// Updates the user's last seen timestamp
  Future<void> updateUserLastSeenTime(String uid) async {
    try {
      await _db.collection(USER_COLLECTION).doc(uid).update({
        "last_active": DateTime.now().toUtc(),
      });
      print("User last active time updated.");
    } catch (e) {
      print("Error updating user last active time: $e");
    }
  }

  // Delete Message from Chat
  Future<void> deleteChat(String chatID) async {
    try {
      await _db.collection(CHAT_COLLECTION).doc(chatID).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<DocumentReference?> createChat(Map<String, dynamic> data) async {
    try {
      DocumentReference _chat = await _db.collection(CHAT_COLLECTION).add(data);
      return _chat;
    } catch (e) {
      print(e);
    }
  }
}
