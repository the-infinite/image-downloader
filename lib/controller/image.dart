import 'dart:developer';
import 'dart:isolate';

import 'package:imageloader/model/image.dart';
import 'package:imageloader/service/image.dart';

void getImageSync(SendPort port) async {
    try {
        final bytes = await getRandomImage((total, downloaded, progress) {
            // Fow now we do nothing...
            log("Downloaded $progress% ", time: DateTime.now());
        });

        // Send the image when we get an image.
        port.send(ImageModel(false, bytes, null));
    }

    catch(error) {
        // Send an error when we get an error
        port.send(ImageModel(true, null, error.toString()));
    }  
}
