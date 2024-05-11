import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class DialogServices {
  void userNotFound(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.topSlide,
      showCloseIcon: true,
      title: "User not found",
      desc: "Credential does not match to any user.",
      btnOkOnPress: () {},
      btnOkColor: Colors.yellow,
      btnOkText: "Okay",
    ).show();
  }

  void missingTextFields(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.topSlide,
      showCloseIcon: true,
      title: "Missing Fields",
      desc: "Make sure to Input all missing fields",
      btnOkOnPress: () {},
      btnOkColor: Colors.yellow,
      btnOkText: "Okay",
    ).show();
  }

  void passwordDoesNotMatch(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.topSlide,
      showCloseIcon: true,
      title: "Password does not match",
      desc: "Make sure password matches the confirmed password",
      btnOkOnPress: () {},
      btnOkColor: Colors.red,
      btnOkText: "Okay",
    ).show();
  }

  void wrongPassword(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.topSlide,
      showCloseIcon: true,
      title: "Invalid credential",
      desc: "Password is Incorrect.",
      btnOkOnPress: () {},
      btnOkColor: Colors.red,
      btnOkText: "Okay",
    ).show();
  }

  void invalidInput(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.topSlide,
      showCloseIcon: true,
      title: "Invalid Input",
      desc: "Please make sure to Input valid credentials.",
      btnOkOnPress: () {},
      btnOkColor: Colors.red,
      btnOkText: "Okay",
    ).show();
  }

  void weakPassword(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.topSlide,
      showCloseIcon: true,
      title: "Weak Password",
      desc: "Make sure to have a strong password.",
      btnOkOnPress: () {},
      btnOkColor: Colors.yellow,
      btnOkText: "Okay",
    ).show();
  }

  void userAlreadyExisting(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.topSlide,
      showCloseIcon: true,
      title: "User already exists",
      desc:
          "User already exists with this username. Please try a different username.",
      btnOkOnPress: () {},
      btnOkColor: Colors.yellow,
      btnOkText: "Okay",
    ).show();
  }

  void registrationSuccessful(
      BuildContext context, String username, Function() onPress) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.topSlide,
      showCloseIcon: true,
      title: "Registration Successful!",
      desc: "Registered as $username. Hi and Welcome to the committee!",
      btnOkOnPress: onPress,
      btnOkColor: Colors.yellow,
      btnOkText: "Okay",
    ).show();
  }
}
