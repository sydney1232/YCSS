import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/string_constants.dart';
import '../firebase_services/firebase_utils.dart';
import '../widgets/user_password_text_field.dart';
import '../widgets/user_text_field.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

final userTextEditingController = TextEditingController();
final passwordTextEditingController = TextEditingController();

class _RegistrationPageState extends State<RegistrationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                //Sign Up
                Padding(
                    padding: const EdgeInsets.all(80),
                    child: Column(
                      children: [
                        Text(
                          SIGN_UP,
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

                PasswordTextField(
                  controller: passwordTextEditingController,
                  hintText: "Confirm Password",
                ),

                const SizedBox(height: 30),

                //Login
                Container(
                  width: 300,
                  height: 60,
                  child: TextButton(
                    onPressed: () => signUserUp(userTextEditingController.text,
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
                    child: const Text(
                      REGISTER,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),

                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
