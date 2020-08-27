import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'package:omsk_seaty_mobile/app_localizations.dart';
import 'package:omsk_seaty_mobile/blocs/authentication/authentication_bloc.dart';
import 'package:omsk_seaty_mobile/data/models/bench_light.dart';
import 'package:omsk_seaty_mobile/data/models/bench_type.dart';
import 'package:omsk_seaty_mobile/data/models/complain_type.dart';
import 'package:omsk_seaty_mobile/data/models/user.dart';
import 'package:omsk_seaty_mobile/ui/pages/favorites/favorites.dart';
import 'package:omsk_seaty_mobile/ui/pages/my_benches/my_benches.dart';
import 'package:omsk_seaty_mobile/ui/pages/top_benches/top_benches.dart';
import 'package:omsk_seaty_mobile/ui/pages/top_user/top_user.dart';
import 'package:omsk_seaty_mobile/ui/widgets/dialog/childs/thanks.dart';
import 'package:omsk_seaty_mobile/ui/utils/theme_change_bloc.dart';
import 'package:omsk_seaty_mobile/ui/utils/theme_change_event.dart';
import 'package:omsk_seaty_mobile/ui/utils/theme_change_state.dart';
import 'dialog/childs/checkbox_list.dart';
import 'dialog/dialog_with_child.dart';
import 'dialog/list_provider.dart';

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
                text:
                    AppLocalizations.of(context).translate('string_my_benches'),
                onTap: () {
                  Navigator.pushNamed(context, MyBenchPage.routeName);
                }),
            _createDrawerItem(
                icon: SvgPicture.asset("assets/favorites.svg"),
                text:
                    AppLocalizations.of(context).translate('string_favorites'),
                onTap: () {
                  Navigator.pushNamed(context, FavoritesPage.routeName);
                }),
            _createDrawerItem(
              icon: SvgPicture.asset("assets/topBenches.svg"),
              text:
                  AppLocalizations.of(context).translate('string_top_benches'),
              onTap: () {
                Navigator.pushNamed(context, TopBechesPage.routeName);
              },
            ),
            _createDrawerItem(
              icon: SvgPicture.asset("assets/topUsers.svg"),
              text: AppLocalizations.of(context).translate('string_top_users'),
              onTap: () {
                Navigator.pushNamed(context, TopUserPage.routeName);
              },
            ),
            _createDrawerItem(
              icon: Icon(Icons.settings),
              text: 'Dialog test list',
              onTap: () {
                _createDialogWithList();
              },
            ),
            _createDrawerItem(
              icon: Icon(Icons.settings),
              text: 'Dialog test complain',
              onTap: () {
                _createDialogComplain();
              },
            ),
            _createDrawerItem(
                icon: Icon(Icons.settings),
                text: 'Dialog test thanks',
                onTap: () {
                  _createDialogThanks();
                }),
            BlocBuilder<ThemeChangeBloc, ThemeChangeState>(
                builder: (context, state) {
              return Switch(
                  value: state.themeState.isLightMode,
                  onChanged: (value) =>
                      BlocProvider.of<ThemeChangeBloc>(context)
                          .add(OnThemeChangedEvent(value)));
            })
          ],
        ),
      ),
    );
  }

  void _createDialogWithList() {
    Map<BenchType, bool> benches = {
      BenchType.TABLE_NEARBY: false,
      BenchType.COVERED_BENCH: false,
      BenchType.SCENIC_VIEW: false,
      BenchType.FOR_A_LARGE_COMPANY: false
    };

    showDialog(
        context: context,
        builder: (context) => ListProvider(
            benches,
            DialogWithChild(
                title: AppLocalizations.of(context)
                    .translate('dialog_title_choose'),
                buttonText:
                    AppLocalizations.of(context).translate('dialog_button_add'),
                child: CheckBoxList(),
                buttonType: DialogButtonType.LIST)));
  }

  void _createDialogComplain() {
    Map<ComplainType, bool> complains = {
      ComplainType.ABSENT_BENCH: false,
      ComplainType.INAPPROPRIATE_CONTENT: false,
      ComplainType.OFFENSIVE_MATERIAL: false
    };

    showDialog(
        context: context,
        builder: (context) => ListProvider(
            complains,
            DialogWithChild(
                title: AppLocalizations.of(context)
                    .translate('dialog_title_complain'),
                buttonText: AppLocalizations.of(context)
                    .translate('dialog_title_complain'),
                child: CheckBoxList(),
                buttonType: DialogButtonType.COMPLAIN)));
  }

  void _createDialogThanks() {
    showDialog(
        context: context,
        builder: (context) => DialogWithChild(
            title:
                AppLocalizations.of(context).translate('dialog_title_thanks'),
            buttonText:
                AppLocalizations.of(context).translate('dialog_button_good'),
            child: ThanksChild(),
            buttonType: DialogButtonType.CLOSE));
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
