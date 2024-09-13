import 'package:flutter/material.dart';

class KeyWatermark {
  static final KeyWatermark _instance = KeyWatermark._internal();
  factory KeyWatermark() => _instance;
  KeyWatermark._internal();

  final GlobalKey<State<StatefulWidget>> _key = GlobalKey();

  GlobalKey<State<StatefulWidget>> get key => _key;
}
