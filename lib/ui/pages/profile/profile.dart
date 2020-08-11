import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omsk_seaty_mobile/app_localizations.dart';
import 'package:omsk_seaty_mobile/blocs/authentication/authentication_bloc.dart';
import 'package:omsk_seaty_mobile/data/models/user.dart';
import 'package:omsk_seaty_mobile/ui/pages/profile/model/ui_profile.dart';
import 'package:omsk_seaty_mobile/ui/widgets/sliver_bar_title.dart';

class ProfilePage extends StatelessWidget {
  final UiProfile profile;
  ProfilePage({Key key, this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User user = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: SliverAppBarTitle(
                child: Text('${user.displayName}'),
              ),
              primary: true,
              pinned: true,
              expandedHeight: 300,
              flexibleSpace: FlexibleSpaceBar(
                background: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Hero(
                        tag: 'avatar',
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(user.photoUrl),
                        )),
                    SizedBox(height: 10),
                    Text(
                      '${user.displayName}',
                      style: TextStyle(fontSize: 24),
                    ),
                  ],
                ),
              ),
            )
          ];
        },
        body: Center(
            child: ButtonTheme(
          minWidth: 270,
          height: 50,
          child: FlatButton(
            child: Text(
                AppLocalizations.of(context).translate('string_log_out'),
                style: TextStyle(color: Color(0xFF828282))),
            onPressed: () => {
              BlocProvider.of<AuthenticationBloc>(context)
                  .add(AuthenticationLoggedOut()),
              Navigator.pushReplacementNamed(context, '/login')
            },
          ),
        )),
      ),
    );
  }
}
