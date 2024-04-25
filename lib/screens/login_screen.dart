import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ycss/constants/string_constants.dart';
import 'package:ycss/widgets/user_password_text_field.dart';
import 'package:ycss/widgets/user_text_field.dart';

import '../firebase_services/firebase_utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

final userTextEditingController = TextEditingController();
final passwordTextEditingController = TextEditingController();

class _LoginPageState extends State<LoginPage> {
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
                Container(
                  width: 300,
                  height: 60,
                  child: TextButton(
                    child: Text(
                      LOGIN,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    onPressed: () => signUserIn(userTextEditingController.text,
                        passwordTextEditingController.text),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.deepOrange),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                ),

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
