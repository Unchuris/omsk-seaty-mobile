import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:omsk_seaty_mobile/ui/pages/top_user/model/ui_top_user.dart';

class TopUserCard extends StatelessWidget {
  final UiTopUser uiTopUser;
  const TopUserCard({Key key, this.uiTopUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
      width: 343.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            flex: 0,
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 12.0, bottom: 12.0, left: 8.0),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(uiTopUser.photoUrl)),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    uiTopUser.displayName,
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  Text(
                    uiTopUser.rank,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Row(
                    children: [
                      Text(
                        'Лавочек',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        uiTopUser.benches.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: Colors.orange),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SizedBox(
                        width: 24.0,
                        height: 24.0,
                        child: IconButton(
                            padding: const EdgeInsets.all(0.0),
                            iconSize: 24.0,
                            icon: Icon(Icons.more_vert),
                            onPressed: null))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
