import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart';
import 'package:omsk_seaty_mobile/data/models/bench_light.dart';

import 'bench_card.dart';

class BenchSlider extends StatefulWidget {
  final BenchSliderOptions options;

  final List<BenchLight> items;

  final CarouselControllerImpl _carouselController;

  BenchSlider(
      {@required this.items,
      @required this.options,
      carouselController,
      Key key})
      : _carouselController = carouselController ?? CarouselController(),
        super(key: key);

  @override
  _BenchSlider createState() => _BenchSlider(_carouselController);
}

class _BenchSlider extends State<BenchSlider> {
  BenchSliderOptions get options => widget.options ?? BenchSliderOptions(height: 200);

  List<BenchLight> get items => widget.items ?? List<BenchLight>();

  final CarouselControllerImpl _carouselController;

  _BenchSlider(this._carouselController);

  int currentId = 0;

  @override
  void didUpdateWidget(BenchSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    var initPage = _getInitPage();
    if (initPage != currentId) {
      currentId = initPage;
      _carouselController.animateToPage(initPage);
    }
  }

  void onPageChanged(int index, CarouselPageChangedReason changeReason) {
    if (changeReason == CarouselPageChangedReason.manual &&
        index < items.length &&
        currentId != index) {
      currentId = index;
      options.onPageChanged(items[index], currentId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: _getBenches(onClick: (BenchLight benchLight) {
        if (identical(items[currentId].id, benchLight.id)) {
          options.onItemClicked(benchLight);
        } else {
          var id = items.indexOf(benchLight);
          if (id > 0) {
            currentId = id;
            _carouselController.animateToPage(id);
          }
        }
      }),
      options: CarouselOptions(
          initialPage: _getInitPage(),
          enlargeCenterPage: options.enlargeCenterPage,
          enableInfiniteScroll: false, //TODO options enableInfiniteScroll
          onPageChanged: onPageChanged,
          height: options.height),
      carouselController: _carouselController,
    );
  }

  int _getInitPage() {
    var initPage = 0;
    if (options.currentBenches != null && items.isNotEmpty) {
      var index = items.indexOf(options.currentBenches);
      if (index > 0) {
        initPage = index;
      }
    }
    return initPage;
  }

  List<Widget> _getBenches({Function onClick}) => items
      .map((item) => GestureDetector(
          onTap: () => onClick(item), child: BenchCard(bench: item)))
      .toList();
}

class BenchSliderOptions {
  final double height;
  final BenchLight currentBenches;

  final bool enableInfiniteScroll;
  final bool enlargeCenterPage;

  final Function(BenchLight benchLight, int index) onPageChanged;
  final Function(BenchLight benchLight) onItemClicked;

  BenchSliderOptions({
    this.enlargeCenterPage: true,
    @required this.height,
    this.enableInfiniteScroll: false,
    this.currentBenches,
    this.onPageChanged,
    this.onItemClicked,
  });
}
