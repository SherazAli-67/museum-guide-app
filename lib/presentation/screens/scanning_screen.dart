import 'package:flutter/material.dart';
import 'package:musuem_guide_app_ui/constants/string_const.dart';

class ScanningScreen extends StatelessWidget {
  const ScanningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text(StringConst.scanning),),
    );
  }
}
