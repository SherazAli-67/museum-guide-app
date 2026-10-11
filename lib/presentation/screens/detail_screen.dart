import 'package:flutter/material.dart';
import 'package:musuem_guide_app_ui/core/app_data.dart';

class DetailScreen extends StatelessWidget {
  final String exhibitId;

  const DetailScreen({super.key, required this.exhibitId});

  @override
  Widget build(BuildContext context) {
    final exhibit = AppData.exhibitById(exhibitId);
    return Scaffold(
      body: Center(child: Text(exhibit?.title ?? exhibitId),),
    );
  }
}
