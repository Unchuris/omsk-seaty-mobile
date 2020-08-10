import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:omsk_seaty_mobile/app_localizations.dart';
import 'package:omsk_seaty_mobile/data/models/map_marker.dart';
import 'package:omsk_seaty_mobile/ui/pages/favorites/favorites.dart';
import 'package:omsk_seaty_mobile/ui/pages/profile/model/ui_profile.dart';

class AppDrawer extends StatefulWidget {
  final List<MapMarker> markers;
  AppDrawer(this.markers);
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
                name: '${profile.firstName} ${profile.middleName}',
                email: profile.email,
                imageUrl: profile.imageUrl,
                onTap: () {
                  Navigator.pushNamed(context, '/profile', arguments: profile);
                }),
            _createDrawerItem(
                icon: SvgPicture.asset("assets/myBench.svg"),
                text: AppLocalizations.of(context)
                    .translate('string_my_benches')),
            _createDrawerItem(
                icon: SvgPicture.asset("assets/favorites.svg"),
                text:
                    AppLocalizations.of(context).translate('string_favorites'),
                onTap: () {
                  Navigator.pushNamed(context, FavoritesPage.roateName,
                      arguments: widget.markers);
                }),
            _createDrawerItem(
                icon: SvgPicture.asset("assets/topBenches.svg"),
                text: AppLocalizations.of(context)
                    .translate('string_top_benches')),
            _createDrawerItem(
                icon: SvgPicture.asset("assets/topUsers.svg"),
                text:
                    AppLocalizations.of(context).translate('string_top_users')),
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
      currentAccountPicture: Hero(
        tag: 'avatar',
        child: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
      ));
}

Widget _createDrawerItem({Widget icon, String text, GestureTapCallback onTap}) {
  return ListTile(
    contentPadding: EdgeInsets.only(left: 8),
    title: Align(alignment: Alignment(-1.2, 0), child: Text(text)),
    leading: icon,
    onTap: onTap,
  );
}
