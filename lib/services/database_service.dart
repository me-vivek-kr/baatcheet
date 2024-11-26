import 'package:cloud_firestore/cloud_firestore.dart';

const String USER_COLLECTION = "Users";
const String CHAT_COLLECTION = "Chats";
const String MESSAGES_COLLECTION = "Messages";

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
  Future<DocumentSnapshot> getUser(String uid) {
    return _db.collection(USER_COLLECTION).doc(uid).get();
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
}
