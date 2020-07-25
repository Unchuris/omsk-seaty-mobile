import 'package:flutter/material.dart';
import 'package:omsk_seaty_mobile/app_localizations.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new SizedBox(
      child: Drawer(
        child: new ListView(
          children: <Widget>[
            _createHeader(
                name: "User",
                email: "user@gmail.com",
                imageUrl: "https://picsum.photos/250?image=9"),
            _createDrawerItem(
                icon: Icons.star,
                text: AppLocalizations.of(context).translate("string_starred")),
            Divider(),
            ListTile(
              title: Text(
                  AppLocalizations.of(context).translate("string_settings")),
            ),
            ListTile(
              title:
                  Text(AppLocalizations.of(context).translate("string_help")),
            ),
            ListTile(
              title:
                  Text(AppLocalizations.of(context).translate("string_about")),
            )
          ],
        ),
      ),
    );
  }
}

Widget _createHeader({String name, String email, String imageUrl}) {
  return UserAccountsDrawerHeader(
    accountName: Text(name),
    accountEmail: Text(email),
    currentAccountPicture:
        CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
  );
}

Widget _createDrawerItem(
    {IconData icon, String text, GestureTapCallback onTap}) {
  return ListTile(
    title: Text(text),
    leading: Icon(icon),
    onTap: onTap,
  );
}
