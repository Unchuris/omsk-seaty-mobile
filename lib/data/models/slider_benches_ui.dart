import 'package:flutter/cupertino.dart';

import 'bench_light.dart';

class SliderBenchesUi {
  BenchLight currentBenches;
  List<BenchLight> benches;
  bool isClusterState = false;

  SliderBenchesUi(
      {@required this.benches, this.currentBenches, this.isClusterState});

  static SliderBenchesUi from(SliderBenchesUi sliderBenchesUi) {
    return SliderBenchesUi(
        benches: sliderBenchesUi.benches.toList(),
        currentBenches: sliderBenchesUi.currentBenches,
        isClusterState: sliderBenchesUi.isClusterState);
  }
}
