import 'package:flutter/widgets.dart';
import 'package:watermark_img/watermark_img.dart';

class ScreenWatermark extends StatefulWidget {
  final Widget child;
  const ScreenWatermark({super.key, required this.child});

  @override
  State<ScreenWatermark> createState() => _ScreenWatermarkState();
}

class _ScreenWatermarkState extends State<ScreenWatermark> {
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(key: KeyWatermark().key, child: widget.child);
  }
}
