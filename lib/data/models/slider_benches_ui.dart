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

  int getInitPage() {
    var initPage = 0;
    if (benches != null && currentBenches != null && benches.isNotEmpty) {
      var index = benches.indexOf(currentBenches);
      if (index > 0) {
        initPage = index;
      }
    }
    return initPage;
  }
}
