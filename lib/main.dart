import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ycss/constants/onboarding_contents.dart';
import 'package:ycss/constants/string_constants.dart';
import 'package:ycss/widgets/build_dot.dart';
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
  int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              onPageChanged: (int index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemCount: contents.length,
              itemBuilder: (_, i) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Column(
                          children: [
                            Lottie.asset(contents[i].image),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(contents.length, (index) {
                return buildDot(index, currentIndex,
                    context); // Customize this container as needed
              }),
            ),
          ),
          Container(
            height: 60,
            margin: EdgeInsets.all(40),
            width: double.infinity,
            child: TextButton(
              child: Text(
                currentIndex != contents.length - 1
                    ? "Continue"
                    : "Let's Get Started",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                if (currentIndex == contents.length - 1) {
                } else {
                  _controller.nextPage(
                      duration: Duration(microseconds: 1000),
                      curve: Curves.bounceIn);
                }
              },
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
