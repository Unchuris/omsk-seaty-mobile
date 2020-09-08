import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'package:omsk_seaty_mobile/app_localizations.dart';
import 'package:omsk_seaty_mobile/blocs/authentication/authentication_bloc.dart';
import 'package:omsk_seaty_mobile/data/models/user.dart';
import 'package:omsk_seaty_mobile/ui/pages/favorites/favorites.dart';
import 'package:omsk_seaty_mobile/ui/pages/my_benches/my_benches.dart';
import 'package:omsk_seaty_mobile/ui/pages/top_benches/top_benches.dart';
import 'package:omsk_seaty_mobile/ui/pages/top_user/top_user.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer();

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: [
                BlocBuilder<AuthenticationBloc, AuthenticationState>(
                  builder: (context, state) {
                    if (state is AuthenticationSuccess) {
                      return _createHeaderWithUser(state.user, context);
                    } else {
                      return _createHeaderWitoutUser(context);
                    }
                  },
                ),
                _createDrawerItem(
                    context: context,
                    icon: SvgPicture.asset("assets/myBench.svg"),
                    text: AppLocalizations.of(context)
                        .translate('string_my_benches'),
                    onTap: () {
                      Navigator.pushNamed(context, MyBenchPage.routeName);
                    }),
                _createDrawerItem(
                    context: context,
                    icon: SvgPicture.asset("assets/favorites.svg"),
                    text: AppLocalizations.of(context)
                        .translate('string_favorites'),
                    onTap: () {
                      Navigator.pushNamed(context, FavoritesPage.routeName);
                    }),
                _createDrawerItem(
                  context: context,
                  icon: SvgPicture.asset("assets/topBenches.svg"),
                  text: AppLocalizations.of(context)
                      .translate('string_top_benches'),
                  onTap: () {
                    Navigator.pushNamed(context, TopBechesPage.routeName);
                  },
                ),
                _createDrawerItem(
                  context: context,
                  icon: SvgPicture.asset("assets/topUsers.svg"),
                  text: AppLocalizations.of(context)
                      .translate('string_top_users'),
                  onTap: () {
                    Navigator.pushNamed(context, TopUserPage.routeName);
                  },
                ),
              ],
            ),
            Column(
              children: [
                RawMaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/add_bench');
                  },
                  elevation: 8.0,
                  fillColor: Theme.of(context).buttonColor,
                  child: SvgPicture.asset("assets/ic_add_bench.svg"),
                  padding: EdgeInsets.only(
                      left: 16.0, right: 16.0, top: 10, bottom: 10),
                  shape: CircleBorder(),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Text(
                  AppLocalizations.of(context).translate("string_add_bench"),
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                SizedBox(
                  height: 105.0,
                ),
              ],
            )
            /*   BlocBuilder<ThemeChangeBloc, ThemeChangeState>(
                builder: (context, state) {
              return Switch(
                  value: state.themeState.isLightMode,
                  onChanged: (value) =>
                      BlocProvider.of<ThemeChangeBloc>(context)
                          .add(OnThemeChangedEvent(value)));
            }) */
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
    accountName: Text(''),
    accountEmail: Text(AppLocalizations.of(context).translate("guest")),
    onDetailsPressed: () => Navigator.pushReplacementNamed(context, '/login'),
  );
}

Widget _createDrawerItem(
    {BuildContext context,
    Widget icon,
    String text,
    GestureTapCallback onTap}) {
  return Material(
      type: MaterialType.transparency,
      child: InkWell(
          onTap: onTap,
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 6.0),
              child: Column(children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    IconButton(icon: icon),
                    Text(text, style: Theme.of(context).textTheme.bodyText1),
                  ],
                ),
              ]))));
}
