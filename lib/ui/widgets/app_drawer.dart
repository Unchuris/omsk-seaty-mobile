import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omsk_seaty_mobile/app_localizations.dart';
import 'package:omsk_seaty_mobile/blocs/authentication/authentication_bloc.dart';
import 'package:omsk_seaty_mobile/data/models/bench_light.dart';
import 'package:omsk_seaty_mobile/data/models/user.dart';

import 'package:flutter_svg/svg.dart';

import 'package:omsk_seaty_mobile/ui/pages/favorites/favorites.dart';
import 'package:omsk_seaty_mobile/ui/utils/theme_change_bloc.dart';
import 'package:omsk_seaty_mobile/ui/utils/theme_change_event.dart';
import 'package:omsk_seaty_mobile/ui/utils/theme_change_state.dart';

class AppDrawer extends StatefulWidget {
  final List<BenchLight> markers;

  AppDrawer(this.markers);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Drawer(
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
                icon: SvgPicture.asset("assets/myBench.svg"),
                text: AppLocalizations.of(context)
                    .translate('string_my_benches')),
            _createDrawerItem(
                icon: SvgPicture.asset("assets/favorites.svg"),
                text:
                    AppLocalizations.of(context).translate('string_favorites'),
                onTap: () {
                  Navigator.pushNamed(context, FavoritesPage.routeName,
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
            BlocBuilder<ThemeChangeBloc, ThemeChangeState>(
              builder: (context, state) {
                return Switch(
                      value: state.themeState.isLightMode,
                      onChanged: (value) =>
                          BlocProvider.of<ThemeChangeBloc>(context)
                              .add(OnThemeChangedEvent(value)));
              },
            )
          ],
        ),
      ),
    );
  }
}

Widget _createHeaderWithUser(User user, BuildContext context) {
  return UserAccountsDrawerHeader(
      accountName:
          Text(user.displayName, style: Theme.of(context).textTheme.bodyText1),
      accountEmail: Text(
        user.email,
        style: Theme.of(context).textTheme.bodyText1,
      ),
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

Widget _createDrawerItem({Widget icon, String text, GestureTapCallback onTap}) {
  return ListTile(
    contentPadding: EdgeInsets.only(left: 8),
    title: Align(alignment: Alignment(-1.2, 0), child: Text(text)),
    leading: icon,
    onTap: onTap,
  );
}
