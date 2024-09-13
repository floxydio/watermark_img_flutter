import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

import 'package:path_provider/path_provider.dart';

class WaterMarkImg {
  static Future<Uint8List?> convertImgToUint({
    GlobalKey<State<StatefulWidget>>? renderKey,
  }) async {
    try {
      if (renderKey == null || renderKey.currentContext == null) {
        return null;
      }
      final RenderRepaintBoundary? boundary = renderKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary?;

      if (boundary == null) {
        return null;
      }
      final ui.Image image = await boundary.toImage(pixelRatio: 3);
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        return null;
      }

      return byteData.buffer.asUint8List();
    } catch (e) {
      return null;
    }
  }

  Future<File?> saveImageFromUint8List(Uint8List bytes, String fileName) async {
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/$fileName');
      await file.writeAsBytes(bytes);
      return file;
    } catch (e) {
      return null;
    }
  }
}
