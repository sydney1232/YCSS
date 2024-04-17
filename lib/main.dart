import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ycss/constants/onboarding_contents.dart';
import 'package:ycss/constants/string_constants.dart';
import 'package:ycss/widgets/text_widget_header_1.dart';
import 'package:ycss/widgets/text_widget_header_2.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: WelcomePage(),
  ));
}

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              itemCount: contents.length,
              itemBuilder: (_, i) {
                return Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Column(
                          children: [
                            Header1(text: contents[i].header),
                            SizedBox(height: 15),
                            Header2(text: contents[i].desc),
                          ],
                        )),
                  ],
                );
              },
            ),
          ),
          Container(
            height: 60,
            margin: EdgeInsets.all(40),
            width: double.infinity,
            child: TextButton(
              child: Text(
                "Next",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {},
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
          )
        ],
      ),
    );
  }
}
