import 'dart:typed_data';

class ImageModel {
    Uint8List? list;
    bool error;
    String? message;
    ImageModel(this.error, this.list, this.message);
}

/// The single instance we require.
ImageInfoStore? _instance;

/// We use this class to
class ImageInfoStore {
    final double height;
    final double width;

    const ImageInfoStore(this.height, this.width);

    static ImageInfoStore getInstance(double height, double width) {
        //! If this is null, initialize it.
        _instance ??= ImageInfoStore(height, (width * 0.5) - 10);

        //* Return what we have.
        return _instance!;
    }
}