import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:baatcheet/widgets/rounded_image.dart';
import 'package:baatcheet/services/media_service.dart';
import 'package:baatcheet/widgets/custom_input_field.dart';
import 'package:baatcheet/providers/authentication_provider.dart';
import 'package:baatcheet/services/cloud_storage_service.dart';
import 'package:baatcheet/services/database_service.dart';
import 'package:baatcheet/services/navigation_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late double deviceHeight;
  late double deviceWidth;

  late AuthenticationProvider _auth;
  late DatabaseService _db;
  late CloudStorageService _cloudStorage;
  late NavigationService _navigation;

  String? _name;
  String? _email;
  String? _password;

  PlatformFile? _profileImage;

  final _registerFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthenticationProvider>(context);
    _db = GetIt.instance<DatabaseService>();
    _cloudStorage = GetIt.instance<CloudStorageService>();
    _navigation = GetIt.instance<NavigationService>();
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: deviceWidth * 0.03,
          vertical: deviceHeight * 0.02,
        ),
        height: deviceHeight * 0.98,
        width: deviceWidth * 0.97,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            profileImageField(),
            SizedBox(height: deviceHeight * 0.05),
            registerForm(),
            SizedBox(height: deviceHeight * 0.05),
            registerButton(),
          ],
        ),
      ),
    );
  }

  Widget profileImageField() {
    return GestureDetector(
      onTap: () {
        GetIt.instance.get<MediaService>().pickImageFromLibrary().then(
          (file) {
            setState(() {
              _profileImage = file;
            });
          },
        );
      },
      child: () {
        if (_profileImage != null) {
          return RoundedImageFile(
            image: _profileImage!,
            size: deviceHeight * 0.15,
          );
        } else {
          return RoundedImageNetwork(
            imagePath:
                'https://img.freepik.com/free-psd/3d-illustration-human-avatar-profile_23-2150671116.jpg',
            size: deviceHeight * 0.15,
          );
        }
      }(),
    );
  }

  Widget registerForm() {
    return Container(
      height: deviceHeight * 0.35,
      child: Form(
        key: _registerFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextFormField(
              onSaved: (_value) {
                setState(() {
                  _name = _value;
                });
              },
              regExp: r".{8,}",
              hintText: "Name",
              obscureText: false,
            ),
            CustomTextFormField(
              onSaved: (_value) {
                setState(() {
                  _email = _value;
                });
              },
              regExp:
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
              hintText: "Email",
              obscureText: false,
            ),
            CustomTextFormField(
              onSaved: (_value) {
                setState(() {
                  _password = _value;
                });
              },
              regExp: r".{8,}",
              hintText: "Password",
              obscureText: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget registerButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.blue,
      ),
      child: SizedBox(
        height: deviceHeight * 0.065,
        width: deviceWidth * 0.50,
        child: TextButton(
          onPressed: () async {
            if (_registerFormKey.currentState!.validate() &&
                _profileImage != null) {
              _registerFormKey.currentState!.save();

              String? _uid = await _auth.registerUserUsingEmailAndPassword(
                  _email!, _password!);
              if (_uid == null) {
                return;
              }

              String? _imageURL = await _cloudStorage.saveUserImageToStorage(
                  _uid, _profileImage!);

              await _db.creatUser(_uid, _email!, _name!, _imageURL!);
              await _auth.logout();
              await _auth.loginUsingEmailAndPassword(_email!, _password!);
            }
          },
          child: const Text(
            'Register',
            style: TextStyle(
              fontSize: 22,
              color: Colors.white,
              height: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
