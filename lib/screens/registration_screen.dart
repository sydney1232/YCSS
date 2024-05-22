import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ycss/constants/color_palette.dart';
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

final userEmailTextEditingController = TextEditingController();
final userNameTextEditingController = TextEditingController();
final passwordTextEditingController = TextEditingController();
final confirmPasswordTextEditingController = TextEditingController();
final DialogServices dialogServices = DialogServices();

class _RegistrationPageState extends State<RegistrationPage> {
  @override
  void initState() {
    userEmailTextEditingController.text = '';
    userNameTextEditingController.text = '';
    passwordTextEditingController.text = '';
    confirmPasswordTextEditingController.text = '';
    super.initState();
    // Your initialization tasks go here
    // This function will be called when the widget is inserted into the widget tree.
  }

  bool isRegistrationFieldValid() {
    if (userNameTextEditingController.text == '' ||
        userEmailTextEditingController.text == '' ||
        passwordTextEditingController.text == '') {
      dialogServices.missingTextFields(context);
      return false;
    }
    if (passwordTextEditingController.text !=
        confirmPasswordTextEditingController.text) {
      dialogServices.passwordDoesNotMatch(context);
      return false;
    } else {
      return true;
    }
  }

  signUserUp(String email, String password, String username) async {
    if (isRegistrationFieldValid()) {
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

        //Register Email and Password
        UserCredential result =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        //Register Display Name
        User? user = result.user;
        user?.updateDisplayName(username);

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
  }

  void navigateToDashboard(bool success) {
    if (success) {
      Navigator.pushReplacementNamed(context, kDashboardPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blue,
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
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: lightPink),
                        ),
                        const SizedBox(height: 70),
                        Image.asset("assets/run.png"),
                      ],
                    )),

                UserNameTextField(
                  controller: userEmailTextEditingController,
                  hintText: EMAIL,
                ),

                UserNameTextField(
                  controller: userNameTextEditingController,
                  hintText: USERNAME,
                ),

                PasswordTextField(
                  controller: passwordTextEditingController,
                ),

                PasswordTextField(
                  controller: confirmPasswordTextEditingController,
                  hintText: "Confirm Password",
                ),

                const SizedBox(height: 30),

                //Login
                Container(
                  width: 300,
                  height: 60,
                  child: TextButton(
                    onPressed: () => signUserUp(
                        userEmailTextEditingController.text,
                        passwordTextEditingController.text,
                        userNameTextEditingController.text),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(lightPink),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    child: const Text(
                      REGISTER,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'MaidenCrimes'),
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
