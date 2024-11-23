import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:baatcheet/widgets/custom_input_field.dart';
import 'package:baatcheet/services/navigation_service.dart';
import 'package:baatcheet/providers/authentication_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late double deviceHeight;
  late double deviceWidth;

  late AuthenticationProvider _auth;
  late NavigationService _navigation;

  final _loginFormKey = GlobalKey<FormState>();

  String? _email;
  String? _password;

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    _navigation = GetIt.instance.get<NavigationService>();

    return Scaffold(
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
            _pageTitle(),
            SizedBox(height: deviceHeight * 0.04),
            _loginForm(),
            SizedBox(height: deviceHeight * 0.05),
            _loginButton(),
            SizedBox(height: deviceHeight * 0.02),
            _registerAccountLink(),
          ],
        ),
      ),
    );
  }

  Widget _pageTitle() {
    return Container(
      height: deviceHeight * 0.10,
      child: const Text(
        'BaatCheet',
        style: TextStyle(
          color: Colors.white,
          fontSize: 40,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _loginForm() {
    return Container(
      height: deviceHeight * 0.18,
      child: Form(
        key: _loginFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextFormField(
              onSaved: (value) {
                setState(() {
                  _email = value;
                });
              },
              regExp:
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
              hintText: "Email",
              obscureText: false,
            ),
            CustomTextFormField(
              onSaved: (value) {
                setState(() {
                  _password = value;
                });
              },
              regExp: r".{8,}",
              hintText: "Password",
              obscureText: true,
            )
          ],
        ),
      ),
    );
  }

  Widget _loginButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.blue,
      ),
      child: SizedBox(
        height: deviceHeight * 0.065,
        width: deviceWidth * 0.50,
        child: TextButton(
          onPressed: () {
            if (_loginFormKey.currentState!.validate()) {
              _loginFormKey.currentState!.save();
              _auth.loginUsingEmailAndPassword(_email!, _password!);
            }
          },
          child: const Text(
            'Login',
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

  Widget _registerAccountLink() {
    return GestureDetector(
      onTap: () => _navigation.removeAndNavigateToRoute('/register'),
      child: const Text(
        'Don\'t have an Account ?',
        style: TextStyle(color: Colors.blueAccent),
      ),
    );
  }
}
