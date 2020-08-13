import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:omsk_seaty_mobile/blocs/map/map_bloc.dart';
import 'package:omsk_seaty_mobile/data/models/map_marker.dart';
import 'package:omsk_seaty_mobile/ui/pages/bench/model/ui_bench.dart';

import 'package:omsk_seaty_mobile/ui/widgets/filter_checkbox_button.dart';

class BenchPage extends StatefulWidget {
  final MapMarker marker;
  BenchPage({Key key, this.marker}) : super(key: key);
  static String routeName = '/bench';
  @override
  _BenchPageState createState() => _BenchPageState();
}

class _BenchPageState extends State<BenchPage> {
  @override
  Widget build(BuildContext context) {
    var bench = UiBench(
        imageLink:
            'https://m.bk55.ru/fileadmin/bkinform/image/2017/12/29/1514539988/9c572fa5eeb303b8e665d6f7e1430e2f.jpg',
        locationName: "Парк победы",
        address: "76 А, Парк победы, Омск",
        rate: 4.5,
        isFavorites: true,
        filters: [
          FilterType.trashcan,
          FilterType.trashcan,
          FilterType.trashcan,
          FilterType.trashcan,
          FilterType.trashcan,
          FilterType.trashcan,
          FilterType.trashcan,
          FilterType.trashcan,
          FilterType.trashcan,
          FilterType.trashcan,
          FilterType.trashcan,
          FilterType.trashcan,
          FilterType.trashcan,
          FilterType.trashcan,
          FilterType.trashcan,
          FilterType.trashcan,
          FilterType.trashcan,
          FilterType.trashcan,
          FilterType.trashcan,
          FilterType.trashcan,
          FilterType.trashcan,
          FilterType.trashcan,
          FilterType.trashcan,
        ]);
    List<Widget> filters = _getFilters(bench.filters);
    return Scaffold(
      body: Container(
        color: Color(0xFFE5E5E5),
        child: Column(
          children: [
            Stack(children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.31,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: FractionalOffset.topCenter,
                        end: FractionalOffset.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.black.withOpacity(0.2),
                        ],
                        stops: [
                          0.0,
                          1.0
                        ]),
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
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
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
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0, left: 149.0),
                        child: SizedBox(
                          height: 36.0,
                          width: 36.0,
                          child: MaterialButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              if (bench.isFavorites) {
                                widget.marker.isFavorites = false;
                                setState(() {
                                  bench.isFavorites = false;
                                });
                                print(
                                    "убрал лайк ${widget.marker.locationName}");
                                BlocProvider.of<MapBloc>(context).add(
                                    LikeButtonPassEvent(marker: widget.marker));
                              } else {
                                widget.marker.isFavorites = true;
                                setState(() {
                                  bench.isFavorites = true;
                                });
                                print(
                                    "поставил лайк ${widget.marker.locationName}");
                                BlocProvider.of<MapBloc>(context).add(
                                    LikeButtonPassEvent(marker: widget.marker));
                              }
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
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 4.0, left: 16.0),
                        child: Text(
                          "О лавочке",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Roboto",
                              fontSize: 16.0),
                        ),
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
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _getFilters(List<FilterType> filters) {
    final List fixedList = Iterable<int>.generate(filters.length).toList();
    List<Widget> items = fixedList.map((index) {
      var filter = filters[index];
      switch (filter) {
        case FilterType.trashcan:
          var leftPadding = (index == 0 || index == 1) ? 11.0 : 2.0;
          return Padding(
              padding: EdgeInsets.only(
                  left: leftPadding, bottom: 2.0, top: 2.0, right: 2.0),
              child: FilterCheckBox(
                title: "Урна рядом",
                icon: SvgPicture.asset("assets/trashсan.svg"),
                color: 0x219653,
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
