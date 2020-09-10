import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:omsk_seaty_mobile/blocs/authentication/authentication_bloc.dart';
import 'package:omsk_seaty_mobile/blocs/profile/profile_bloc.dart';
import 'package:omsk_seaty_mobile/blocs/profile/profile_event.dart';
import 'package:omsk_seaty_mobile/blocs/profile/profile_state.dart';
import 'package:omsk_seaty_mobile/data/models/user_info.dart';
import 'package:omsk_seaty_mobile/ui/utils/orientation.dart';
import 'package:omsk_seaty_mobile/ui/widgets/retry.dart';

import '../../../app_localizations.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);
  static String routeName = "/profile";

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfileBloc _bloc = ProfileBloc();

  @override
  void initState() {
    _bloc.add(GetProfileEvent());
    AppOrientation.enableLandscape();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => _bloc,
        child:
            BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
          if (state is ProfileInitial) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ProfileSuccess) {
            return _buildProfileState(state.userInfo);
          } else if (state is ProfileError) {
            return getRetryBlock(context, () => {_bloc.add(GetProfileEvent())});
          } else {
            return Container();
          }
        }),
      ),
    );
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  Widget _getBackButton() {
    return Positioned(
      top: 10 + MediaQuery.of(context).padding.top,
      left: 6,
      child: SizedBox(
        height: 36.0,
        width: 45.0,
        child: MaterialButton(
            shape: CircleBorder(),
            child: SvgPicture.asset(
              "assets/leftarrowwhite.svg",
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
    );
  }

  Widget _buildProfileState(UserInfo userInfo) {
    return Stack(children: <Widget>[
      ClipPath(
        child: Container(color: Theme.of(context).accentColor),
        clipper: Clipper(),
      ),
      _getBackButton(),
      Container(
          margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height / 3.2 - 75),
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              Container(
                  width: 150.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: CachedNetworkImageProvider(userInfo.photoUrl),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.all(Radius.circular(75.0)),
                      boxShadow: [
                        BoxShadow(blurRadius: 7.0, color: Colors.black)
                      ])),
              SizedBox(height: 24.0),
              Text(
                userInfo.displayName,
                style: Theme.of(context).textTheme.headline2,
              ),
              SizedBox(height: 4.0),
              Text(
                userInfo.title,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(color: Theme.of(context).secondaryHeaderColor),
              ),
              SizedBox(height: 40.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _getCountBlock(userInfo.score.toString(),
                      AppLocalizations.of(context).translate('score')),
                  _getCountBlock(userInfo.benches.toString(),
                      AppLocalizations.of(context).translate('benches')),
                  _getCountBlock(userInfo.comments.toString(),
                      AppLocalizations.of(context).translate('comments')),
                ],
              ),
              Expanded(child: SizedBox.shrink()),
              _getLogOutButton(),
            ],
          )),
    ]);
  }

  Widget _getCountBlock(String title, String subTitle) {
    return Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .copyWith(color: Colors.black)),
            Text(subTitle,
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(color: Colors.black87)),
          ],
        ));
  }

  Widget _getLogOutButton() {
    return Container(
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 20),
        child: RaisedButton(
            child: Text(
                AppLocalizations.of(context).translate('string_log_out'),
                style: Theme.of(context).textTheme.button),
            onPressed: () {
              Navigator.pushNamed(context, '/login');
              BlocProvider.of<AuthenticationBloc>(context)
                  .add(AuthenticationLoggedOut());
            }));
  }
}

class Clipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 2.5);
    path.lineTo(size.width * 2.5, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
