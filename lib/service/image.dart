import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

// The progress for our downloaded image.
typedef OnDownloadImage = void Function(
    int total, int downloaded, double progress);

Future<Uint8List> getRandomImage(OnDownloadImage callback) async {
  try {
    // First, let us send the request and keep the response.
    var request =
        http.Request('GET', Uri.parse("https://picsum.photos/200/300"));
    var client = http.Client();
    var response = client.send(request);

    // Keep the number of downloaded images here.
    int downloaded = 0;

    // Get the completer for this download activity.
    final completer = Completer<Uint8List>();

    // This is where we would keep the pieces of the image we have downloaded.
    final List<List<int>> chunks = List.empty();

    //* Listed to the response as a Stream<T>
    response.asStream().listen((http.StreamedResponse streamedResponse) {
      //? If the status code of this response is not in the 200 range.
      if (streamedResponse.statusCode > 299 ||
          streamedResponse.statusCode < 200) {
        throw "Failed to get an image from the server: ${streamedResponse.reasonPhrase ?? "null"}";
      }

      //* Let's go through the contents of this image then...
      streamedResponse.stream.listen((chunk) {
        // The length of the response in number of bytes.
        final length = streamedResponse.contentLength ?? 0;

        // Fetch the progress of our download in percentage.
        final progress = (downloaded / length) / 100;

        // Invoke the callback with these parameters.
        callback(length, downloaded, progress);

        // Increase the sie of what
        downloaded += chunk.length;

        //* Add this chunk to what we currently have.
        chunks.add(chunk);
      }, onDone: () {
        // Get the length and progress (in %) again
        final completeLength = streamedResponse.contentLength ?? 0;
        final progress = (downloaded / completeLength) / 100;

        // Invoke the callback with these parameters.
        callback(completeLength, downloaded, progress);

        // Initialize the list we plan to return.
        int startOffset = 0;
        final bytes = Uint8List(completeLength);

        // For each of the elements in this place.
        for (var chunk in chunks) {
          // Emplace everything where it is supposed to be.
          bytes.setRange(startOffset, startOffset + chunk.length, chunk);

          // Move the cursor forward so we can write at the right position.
          startOffset += chunk.length;
        }

        // Now, you can complete this function.
        completer.complete(bytes);
      }, onError: (error) => completer.completeError(error));
    });

    // Return the future in this completer.
    return completer.future;
  } catch (e) {
    // First, log this error to the console.
    log("${DateTime.now().toLocal().toIso8601String()}: $e");

    // Next, rethrow it so that the controller can catch this.
    rethrow;
  }
}
