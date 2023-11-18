import 'dart:isolate';
import 'dart:typed_data';

import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:imageloader/component/shimmer_view.dart';
import 'package:imageloader/controller/image.dart';
import 'package:imageloader/model/image.dart';

class UtilityImageView extends StatelessWidget {
  final ValueNotifier<Uint8List?> imageNotifier;

  const UtilityImageView(this.imageNotifier, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //* After this widget has been built...
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //* Load a random image bruh...
      await loadImage(context, imageNotifier);

      //* Next, we apply the filters.
    });

    return ValueListenableBuilder(
        valueListenable: imageNotifier,
        builder: ((context, value, child) {
          if (value == null) {
            return const ShimmerView();
          }

          return Container(
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: null,
            ),
            child: Image.memory(value),
          );
        }));
  }
}

Future loadImage(
    BuildContext context, 
    ValueNotifier<Uint8List?> notifier
) async {
  final port = ReceivePort();
  await Isolate.spawn(getImageSync, port.sendPort);
  port.listen((value) {
    // Cast this to an image model.
    final imageModel = value as ImageModel;

    //? If this had an error.
    if (imageModel.error) {
      // Show the error and leave.
      context.showErrorBar(content: Text("${imageModel.message}"));
      return;
    }

    //* If this did not have an error.
    notifier.value = imageModel.list;
  });
}
