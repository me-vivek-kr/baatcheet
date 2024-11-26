import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CloudStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  CloudStorageService();

  /// Saves the user's profile image to Firebase Storage
  Future<String?> saveUserImageToStorage(String uid, PlatformFile file) async {
    try {
      final Reference ref =
          _storage.ref().child('images/users/$uid/profile.${file.extension}');
      print("Uploading file to: ${ref.fullPath}");

      final UploadTask task = ref.putFile(File(file.path!));

      final String downloadURL =
          await task.then((result) => result.ref.getDownloadURL());
      print("Profile image uploaded successfully. URL: $downloadURL");
      return downloadURL;
    } catch (e) {
      print("Error uploading profile image: $e");
      return null;
    }
  }

  /// Saves a chat image to Firebase Storage
  Future<String?> saveChatImagetoStorage(
      String chatID, String userID, PlatformFile file) async {
    try {
      final String timestamp =
          Timestamp.now().millisecondsSinceEpoch.toString();
      final Reference ref = _storage
          .ref()
          .child('images/chats/$chatID/${userID}_$timestamp.${file.extension}');
      final UploadTask task = ref.putFile(File(file.path!));

      final String downloadURL =
          await task.then((result) => result.ref.getDownloadURL());
      print("Chat image uploaded successfully. URL: $downloadURL");
      return downloadURL;
    } catch (e) {
      print("Error uploading chat image: $e");
      return null;
    }
  }
}
