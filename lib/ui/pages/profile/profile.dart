import 'package:flutter/material.dart';
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
        body: Center(child: Text('body')),
      ),
    );
  }
}
