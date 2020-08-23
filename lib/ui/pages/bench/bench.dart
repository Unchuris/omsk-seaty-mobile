import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:omsk_seaty_mobile/blocs/authentication/authentication_bloc.dart';
import 'package:omsk_seaty_mobile/blocs/bench_page/bench_page_bloc.dart';
import 'package:omsk_seaty_mobile/blocs/map/map_bloc.dart';
import 'package:omsk_seaty_mobile/data/models/bench_type.dart';
import 'package:omsk_seaty_mobile/ui/pages/add_comment/add_comment.dart';
import 'package:omsk_seaty_mobile/ui/pages/bench/model/ui_bench.dart';
import 'package:omsk_seaty_mobile/ui/pages/bench/model/ui_comment.dart';

import 'package:omsk_seaty_mobile/ui/widgets/comment.dart';

import 'package:omsk_seaty_mobile/ui/widgets/filter_checkbox_button.dart';
import 'package:omsk_seaty_mobile/ui/widgets/star_rate.dart';

import '../../../http.dart';

class BenchPage extends StatefulWidget {
  BenchPage({Key key, this.benchId}) : super(key: key);
  static String routeName = '/bench';
  final String benchId;
  @override
  _BenchPageState createState() => _BenchPageState();
}

class _BenchPageState extends State<BenchPage> {
  final BenchPageBloc _benchPageBloc = BenchPageBloc();
  UiBench _bench;
  String commentString;
  List<Widget> _filters;

  @override
  void initState() {
    _benchPageBloc.add(GetBenchEvent(benchId: widget.benchId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: (Theme.of(context).brightness == Brightness.light)
          ? Color(0xFFE5E5E5)
          : Color(0xFFE5E5E5),
      body: BlocProvider(
        create: (context) => _benchPageBloc,
        child: BlocListener<BenchPageBloc, BenchPageState>(
          listener: (context, state) {
            if (state is BenchPageInitial) {
              print("initial");
            }
            if (state is BenchPageLoading) {
              print('loading');
            }
            if (state is BenchPageInitialed) {
              print('loaded');
              _bench = state.benchUi;

              switch (_bench.comments.length) {
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
              _filters = _getFilters(_bench.features);
            }
          },
          child: BlocBuilder<BenchPageBloc, BenchPageState>(
              builder: (context, state) {
            if (state is BenchPageLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is BenchPageInitial) {
              return Center(child: CircularProgressIndicator());
            } else if (state is BenchPageInitialed) {
              return _buildBenchPage(state.benchUi);
            }
          }),
        ),
      ),
    );
  }

  Widget _buildBenchPage(UiBench bench) {
    return Container(
      color: Color(0xFFE5E5E5),
      child: Column(
        children: [
          Stack(children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.31,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(bench.imageUrl),
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
                        _bench.name,
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
                                padding:
                                    const EdgeInsets.only(top: 28.0, left: 8.0),
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
                                padding:
                                    const EdgeInsets.only(top: 6.0, left: 16.0),
                                child: SvgPicture.asset(
                                  "assets/rate.svg",
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 6.0, left: 8.0),
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
                          onPressed: () async {
                            if (bench.like) {
                              setState(() {
                                bench.like = false;
                              });
                              var user =
                                  BlocProvider.of<AuthenticationBloc>(context)
                                      .getUser;
                              var respone = await dio
                                  .patch('/favorites/${user.uid}', data: {
                                'uid': user.uid,
                                'bench_id': widget.benchId
                              });
                              BlocProvider.of<MapBloc>(context).add(
                                  OnLikeClickedEvent(
                                      markerId: widget.benchId,
                                      liked: bench.like));
                            } else {
                              setState(() {
                                bench.like = true;
                              });
                              var user =
                                  BlocProvider.of<AuthenticationBloc>(context)
                                      .getUser;
                              var respone = await dio
                                  .put('/favorites/${user.uid}', data: {
                                'uid': user.uid,
                                'bench_id': widget.benchId
                              });
                              BlocProvider.of<MapBloc>(context).add(
                                  OnLikeClickedEvent(
                                      markerId: widget.benchId,
                                      liked: bench.like));
                            }
                          },
                          color: Colors.white,
                          child: bench.like
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
                    children: [..._filters],
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
                              _bench.comments.length.toString() +
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
              (bench.comments.length == 0 || bench.comments == null)
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      child: Center(child: Text("Комментариев нет")))
                  : Container(
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddCommentPage(
                                      benchId: widget.benchId,
                                      onAdd: addComment,
                                    )));
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
    );
  }

  addComment(UiComment comment) {
    setState(() {
      _bench.comments.add(comment);
    });
  }

  _getFilters(List<BenchType> filters) {
    final List fixedList = Iterable<int>.generate(filters.length).toList();
    List<Widget> items = fixedList.map((index) {
      var filter = filters[index];
      var leftPadding = (index == 0 || index == 1) ? 11.0 : 2.0;
      return Padding(
          padding: EdgeInsets.only(
              left: leftPadding, bottom: 2.0, top: 2.0, right: 2.0),
          child: _getFilterCheckBox(filter));
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

  FilterCheckBox _getFilterCheckBox(BenchType benchType) {
    var title = benchTypeToString(benchType, context);
    switch (benchType) {
      case BenchType.HIGH_COMFORT:
        return FilterCheckBox(
            title: title,
            type: TypeCheckBox.oneState,
            color: 0xF2C94C,
            icon: SvgPicture.asset("assets/filter_park.svg"));
      case BenchType.URN_NEARBY:
        return FilterCheckBox(
            title: title,
            type: TypeCheckBox.oneState,
            color: 0xF2994A,
            icon: SvgPicture.asset("assets/trashсan.svg"));
      case BenchType.TABLE_NEARBY:
        return FilterCheckBox(
            title: title,
            type: TypeCheckBox.oneState,
            color: 0xEB5757,
            icon: SvgPicture.asset("assets/table.svg"));
      case BenchType.COVERED_BENCH:
        return FilterCheckBox(
            title: title,
            type: TypeCheckBox.oneState,
            color: 0xBB6BD9,
            icon: SvgPicture.asset("assets/warn.svg"));
      case BenchType.FOR_A_LARGE_COMPANY:
        return FilterCheckBox(
            title: title,
            type: TypeCheckBox.oneState,
            color: 0x2F80ED,
            icon: SvgPicture.asset("assets/bitgroup.svg"));
      case BenchType.SCENIC_VIEW:
        return FilterCheckBox(
            title: title,
            type: TypeCheckBox.oneState,
            color: 0x219653,
            icon: SvgPicture.asset("assets/beautifulPlase.svg"));
      case BenchType.BUS_STOP:
        return FilterCheckBox(
            title: title,
            type: TypeCheckBox.oneState,
            color: 0x5856D6,
            icon: SvgPicture.asset("assets/busstop.svg"));
    }
  }

  @override
  void dispose() {
    _benchPageBloc.close();
    super.dispose();
  }
}
