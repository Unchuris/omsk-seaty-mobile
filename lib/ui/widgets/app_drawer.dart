import 'package:flutter/material.dart';
import 'package:omsk_seaty_mobile/app_localizations.dart';
import 'package:omsk_seaty_mobile/ui/pages/profile/model/ui_profile.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  var profile = UiProfile(
      'Elon', 'Musk', 'elool@gmail.com', 'https://picsum.photos/250?image=9');

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Drawer(
        child: ListView(
          children: <Widget>[
            _createHeader(
                name: "${profile.firstName} ${profile.middleName}",
                email: profile.email,
                imageUrl: profile.imageUrl,
                onTap: () {
                  Navigator.pushNamed(context, '/profile', arguments: profile);
                }),
            _createDrawerItem(
                icon: Icons.star,
                text: AppLocalizations.of(context).translate('string_starred')),
            Divider(),
            ListTile(
              title: Text(
                  AppLocalizations.of(context).translate('string_settings')),
            ),
            ListTile(
              title:
                  Text(AppLocalizations.of(context).translate('string_help')),
            ),
            ListTile(
              title:
                  Text(AppLocalizations.of(context).translate('string_about')),
            )
          ],
        ),
      ),
    );
  }
}

Widget _createHeader(
    {String name, String email, String imageUrl, GestureTapCallback onTap}) {
  return UserAccountsDrawerHeader(
    accountName: Text(name),
    accountEmail: Text(email),
    onDetailsPressed: onTap,
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
