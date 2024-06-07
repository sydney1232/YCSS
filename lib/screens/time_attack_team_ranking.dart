import 'package:flutter/material.dart';

import '../constants/color_palette.dart';
import '../constants/globals.dart';
import '../constants/string_constants.dart';

class TimeAttackTeamRanking extends StatefulWidget {
  const TimeAttackTeamRanking({Key? key}) : super(key: key);

  @override
  State<TimeAttackTeamRanking> createState() => _TimeAttackTeamRankingState();
}

class _TimeAttackTeamRankingState extends State<TimeAttackTeamRanking> {
  @override
  Widget build(BuildContext context) {
    // Sort the list by the seconds property
    globalTeamInfoList.sort((a, b) => a.timeInMillis.compareTo(b.timeInMillis));

    int getScore(int index) {
      final scoreMap = {
        1: 100,
        2: 90,
        3: 80,
        4: 70,
        5: 60,
        6: 50,
        7: 40,
        8: 30,
        9: 20,
        10: 100,
      };
      return scoreMap[index] ?? 0;
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Center(
              child: Padding(
                  padding: EdgeInsets.only(top: 80),
                  child: Column(
                    children: [
                      Text(
                        TEAM_TIME_ATTACK_RESULTS,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 21,
                            color: lightPink,
                            fontFamily: 'TheRift'),
                      ),
                      SizedBox(height: 40),
                      Text(
                        TEAM_TIME_ATTACK_RESULTS_ORDER,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: lightPink,
                            fontFamily: 'DIN'),
                      ),
                    ],
                  )),
            ),
            const SizedBox(
              height: 35,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Team Name')),
                  DataColumn(label: Text('Time')),
                  DataColumn(label: Text('Ranking')),
                ],
                rows: List<DataRow>.generate(
                  globalTeamInfoList.length,
                  (index) {
                    var teamInfo = globalTeamInfoList[index];
                    return DataRow(cells: [
                      DataCell(Text(teamInfo.teamName)),
                      DataCell(Text(teamInfo.time)),
                      DataCell(
                        Text('${index + 1} - ${getScore(index + 1)} pts'),
                      ),
                    ]);
                  },
                ),
              ),
            ),
            Container(
              height: 50,
              margin: EdgeInsets.all(40),
              width: 100,
              child: TextButton(
                child: Text(
                  SUBMIT,
                  style: TextStyle(color: white, fontWeight: FontWeight.bold),
                ),
                onPressed: () {},
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
      ),
    );
  }
}
