import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:watermark_img/watermark_img.dart';
import 'package:watermark_img/helpers/saver.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(useMaterial3: false),
    debugShowCheckedModeBanner: false,
    home: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  XFile? fileImage;

  Future<bool> _requestStoragePermission() async {
    if (await Permission.storage.isGranted) {
      return true;
    } else {
      var status = await Permission.storage.request();
      return status.isGranted;
    }
  }

  Future<bool> _requestPhotosPermission() async {
    if (await Permission.photos.isGranted) {
      return true;
    } else {
      var status = await Permission.photos.request();
      return status.isGranted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              ScreenWatermark(
                  child: Stack(
                children: [
                  Image.network(
                    'https://randomuser.me/api/portraits/men/60.jpg',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 300,
                  ),
                  const Center(
                    child: Text(
                      'Watermark',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )),
              ElevatedButton(
                  onPressed: () async {
                    final Uint8List? bytes =
                        await WaterMarkImg.convertImgToUint(
                            renderKey: KeyWatermark().key);
                    if (bytes != null) {
                      final File? file = await WaterMarkImg()
                          .saveImageFromUint8List(bytes, 'watermark.png');

                      setState(() {
                        fileImage = XFile(file!.path);
                      });
                      if (file != null) {
                        if (Platform.isAndroid) {
                          final deviceInfo = DeviceInfoPlugin();
                          final androidSdk = await deviceInfo.androidInfo;
                          if (androidSdk.version.sdkInt >= 33) {
                            if (await _requestPhotosPermission()) {
                              final directory = await getTemporaryDirectory();
                              final file =
                                  File('${directory.path}/watermark.png');
                              await file.writeAsBytes(bytes);
                              final result =
                                  await ImageGallerySaver.saveImage(bytes);
                              if (result != null) {
                                // print('Image saved');
                                fileImage = XFile(file.path);
                              }
                            }
                          } else {
                            if (await _requestStoragePermission()) {
                              final directory = await getTemporaryDirectory();
                              final file =
                                  File('${directory.path}/watermark.png');
                              await file.writeAsBytes(bytes);
                              final result =
                                  await ImageGallerySaver.saveFile(file.path);
                              if (result != null) {
                                // print('Image saved');
                                fileImage = XFile(file.path);
                              }
                            }
                          }
                        } else if (Platform.isIOS) {
                          final directory = await getTemporaryDirectory();
                          final file = File('${directory.path}/watermark.png');
                          await file.writeAsBytes(bytes);
                          final result =
                              await ImageGallerySaver.saveImage(bytes);
                          if (result != null) {
                            // print('Image saved');
                            fileImage = XFile(file.path);
                          }
                        }
                      }
                    }
                  },
                  child: const Text("Check Image + Save")),
              fileImage != null
                  ? Image.file(
                      File(fileImage!.path),
                      width: 300,
                      height: 300,
                    )
                  : const Text("No Image Found"),
              ElevatedButton(
                  onPressed: () {
                    var toFile =
                        File(fileImage!.path); // convert from Xfile to File
                    toFile.toBase64().then((value) {
                      if (kDebugMode) {
                        print(value); // print base64
                      }
                    });
                  },
                  child: const Text("Convert to base64")),
            ],
          ),
        ),
      ),
    );
  }
}
