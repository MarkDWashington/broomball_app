import 'dart:convert';

import 'package:broomball_app/fragments/conference_fragment.dart';
import 'package:broomball_app/fragments/players_fragment.dart';
import 'package:broomball_app/fragments/teams_fragment.dart';
import 'package:broomball_app/pages/about_page.dart';
import 'package:broomball_app/pages/settings_page.dart';
import 'package:broomball_app/util/broomballdata.dart';
import 'package:broomball_app/util/util.dart';
import 'package:flutter/material.dart';

/// Class that contains fragments for Conferences, Teams, and Players
/// as well as a navigation drawer

class MainPage extends StatefulWidget {
  final drawerItems = <DrawerItem>[
    new DrawerItem("Conferences", Icons.assignment),
    new DrawerItem("Teams", Icons.people),
    new DrawerItem("Players", Icons.person),
  ];

  @override
  State<StatefulWidget> createState() {
    return new MainPageState();
  }
}

class MainPageState extends State<MainPage> {
  int _drawerIndex = 0;
  String _currentYear;

  List<String> _yearList = <String>[];

  BroomballData broomballData = BroomballData();
  Map jsonData;

  @override
  void initState() {
    super.initState();
    broomballData.fetch().whenComplete(() {
      _onJsonDataLoaded();
    });
  }

  Widget _getDrawerItemFragment(int index) {
    switch (index) {
      case 0:
        return new ConferenceFragment(_currentYear);
      case 1:
        return new TeamsFragment();
      case 2:
        return new PlayersFragment();
      default:
        return new Text("Error");
    }
  }

  void _onSelectDrawerItem(int index) {
    setState(() => _drawerIndex = index);
    Navigator.of(context).pop();
  }

  void _onJsonDataLoaded() {
    // Set current year and add items to dropdown
    jsonData = broomballData.jsonData;

    List<String> yearList = jsonData["years"].keys.toList();
    yearList.sort((a, b) => a.compareTo(b));
    yearList = yearList.reversed.toList();
    print(yearList);

    setState(() {
      _currentYear = DateTime.now().year.toString();
      _yearList = yearList;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerListTiles = [];

    for (int i = 0; i < widget.drawerItems.length; i++) {
      DrawerItem drawerItem = widget.drawerItems[i];

      drawerListTiles.add(ListTile(
        leading: Icon(drawerItem.icon),
        title: Text(drawerItem.text),
        selected: i == _drawerIndex,
        onTap: () => _onSelectDrawerItem(i),
      ));
    }

    drawerListTiles.add(Divider());
    drawerListTiles.add(ListTile(
        leading: Icon(Icons.settings),
        title: Text("Settings"),
        onTap: () {
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => SettingsPage()));
        }));

    drawerListTiles.add(ListTile(
        leading: Icon(Icons.info),
        title: Text("About"),
        onTap: () {
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => AboutPage()));
        }));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.drawerItems[_drawerIndex].text),
        actions: <Widget>[
          DropdownButtonHideUnderline(
            child: DropdownButton(
              value: _yearList.length > 0 ? _currentYear : null,
              items: _yearList.map((String year) => DropdownMenuItem(
                child: Text(year),
                value: year,
              )).toList(),
              onChanged: (String year) => this.setState(() => this._currentYear = year),
            )
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              broomballData.fetch().whenComplete(() => _onJsonDataLoaded());
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: drawerListTiles,
        ),
      ),
      body: _getDrawerItemFragment(_drawerIndex),
    );
  }
}
