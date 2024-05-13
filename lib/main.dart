import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:ycss/constants/color_palette.dart';
import 'package:ycss/constants/key_navigation.dart';
import 'package:ycss/constants/onboarding_contents.dart';
import 'package:ycss/firebase_options.dart';
import 'package:ycss/firebase_services/AuthPage.dart';
import 'package:ycss/screens/dashboard_screen.dart';
import 'package:ycss/screens/login_screen.dart';
import 'package:ycss/screens/registration_screen.dart';
import 'package:ycss/screens/team_ranking_screen.dart';
import 'package:ycss/screens/teams_screen.dart';
import 'package:ycss/widgets/build_dot.dart';
import 'package:ycss/widgets/text_widget_header_1.dart';
import 'package:ycss/widgets/text_widget_header_2.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AuthPage(),
    routes: {
      kWelcomePage: (context) => WelcomePage(),
      kDashboardPage: (context) => DashboardPage(),
      kLoginPage: (context) => LoginPage(),
      kRegistrationPage: (context) => RegistrationPage(),
      kTeamScreen: (context) => TeamScreen(),
      kTeamRanking: (context) => TeamRanking(),
    },
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
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          children: [
                            Lottie.asset(
                              contents[i].image,
                              height: 250,
                              width: 250,
                            ),
                            Header1(text: contents[i].header),
                            SizedBox(height: 20),
                            Header2(text: contents[i].desc),
                          ],
                        )),
                  ],
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(contents.length, (index) {
              return buildDot(index, currentIndex,
                  context); // Customize this container as needed
            }),
          ),
          Container(
            height: 50,
            margin: EdgeInsets.all(40),
            width: double.infinity,
            child: TextButton(
              child: Text(
                currentIndex != contents.length - 1
                    ? "Continue"
                    : "Let's Get Started",
                style: TextStyle(color: white, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                if (currentIndex == contents.length - 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                } else {
                  _controller.nextPage(
                      duration: Duration(microseconds: 1000),
                      curve: Curves.bounceIn);
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(lightPink),
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
