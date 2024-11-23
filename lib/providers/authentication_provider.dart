import 'package:baatcheet/models/chat_user.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

//Services
import 'package:baatcheet/services/navigation_service.dart';
import 'package:baatcheet/services/database_service.dart';

class AuthenticationProvider extends ChangeNotifier {
  late final FirebaseAuth _auth;
  late final NavigationService _navigationService;
  late final DatabaseService _databaseService;

  late ChatUser user;

  AuthenticationProvider() {
    _auth = FirebaseAuth.instance;
    _navigationService = GetIt.instance.get<NavigationService>();
    _databaseService = GetIt.instance.get<DatabaseService>();

    _auth.authStateChanges().listen((_user) async {
      if (_user != null) {
        try {
          // Update the last seen time in Firestore
          await _databaseService.updateUserLastSeenTime(_user.uid);

          // Fetch user details from Firestore
          final _snapshot = await _databaseService.getUser(_user.uid);

          if (_snapshot.exists && _snapshot.data() != null) {
            Map<String, dynamic> _userData =
                _snapshot.data()! as Map<String, dynamic>;

            // Create ChatUser object
            user = ChatUser.fromJSON({
              "uid": _user.uid,
              "name": _userData["name"],
              "email": _userData["email"],
              "image": _userData["image"],
              "lastActive": _userData["lastActive"],
            });

            // Navigate to home screen
            _navigationService.removeAndNavigateToRoute('/home');
          } else {
            print("User document does not exist or has no data.");
          }
        } catch (e) {
          // Handle any errors
          print("Error handling authentication state: $e");
        }
      } else {
        _navigationService.removeAndNavigateToRoute('/login');
      }
    });
  }

  Future<void> loginUsingEmailAndPassword(
      String _email, String _password) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: _email, password: _password);
    } on FirebaseAuthException {
      print("Error logging user into Firebase");
    } catch (e) {
      print(e);
    }
  }
}
