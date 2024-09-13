import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

import 'package:path_provider/path_provider.dart';

class WaterMarkImg {
  static Future<Uint8List> convertImgToUint(
      {GlobalKey<State<StatefulWidget>>? renderKey}) async {
    try {
      final RenderRepaintBoundary boundary = renderKey?.currentContext
          ?.findRenderObject()! as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage(pixelRatio: 3);
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      return byteData!.buffer.asUint8List();
    } catch (_) {
      rethrow;
    }
  }

  Future<File?> saveImageFromUint8List(Uint8List bytes, String fileName) async {
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/$fileName');
      await file.writeAsBytes(bytes);
      return file;
    } catch (_) {
      rethrow;
    }
  }
}
