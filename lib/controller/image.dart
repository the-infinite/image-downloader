import 'dart:isolate';
import 'dart:typed_data';

import 'package:imageloader/model/image.dart';
import 'package:imageloader/service/image.dart';

void getImageSync(SendPort port, OnDownloadImage callback) async {
    getRandomImage((total, downloaded, progress) {
        callback(total, downloaded, progress);
    })

    // On error... we send an error report.
    .onError((error, stackTrace) {
        // Send an error when we get an error
        port.send(ImageModel(true, null, error.toString()));

        // Just appease this one.
        return Uint8List(0);
    })

    // When there is no error, get the image.
    .then((data) {
        // Send the image when we get an image.
        port.send(ImageModel(false, data, null));

        // Just appease this one.
        return data;
    });   
}
