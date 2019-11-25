import 'package:broomball_app/pages/team_page.dart';
import 'package:broomball_app/util/broomballdata.dart';
import 'package:flutter/material.dart';

class TeamsFragment extends StatefulWidget {
  final String year;

  TeamsFragment({@required this.year});

  @override
  State<StatefulWidget> createState() {
    return TeamsFragmentState();
  }
}

class TeamsFragmentState extends State<TeamsFragment> {
  final BroomballWebScraper _broomballWebScraper = BroomballWebScraper();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return CircularProgressIndicator();
            case ConnectionState.done:
              BroomballData broomballData = snapshot.data;

              Map<String, String> teamIDMap = Map();
              List<String> teamNameList = <String>[];

              for (String teamID in broomballData.teams.keys.toList()) {
                teamIDMap[broomballData.teams[teamID]] = teamID;
                teamNameList.add(broomballData.teams[teamID]);
              }
              teamNameList.sort();

              return ListView.separated(
                itemCount: broomballData.teams.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      teamNameList[index],
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return TeamPage(
                            id: teamIDMap[teamNameList[index]],
                          );
                        },
                      ));
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
              );
          }
          return null;
        },
        future: _broomballWebScraper.run(widget.year),
      ),
    );
  }
}
