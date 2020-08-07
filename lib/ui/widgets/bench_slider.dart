import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart';

class BenchSlider extends StatefulWidget {
  final BenchSliderOptions options;

  final List<Widget> items;

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

  List<Widget> get items => widget.items ?? List<Widget>();

  final CarouselControllerImpl _carouselController;

  _BenchSlider(this._carouselController);

  Widget currentWidget;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    currentWidget = null;
    super.dispose();
  }

  void onPageChanged(int index, CarouselPageChangedReason changeReason) {
    if (index < items.length) {
      currentWidget = items[index];
      options.onPageChanged(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: _getBenches(onClick: (Widget widget) {
        if (currentWidget == widget) {
          options.onItemClicked(items.indexOf(widget));
        } else {
          _carouselController.animateToPage(items.indexOf(widget));
        }
      }),
      options: CarouselOptions(
          enlargeCenterPage: true,
          enableInfiniteScroll: options.enableInfiniteScroll,
          onPageChanged: onPageChanged,
          height: options.height),
      carouselController: _carouselController,
    );
  }

  List<Widget> _getBenches({Function onClick}) => items
      .map((item) => GestureDetector(onTap: () => onClick(item), child: item))
      .toList();
}

class BenchSliderOptions {
  final double height;

  final bool enableInfiniteScroll;

  final Function(int index) onPageChanged;
  final Function(int index) onItemClicked;

  BenchSliderOptions({
    this.height,
    this.enableInfiniteScroll: true,
    this.onPageChanged,
    this.onItemClicked,
  });
}
