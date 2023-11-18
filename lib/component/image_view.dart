import 'dart:isolate';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:imageloader/component/shimmer_view.dart';
import 'package:imageloader/controller/image.dart';
import 'package:imageloader/model/image.dart';

class UtilityImageView extends StatefulWidget {
  final ValueNotifier<Uint8List?> imageNotifier;

  const UtilityImageView(this.imageNotifier, {Key? key}) : super(key: key);

  @override
  State<UtilityImageView> createState() => _UtilityImageViewState();
}

class _UtilityImageViewState extends State<UtilityImageView> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    //* After this widget has been built...
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //? If there is not any imagehere yet...
      if(widget.imageNotifier.value == null && !loading) {
        //* We are now loading.
        loading = true;

        //* Load a random image bruh...
        await loadImage(context, widget.imageNotifier);
      }
    });

    return ValueListenableBuilder(
        valueListenable: widget.imageNotifier,
        builder: ((context, value, child) {
          if (value == null) {
            return const ShimmerView();
          }

          // Get this since we need it.
          final info = ImageInfoStore.getInstance(0, 0);

          // Build the image view.
          return Container(
            height: info.height,
            width: info.width,
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: null,
            ),
            child: Stack(children: [
                // Load the image from the array as we have it.
                Image.memory(
                    value, 
                    fit: BoxFit.cover, 
                    height: info.height, 
                    width: info.width
                ),

                // Apply the filter.
                Positioned.fill(
                  child: BackdropFilter(
                      filter: ImageFilter.blur(),
                      child: ColoredBox(
                        color: Colors.black.withOpacity(0)
                      ),
                  ),
                )
              ]
            ),
          );
        }
      )
    );
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
