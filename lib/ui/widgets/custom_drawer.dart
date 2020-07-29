import 'package:flutter/material.dart';
import 'package:omsk_seaty_mobile/ui/pages/map_screen.dart';

class CustomDrawer extends StatelessWidget {
  final String currentPage;
  const CustomDrawer({this.currentPage});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Omsk-seaty Demo'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text(
              'Карта',
              style: this.currentPage == "Карта"
                  ? TextStyle(fontWeight: FontWeight.bold)
                  : TextStyle(fontWeight: FontWeight.normal),
            ),
            onTap: () {
              Navigator.of(context).pop();
              if (this.currentPage == "Карта") return;
              Navigator.pushNamed(context, MapScreen().routeName);
            },
          ),
        ],
      ),
    );
  }
}
