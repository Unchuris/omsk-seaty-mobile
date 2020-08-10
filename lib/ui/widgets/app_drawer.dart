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
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is AuthenticationSuccess)
          return _createDrawer(state.user, context);
      },
    );
  }
}

Widget _createDrawer(User user, BuildContext context) {
  return Drawer(
    child: ListView(
      children: <Widget>[
        _createHeader(user, context),
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

Widget _createHeader(User user, BuildContext context) {
  return UserAccountsDrawerHeader(
      accountName: Text(user.displayName),
      accountEmail: Text(user.email),
      onDetailsPressed: () {
        Navigator.pushNamed(context, '/profile', arguments: user);
      },
      currentAccountPicture: Hero(
        tag: 'avatar',
        child: CircleAvatar(backgroundImage: NetworkImage(user.photoUrl)),
      ));
}

Widget _createDrawerItem(
    {IconData icon, String text, GestureTapCallback onTap}) {
  return ListTile(
    title: Text(text),
    leading: Icon(icon),
    onTap: onTap,
  );
}
