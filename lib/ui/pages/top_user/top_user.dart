import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omsk_seaty_mobile/app_localizations.dart';
import 'package:omsk_seaty_mobile/blocs/top_users/top_user_bloc.dart';
import 'package:omsk_seaty_mobile/ui/widgets/custom_app_bar.dart';
import 'package:omsk_seaty_mobile/ui/widgets/top_user_card.dart';

class TopUserPage extends StatefulWidget {
  TopUserPage({Key key}) : super(key: key);
  static String routeName = 'topUser';

  @override
  _TopUserPageState createState() => _TopUserPageState();
}

class _TopUserPageState extends State<TopUserPage> {
  TopUserBloc _topUserBloc = TopUserBloc();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    _topUserBloc.add(GetTopUserEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: (Theme.of(context).brightness == Brightness.light)
          ? Color(0xFFE5E5E5)
          : Color(0xFFE5E5E5),
      appBar: CustomAppBar(
          height: MediaQuery.of(context).padding.top,
          title: AppLocalizations.of(context).translate('top_users')),
      body: BlocProvider(
        create: (context) => _topUserBloc,
        child:
            BlocBuilder<TopUserBloc, TopUserState>(builder: (context, state) {
          if (state is TopuserInitial) {
            print('initial');
            return Center(child: CircularProgressIndicator());
          } else if (state is TopUserPageLoading) {
            print('loading');
            return Center(child: CircularProgressIndicator());
          } else if (state is TopUserPageInitialed) {
            print('load');
            return _buildTopUserCard(state.uiTopUsers);
          } else if (state is TopUserPageError) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)
                      .translate("network_connection_error"),
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Text(
                  AppLocalizations.of(context)
                      .translate("cheak_network_try_again"),
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                SizedBox(
                  height: 60,
                ),
                RawMaterialButton(
                  onPressed: () => {_topUserBloc.add(GetTopUserEvent())},
                  elevation: 8.0,
                  fillColor: Theme.of(context).buttonColor,
                  child: Icon(Icons.refresh),
                  padding: EdgeInsets.only(
                      left: 19.0, right: 19.0, top: 15, bottom: 15),
                  shape: CircleBorder(),
                )
              ],
            ));
          }
        }),
      ),
    );
  }

  Widget _buildTopUserCard(uiTopUsers) {
    return ListView.builder(
      itemCount: uiTopUsers.length,
      itemBuilder: (context, index) {
        return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
            child: TopUserCard(
              uiTopUser: uiTopUsers[index],
              scaffoldKey: _scaffoldKey,
            ));
      },
    );
  }

  @override
  void dispose() {
    _topUserBloc.close();
    super.dispose();
  }
}
