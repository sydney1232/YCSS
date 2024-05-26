import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ycss/constants/color_palette.dart';
import 'package:ycss/constants/key_navigation.dart';
import 'package:ycss/screens/capture_the_flag_screen.dart';
import 'package:ycss/screens/messaging_screen.dart';
import 'package:ycss/screens/score_log_screen.dart';
import 'package:ycss/screens/team_headtohead_screen.dart';
import 'package:ycss/screens/team_ranking_screen.dart';
import 'package:ycss/screens/teams_screen.dart';
import 'package:ycss/widgets/item_tile.dart';

import '../constants/string_constants.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  userSignOut() {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, kLoginPage);
  }

  @override
  Widget build(BuildContext context) {
    String userName = currentUser.displayName ?? 'User';
    bool isAdmin() {
      return adminList
          .where((admin) => admin.toString() == currentUser.email)
          .isNotEmpty;
    }

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            decoration: BoxDecoration(
              color: blue,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 50),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 30),
                  title: Text(
                    "Hi, $userName!",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: lightPink, fontFamily: 'MaidenCrimes'),
                  ),
                  subtitle: Text(
                    "Welcome back",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: yellowOrange, fontFamily: 'TheRift'),
                  ),
                  trailing: IconButton(
                    onPressed: userSignOut,
                    icon: Icon(
                      size: 30,
                      Icons.exit_to_app,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
          Container(
            color: blue,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(100),
                ),
              ),
              child: Column(children: [
                const SizedBox(
                  height: 25,
                ),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  crossAxisSpacing: 40,
                  mainAxisSpacing: 30,
                  children: [
                    ItemTile(
                      name: "Update Score",
                      backgroundcolor: blue,
                      icon: Icons.scoreboard,
                      onPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const TeamScreen()));
                      },
                    ),
                    ItemTile(
                      name: "Capture the Flag",
                      backgroundcolor: lightPink,
                      icon: Icons.flag,
                      onPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CaptureFlagPage()));
                      },
                    ),
                    ItemTile(
                      name: "Head to Head",
                      backgroundcolor: lightPink,
                      icon: Icons.connect_without_contact,
                      onPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HeadToHeadPage()));
                      },
                    ),
                    if (isAdmin())
                      ItemTile(
                        name: "Ranking",
                        backgroundcolor: yellowOrange,
                        icon: Icons.bar_chart,
                        onPress: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const TeamRanking()));
                        },
                      ),
                    if (isAdmin())
                      ItemTile(
                        name: "Score Logs",
                        backgroundcolor: purple,
                        icon: Icons.history,
                        onPress: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ScoreLogsScreen()));
                        },
                      ),
                    ItemTile(
                        name: "Messaging",
                        backgroundcolor: blue,
                        icon: Icons.message,
                        iconColor: lightPink,
                        onPress: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MessagingPage()));
                        }),
                  ],
                ),
              ]),
            ),
          )
        ],
      ),
    );
  }
}
