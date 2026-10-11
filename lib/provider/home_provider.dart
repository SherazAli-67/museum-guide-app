import 'package:flutter/foundation.dart';
import 'package:musuem_guide_app_ui/core/app_data.dart';
import 'package:musuem_guide_app_ui/core/models/exhibit_model.dart';

class HomeProvider extends ChangeNotifier {
  String _query = '';

  String get query => _query;

  List<ExhibitModel> get nearbyExhibits => _filter(AppData.nearbyExhibits);

  List<ExhibitModel> get firstFloorExhibits => _filter(AppData.firstFloorExhibits);

  void updateQuery(String value) {
    if (_query == value) return;
    _query = value;
    notifyListeners();
  }

  List<ExhibitModel> _filter(List<ExhibitModel> source) {
    final normalized = _query.trim().toLowerCase();
    if (normalized.isEmpty) return source;
    return source.where((exhibit) => exhibit.title.toLowerCase().contains(normalized)).toList();
  }
}
