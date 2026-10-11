class ExhibitModel {
  final String id;
  final String title;
  final String yearLabel;
  final String? shortYearLabel;
  final String imagePath;
  final String thumbnailPath;
  final String? directionLabel;
  final int? stepsAway;
  final String description;
  final String? floorLabel;

  const ExhibitModel({
    required this.id,
    required this.title,
    required this.yearLabel,
    this.shortYearLabel,
    required this.imagePath,
    required this.thumbnailPath,
    this.directionLabel,
    this.stepsAway,
    required this.description,
    this.floorLabel,
  });

  String get displayShortYear => shortYearLabel ?? yearLabel;
}
