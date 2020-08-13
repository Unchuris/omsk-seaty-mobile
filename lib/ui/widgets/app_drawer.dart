import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omsk_seaty_mobile/app_localizations.dart';
import 'package:omsk_seaty_mobile/blocs/authentication/authentication_bloc.dart';
import 'package:omsk_seaty_mobile/data/models/user.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return _createDrawer(context);
  }
}

Widget _createDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      children: <Widget>[
        BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is AuthenticationSuccess)
              return _createHeaderWithUser(state.user, context);
            return _createHeaderWitoutUser(context);
          },
        ),
        _createDrawerItem(
            icon: Icons.star,
            text: AppLocalizations.of(context).translate('string_starred')),
        Divider(),
        ListTile(
          title:
              Text(AppLocalizations.of(context).translate('string_settings')),
        ),
        ListTile(
          title: Text(AppLocalizations.of(context).translate('string_help')),
        ),
        ListTile(
          title: Text(AppLocalizations.of(context).translate('string_about')),
        )
      ],
    ),
  );
}

Widget _createHeaderWithUser(User user, BuildContext context) {
  return UserAccountsDrawerHeader(
      accountName: Text(user.displayName),
      accountEmail: Text(user.email),
      onDetailsPressed: () {
        Navigator.pushNamed(context, '/profile', arguments: user);
      },
      currentAccountPicture: Hero(
        tag: 'avatar',
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: user.photoUrl,
          ),
        ),
      ));
}

Widget _createHeaderWitoutUser(BuildContext context) {
  return UserAccountsDrawerHeader(
    accountName: Text('Not Auth'),
    accountEmail: Text('Not Auth'),
    onDetailsPressed: () => Navigator.pushReplacementNamed(context, '/login'),
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
