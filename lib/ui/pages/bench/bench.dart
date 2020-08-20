import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:omsk_seaty_mobile/data/models/bench_type.dart';
import 'package:omsk_seaty_mobile/ui/pages/add_comment/add_comment.dart';
import 'package:omsk_seaty_mobile/ui/pages/bench/model/ui_bench.dart';
import 'package:omsk_seaty_mobile/ui/pages/bench/model/ui_comment.dart';
import 'package:omsk_seaty_mobile/ui/widgets/comment.dart';

import 'package:omsk_seaty_mobile/ui/widgets/filter_checkbox_button.dart';
import 'package:omsk_seaty_mobile/ui/widgets/star_rate.dart';

class BenchPage extends StatefulWidget {
  BenchPage({Key key}) : super(key: key);
  static String routeName = '/bench';
  @override
  _BenchPageState createState() => _BenchPageState();
}

class _BenchPageState extends State<BenchPage> {
  @override
  Widget build(BuildContext context) {
    String markerId = ModalRoute.of(context).settings.arguments;
    var bench = UiBench(
        imageLink: "",
        locationName: "Тестовая",
        address: "76 А, Парк победы, Омск",
        rate: 4.5,
        isFavorites: true,
        filters: Set.from([
          BenchType.URN_NEARBY,
          BenchType.URN_NEARBY,
          BenchType.URN_NEARBY,
          BenchType.URN_NEARBY,
          BenchType.URN_NEARBY,
          BenchType.URN_NEARBY,
          BenchType.URN_NEARBY,
          BenchType.URN_NEARBY,
          BenchType.URN_NEARBY,
          BenchType.URN_NEARBY,
          BenchType.URN_NEARBY,
          BenchType.URN_NEARBY,
          BenchType.URN_NEARBY,
          BenchType.URN_NEARBY,
          BenchType.URN_NEARBY,
          BenchType.URN_NEARBY,
          BenchType.URN_NEARBY,
          BenchType.URN_NEARBY,
          BenchType.URN_NEARBY,
          BenchType.URN_NEARBY,
          BenchType.URN_NEARBY,
          BenchType.URN_NEARBY,
          BenchType.URN_NEARBY,
          BenchType.URN_NEARBY
        ]),
        comments: [
          UiComment(
              photoUrl:
                  "https://cdn3.iconfinder.com/data/icons/business-avatar-1/512/11_avatar-512.png",
              displayName: "Петр Петров",
              comment:
                  "st sit labore cupidatat tempor ad minim occaecat elit. Fugiat et officia eiusmod anim enim. Ex incididunt reprehenderit quis ad sunt voluptate. Non non eiusmod ea incididunt exercitation. Dolor labore est nisi laborum labore. Pariatur reprehenderit magna amet occaecat sint cupidatat eiusmod officia enim.",
              rank: "Магистр лавочек",
              rate: 3),
          UiComment(
              photoUrl:
                  "https://media.istockphoto.com/vectors/test-icon-vector-question-mark-with-male-user-person-profile-avatar-vector-id1198413914?s=170x170",
              displayName: "Петр Петров",
              comment:
                  "st sit labore cupidatat tempor ad minim occaecat elit. Fugiat et officia eiusmod anim enim. Ex incididunt reprehenderit quis ad sunt voluptate. Non non eiusmod ea incididunt exercitation. Dolor labore est nisi laborum labore. Pariatur reprehenderit magna amet occaecat sint cupidatat eiusmod officia enim.",
              rank: "Магистр лавочек",
              rate: 3),
          UiComment(
              photoUrl:
                  "https://media.istockphoto.com/vectors/test-icon-vector-question-mark-with-male-user-person-profile-avatar-vector-id1198413914?s=170x170",
              displayName: "Петр Петров",
              comment:
                  "st sit labore cupidatat tempor ad minim occaecat elit. Fugiat et officia eiusmod anim enim. Ex incididunt reprehenderit quis ad sunt voluptate. Non non eiusmod ea incididunt exercitation. Dolor labore est nisi laborum labore. Pariatur reprehenderit magna amet occaecat sint cupidatat eiusmod officia enim.",
              rank: "Магистр лавочек",
              rate: 3),
          UiComment(
              photoUrl:
                  "https://media.istockphoto.com/vectors/test-icon-vector-question-mark-with-male-user-person-profile-avatar-vector-id1198413914?s=170x170",
              displayName: "Петр Петров",
              comment:
                  "st sit labore cupidatat tempor ad minim occaecat elit. Fugiat et officia eiusmod anim enim. Ex incididunt reprehenderit quis ad sunt voluptate. Non non eiusmod ea incididunt exercitation. Dolor labore est nisi laborum labore. Pariatur reprehenderit magna amet occaecat sint cupidatat eiusmod officia enim.",
              rank: "Магистр лавочек",
              rate: 3),
          UiComment(
              photoUrl:
                  "https://media.istockphoto.com/vectors/test-icon-vector-question-mark-with-male-user-person-profile-avatar-vector-id1198413914?s=170x170",
              displayName: "Петр Петров",
              comment:
                  "st sit labore cupidatat tempor ad minim occaecat elit. Fugiat et officia eiusmod anim enim. Ex incididunt reprehenderit quis ad sunt voluptate. Non non eiusmod ea incididunt exercitation. Dolor labore est nisi laborum labore. Pariatur reprehenderit magna amet occaecat sint cupidatat eiusmod officia enim.",
              rank: "Магистр лавочек",
              rate: 3),
          UiComment(
              photoUrl:
                  "https://media.istockphoto.com/vectors/test-icon-vector-question-mark-with-male-user-person-profile-avatar-vector-id1198413914?s=170x170",
              displayName: "Петр Петров",
              comment:
                  "st sit labore cupidatat tempor ad minim occaecat elit. Fugiat et officia eiusmod anim enim. Ex incididunt reprehenderit quis ad sunt voluptate. Non non eiusmod ea incididunt exercitation. Dolor labore est nisi laborum labore. Pariatur reprehenderit magna amet occaecat sint cupidatat eiusmod officia enim.",
              rank: "Магистр лавочек",
              rate: 3),
          UiComment(
              photoUrl:
                  "https://media.istockphoto.com/vectors/test-icon-vector-question-mark-with-male-user-person-profile-avatar-vector-id1198413914?s=170x170",
              displayName: "Петр Петров",
              comment:
                  "st sit labore cupidatat tempor ad minim occaecat elit. Fugiat et officia eiusmod anim enim. Ex incididunt reprehenderit quis ad sunt voluptate. Non non eiusmod ea incididunt exercitation. Dolor labore est nisi laborum labore. Pariatur reprehenderit magna amet occaecat sint cupidatat eiusmod officia enim.",
              rank: "Магистр лавочек",
              rate: 3),
          UiComment(
              photoUrl:
                  "https://media.istockphoto.com/vectors/test-icon-vector-question-mark-with-male-user-person-profile-avatar-vector-id1198413914?s=170x170",
              displayName: "Петр Петров",
              comment:
                  "st sit labore cupidatat tempor ad minim occaecat elit. Fugiat et officia eiusmod anim enim. Ex incididunt reprehenderit quis ad sunt voluptate. Non non eiusmod ea incididunt exercitation. Dolor labore est nisi laborum labore. Pariatur reprehenderit magna amet occaecat sint cupidatat eiusmod officia enim.",
              rank: "Магистр лавочек",
              rate: 3),
          UiComment(
              photoUrl:
                  "https://media.istockphoto.com/vectors/test-icon-vector-question-mark-with-male-user-person-profile-avatar-vector-id1198413914?s=170x170",
              displayName: "Петр Петров",
              comment:
                  "st sit labore cupidatat tempor ad minim occaecat elit. Fugiat et officia eiusmod anim enim. Ex incididunt reprehenderit quis ad sunt voluptate. Non non eiusmod ea incididunt exercitation. Dolor labore est nisi laborum labore. Pariatur reprehenderit magna amet occaecat sint cupidatat eiusmod officia enim.",
              rank: "Магистр лавочек",
              rate: 3),
          UiComment(
              photoUrl:
                  "https://media.istockphoto.com/vectors/test-icon-vector-question-mark-with-male-user-person-profile-avatar-vector-id1198413914?s=170x170",
              displayName: "Петр Петров",
              comment:
                  "st sit labore cupidatat tempor ad minim occaecat elit. Fugiat et officia eiusmod anim enim. Ex incididunt reprehenderit quis ad sunt voluptate. Non non eiusmod ea incididunt exercitation. Dolor labore est nisi laborum labore. Pariatur reprehenderit magna amet occaecat sint cupidatat eiusmod officia enim.",
              rank: "Магистр лавочек",
              rate: 3),
          UiComment(
              photoUrl:
                  "https://media.istockphoto.com/vectors/test-icon-vector-question-mark-with-male-user-person-profile-avatar-vector-id1198413914?s=170x170",
              displayName: "Петр Петров",
              comment:
                  "st sit labore cupidatat tempor ad minim occaecat elit. Fugiat et officia eiusmod anim enim. Ex incididunt reprehenderit quis ad sunt voluptate. Non non eiusmod ea incididunt exercitation. Dolor labore est nisi laborum labore. Pariatur reprehenderit magna amet occaecat sint cupidatat eiusmod officia enim.",
              rank: "Магистр лавочек",
              rate: 3),
          UiComment(
              photoUrl:
                  "https://media.istockphoto.com/vectors/test-icon-vector-question-mark-with-male-user-person-profile-avatar-vector-id1198413914?s=170x170",
              displayName: "Петр Петров",
              comment:
                  "st sit labore cupidatat tempor ad minim occaecat elit. Fugiat et officia eiusmod anim enim. Ex incididunt reprehenderit quis ad sunt voluptate. Non non eiusmod ea incididunt exercitation. Dolor labore est nisi laborum labore. Pariatur reprehenderit magna amet occaecat sint cupidatat eiusmod officia enim.",
              rank: "Магистр лавочек",
              rate: 3),
          UiComment(
              photoUrl:
                  "https://media.istockphoto.com/vectors/test-icon-vector-question-mark-with-male-user-person-profile-avatar-vector-id1198413914?s=170x170",
              displayName: "Петр Петров",
              comment:
                  "st sit labore cupidatat tempor ad minim occaecat elit. Fugiat et officia eiusmod anim enim. Ex incididunt reprehenderit quis ad sunt voluptate. Non non eiusmod ea incididunt exercitation. Dolor labore est nisi laborum labore. Pariatur reprehenderit magna amet occaecat sint cupidatat eiusmod officia enim.",
              rank: "Магистр лавочек",
              rate: 3),
          UiComment(
              photoUrl:
                  "https://media.istockphoto.com/vectors/test-icon-vector-question-mark-with-male-user-person-profile-avatar-vector-id1198413914?s=170x170",
              displayName: "Петр Петров",
              comment:
                  "st sit labore cupidatat tempor ad minim occaecat elit. Fugiat et officia eiusmod anim enim. Ex incididunt reprehenderit quis ad sunt voluptate. Non non eiusmod ea incididunt exercitation. Dolor labore est nisi laborum labore. Pariatur reprehenderit magna amet occaecat sint cupidatat eiusmod officia enim.",
              rank: "Магистр лавочек",
              rate: 3),
        ]);
    List<Widget> filters = _getFilters(bench.filters);

    String commentString;
    switch (bench.comments.length) {
      case 1:
        commentString = "комментарий";
        break;
      case 2:
        commentString = "комментария";
        break;
      case 3:
        commentString = "комментария";
        break;
      case 5:
        commentString = "комментариев";
        break;
      default:
        commentString = "комментариев";
    }

    return Scaffold(
      backgroundColor: (Theme.of(context).brightness == Brightness.light)
          ? Color(0xFFE5E5E5)
          : Color(0xFFE5E5E5),
      body: Container(
        color: Color(0xFFE5E5E5),
        child: Column(
          children: [
            Stack(children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.31,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: CachedNetworkImageProvider(bench.imageLink),
                        fit: BoxFit.fill)),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.31,
                decoration: BoxDecoration(
                    color: Colors.white,
                    gradient: LinearGradient(
                        begin: FractionalOffset.topCenter,
                        end: FractionalOffset.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.2),
                          Colors.black.withOpacity(0.7),
                        ],
                        stops: [
                          0.0,
                          1.0
                        ])),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50.0,
                        padding: EdgeInsets.only(top: 32.0, left: 15.0),
                        child: IconButton(
                            icon: SvgPicture.asset(
                              "assets/leftarrowwhite.svg",
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 28.0, left: 16.0),
                        child: Text(
                          bench.locationName,
                          style: TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 20.0,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.ideographic,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 28.0, left: 16.0),
                                  child: SvgPicture.asset(
                                    "assets/pin.svg",
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 28.0, left: 8.0),
                                  child: Text(
                                    bench.address,
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        fontSize: 14.0,
                                        color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 6.0, left: 16.0),
                                  child: SvgPicture.asset(
                                    "assets/rate.svg",
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 6.0, left: 8.0),
                                  child: Text(
                                    bench.rate.toString(),
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        fontSize: 14.0,
                                        color: Colors.white),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 32.0, right: 17.0),
                        child: SizedBox(
                          height: 36.0,
                          width: 36.0,
                          child: MaterialButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
//                              if (bench.isFavorites) {
//                                marker.isFavorites = false;
//                                setState(() {
//                                  bench.isFavorites = false;
//                                });
//                                BlocProvider.of<MapBloc>(context)
//                                    .add(LikeButtonPassEvent(marker: marker));
//                              } else {
//                                marker.isFavorites = true;
//                                setState(() {
//                                  bench.isFavorites = true;
//                                });
//                                BlocProvider.of<MapBloc>(context)
//                                    .add(LikeButtonPassEvent(marker: marker));
//                              }
                            },
                            color: Colors.white,
                            child: bench.isFavorites
                                ? SvgPicture.asset("assets/like.svg")
                                : SvgPicture.asset("assets/unlike.svg"),
                            shape: CircleBorder(),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )
            ]),
            Container(
              padding: EdgeInsets.all(0.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 4.0, left: 16.0),
                        child: Text("О лавочке",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(fontSize: 16.0)),
                      ),
                    ],
                  ),
                  Container(
                    height: 68,
                    child: ListView(
                      children: [...filters],
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.ideographic,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text("Комментарии",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(fontSize: 16.0)),
                          ),
                          Column(
                            children: [
                              StarWidget(
                                rate: bench.rate,
                              ),
                              Text(
                                bench.comments.length.toString() +
                                    " " +
                                    commentString,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(fontSize: 10.0),
                              )
                            ],
                          ),
                        ]),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.489,
              child: Stack(children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.41,
                  child: ListView.builder(
                      padding: const EdgeInsets.only(top: 11.0),
                      itemCount: bench.comments.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 2.0),
                          child: Comment(
                            comment: bench.comments[index],
                          ),
                        );
                      }),
                ),
                Positioned(
                    right: 15,
                    bottom: 33,
                    child: FloatingActionButton(
                        child: SvgPicture.asset("assets/pencil.svg"),
                        backgroundColor: Color(0xffF2994A),
                        onPressed: () {
                          Navigator.pushNamed(
                              context, AddCommentPage.routeName);
                        })),
                Positioned(
                  bottom: 0,
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: ButtonTheme(
                          minWidth: 270,
                          height: 50,
                          child: FlatButton(
                            child: Text("ПОЖАЛОВАТЬСЯ",
                                style: Theme.of(context).textTheme.button),
                            onPressed: () => {},
                          ),
                        ),
                      )),
                )
              ]),
            ),
          ],
        ),
      ),
    );
  }

  _getFilters(Set<BenchType> filters) {
    final List fixedList = Iterable<int>.generate(filters.length).toList();
    List<Widget> items = fixedList.map((index) {
      var filter = filters.first;
      switch (filter) {
        case BenchType.URN_NEARBY:
          var leftPadding = (index == 0 || index == 1) ? 11.0 : 2.0;
          return Padding(
              padding: EdgeInsets.only(
                  left: leftPadding, bottom: 2.0, top: 2.0, right: 2.0),
              child: FilterCheckBox(
                title: "Урна рядом",
                icon: SvgPicture.asset("assets/trashсan.svg"),
                color: 0x219653,
                type: TypeCheckBox.oneState,
              ));
          break;
        default:
      }
    }).toList();
    List<Widget> columns = [];
    for (var i = 0; i < items.length; i += 2) {
      if (i == items.length - 1) {
        if (items.length % 2 == 0) {
          columns.add(Column(children: [items[i], items[i + 1]]));
          break;
        } else if (items.length % 2 == 1) {
          columns.add(Column(children: [items[i]]));
          break;
        }
      }
      columns.add(Column(children: [items[i], items[i + 1]]));
    }
    return columns;
  }
}
