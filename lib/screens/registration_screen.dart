import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ycss/widgets/login_register_dialogs.dart';

import '../constants/key_navigation.dart';
import '../constants/string_constants.dart';
import '../widgets/user_password_text_field.dart';
import '../widgets/user_text_field.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

final userTextEditingController = TextEditingController();
final passwordTextEditingController = TextEditingController();
final DialogServices dialogServices = DialogServices();

class _RegistrationPageState extends State<RegistrationPage> {
  signUserUp(String email, String password) async {
    try {
      showDialog(
          context: context,
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.pink,
              ),
            );
          });
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.pop(context);
      dialogServices.registrationSuccessful(
          context, email, () => navigateToDashboard(true));
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'email-already-in-use') {
        //Handle password to weak
        dialogServices.userAlreadyExisting(context);
      } else if (e.code == 'weak-password') {
        //Handle email already exists
        dialogServices.weakPassword(context);
      } else {
        dialogServices.invalidInput(context);
      }
    } catch (e) {
      print(e);
    }
  }

  void navigateToDashboard(bool success) {
    if (success) {
      Navigator.pushReplacementNamed(context, kDashboardPage);
    }
  }

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
