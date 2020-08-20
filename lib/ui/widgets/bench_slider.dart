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
  BenchSliderOptions get options => widget.options ?? BenchSliderOptions();

  List<BenchLight> get items => widget.items ?? List<BenchLight>();

  final CarouselControllerImpl _carouselController;

  _BenchSlider(this._carouselController);

  BenchLight currentBench;

  @override
  void initState() {
    super.initState();
  }

  void onPageChanged(int index, CarouselPageChangedReason changeReason) {
    if (index < items.length) {
      currentBench = items[index];
      options.onPageChanged(currentBench);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: _getBenches(onClick: (BenchLight benchLight) {
        if (currentBench.id == benchLight.id) {
          options.onItemClicked(benchLight);
        } else {
          _carouselController.animateToPage(items.indexOf(benchLight));
        }
      }),
      options: CarouselOptions(
          enlargeCenterPage: options.enlargeCenterPage,
          enableInfiniteScroll: options.enableInfiniteScroll,
          onPageChanged: onPageChanged,
          height: options.height),
      carouselController: _carouselController,
    );
  }

  List<Widget> _getBenches({Function onClick}) => items
      .map((item) => GestureDetector(onTap: () => onClick(item), child: BenchCard(bench: item)))
      .toList();
}

class BenchSliderOptions {
  final double height;

  final bool enableInfiniteScroll;
  final bool enlargeCenterPage;

  final Function(BenchLight benchLight) onPageChanged;
  final Function(BenchLight benchLight) onItemClicked;

  BenchSliderOptions({
    this.enlargeCenterPage: true,
    this.height,
    this.enableInfiniteScroll: false,
    this.onPageChanged,
    this.onItemClicked,
  });
}
