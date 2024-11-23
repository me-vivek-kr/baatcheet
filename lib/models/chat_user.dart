import 'package:cloud_firestore/cloud_firestore.dart';

class ChatUser {
  final String uid;
  final String name;
  final String email;
  final String image;
  late DateTime lastActive;

  ChatUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.image,
    required this.lastActive,
  });

  factory ChatUser.fromJSON(Map<String, dynamic> json) {
    return ChatUser(
      uid: json["uid"] as String,
      name: json["name"] as String,
      email: json["email"] as String,
      image: json["image"] as String,
      lastActive: json["lastActive"] != null
          ? (json["lastActive"] is Timestamp
              ? (json["lastActive"] as Timestamp).toDate()
              : DateTime.parse(json["lastActive"] as String))
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "name": name,
      "email": email,
      "image": image,
      "lastActive": lastActive.toIso8601String(),
    };
  }

  String lastDayActive() {
    return "${lastActive.day}/${lastActive.month}/${lastActive.year}";
  }

  bool wasRecentlyActive() {
    return DateTime.now().difference(lastActive).inHours < 2;
  }
}
