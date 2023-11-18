import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_masonry_view/flutter_masonry_view.dart';
import 'package:imageloader/component/image_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
        body: SafeArea(
            child: SizedBox(
      height: size.height,
      width: size.width,
      child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: MasonryView(
              listOfItem: List.generate(100, (index) => index),
              numberOfColumn: 2,
              itemBuilder: (image) {
                return UtilityImageView(ValueNotifier<Uint8List?>(null));
              })),
    )));
  }
}
