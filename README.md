
## About watermark_img

The purpose of creating watermark_img is to add a widget to an image, for example, if you want to add text to an image, whether the position is at the top left, top right, or bottom, depending on the widget you use.


## How To Use

Import this package to pubspec.yaml

```dart
watermark_img: 0.0.1
```

And for its usage, I have already created it in example/main.dart.

Simply call the widget.

```dart
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
```
The 'child' in ScreenWatermark is required and can be combined with any widget you want.

For the process of saving an image, it can be combined with other packages. You can check example/main.dart for more details. Below is an example of a button that initiates the save process.

```dart
ElevatedButton(
                  onPressed: () async {
                    final Uint8List bytes = await WaterMarkImg.convertImgToUint(
                        renderKey: KeyWatermark().key);
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
                              print('Image saved');
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
                              print('Image saved');
                              fileImage = XFile(file.path);
                            }
                          }
                        }
                      } else if (Platform.isIOS) {
                        final directory = await getTemporaryDirectory();
                        final file = File('${directory.path}/watermark.png');
                        await file.writeAsBytes(bytes);
                        final result = await ImageGallerySaver.saveImage(bytes);
                        if (result != null) {
                          print('Image saved');
                          fileImage = XFile(file.path);
                        }
                      }
                    } else {}
                  },
                  child: const Text("Check Image + Save")),
```


This package uses RepaintBoundary and Key in a StatefulWidget, but I have simplified it further.


## TODO For Next Version

- Can this package be used repeatedly within a single state or not?
- Testing this package for iOS
- Testing this package all Android versions

If there are any bugs or errors in the package, or if you have ideas for new features, feel free to create a pull request on GitHub.

## Authors

- [Dio Okta R](https://www.github.com/floxydio)

