import 'dart:typed_data';

/// This is the way we store responses of images while we are downloading them
/// over the network.
class ImageModel {
    Uint8List? list;
    bool error;
    String? message;
    ImageModel(this.error, this.list, this.message);
}

/// The single instance we require.
ImageInfoStore? _instance;

/// We use this class to store the information we use to standardize the height
/// and width of all the images inside the app.
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