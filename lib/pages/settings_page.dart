import 'package:broomball_app/pages/about_page.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SettingsPageState();
  }
}

class SettingsPageState extends State<SettingsPage> {
  bool darkModeSwitchChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Settings"),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.brightness_4),
            title: Text("Night Mode"),
            trailing: Switch(
              activeColor: Theme.of(context).accentColor,
              value: Theme.of(context).brightness == Brightness.dark,
              onChanged: (bool value) {
                setState(() {
                  darkModeSwitchChecked = value;
                  DynamicTheme.of(context).setBrightness(Theme.of(context).brightness == Brightness.dark ? Brightness.light : Brightness.dark);
                });
              },
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.info),
            title: Text("About"),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return AboutPage();
                })
              );
            },
          )
        ],
      ),
    );
  }
}
