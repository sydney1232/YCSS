import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ycss/constants/string_constants.dart';
import 'package:ycss/widgets/login_button.dart';
import 'package:ycss/widgets/user_password_text_field.dart';
import 'package:ycss/widgets/user_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController userTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                //Sign in
                Padding(
                    padding: const EdgeInsets.all(80),
                    child: Column(
                      children: [
                        Text(
                          SIGN_IN,
                          style: TextStyle(fontSize: 28),
                        ),
                        const SizedBox(height: 70),
                        Icon(
                          Icons.lock,
                          size: 120,
                        ),
                      ],
                    )),

                UserNameTextField(
                  controller: userTextEditingController,
                ),

                PasswordTextField(
                  controller: passwordTextEditingController,
                ),

                const SizedBox(height: 30),

                //Login
                LoginButton(onPress: () {}),

                const SizedBox(height: 50),

                //Dont have account
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    DONT_HAVE_ACCOUNT,
                    style: TextStyle(color: Colors.deepOrange),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    SIGN_UP,
                    style: TextStyle(
                        color: Colors.deepOrange, fontWeight: FontWeight.bold),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
