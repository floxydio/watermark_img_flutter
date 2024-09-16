import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

extension FileToBase64 on File {
  Future<String> toBase64() async {
    Uint8List bytes = await readAsBytes();
    return base64Encode(bytes);
  }
}


// example usage 

/*
File yourFile = File("assets/image/example.png")
String base64 = await yourFile.toBase64();

*/