import 'package:flutter/foundation.dart';
import 'package:musuem_guide_app_ui/core/app_data.dart';
import 'package:musuem_guide_app_ui/core/models/exhibit_model.dart';

class ScanningHotspotModel {
  final ExhibitModel exhibit;
  final double left;
  final double top;

  const ScanningHotspotModel({
    required this.exhibit,
    required this.left,
    required this.top,
  });
}

class ScanningProvider extends ChangeNotifier {
  static const designWidth = 428.0;
  static const designHeight = 926.0;

  static const hotspots = <ScanningHotspotModel>[
    ScanningHotspotModel(exhibit: AppData.lincolnStand, left: 182, top: 344),
    ScanningHotspotModel(exhibit: AppData.restAndPray, left: 53, top: 485),
    ScanningHotspotModel(exhibit: AppData.royalAlbert, left: 122, top: 572),
    ScanningHotspotModel(exhibit: AppData.theWhiteLie, left: 327.06, top: 573),
  ];

  int _selectedIndex = 3;

  int get selectedIndex => _selectedIndex;

  ScanningHotspotModel get selectedHotspot => hotspots[_selectedIndex];

  ExhibitModel get selectedExhibit => selectedHotspot.exhibit;

  void selectHotspot(int index) {
    if (index < 0 || index >= hotspots.length || index == _selectedIndex) return;
    _selectedIndex = index;
    notifyListeners();
  }
}
