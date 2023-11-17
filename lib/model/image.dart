import 'dart:typed_data';

class ImageModel {
    Uint8List? list;
    bool error;
    String? message;
    ImageModel(this.error, this.list, this.message);
}