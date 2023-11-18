import 'package:flutter/material.dart';
import 'package:imageloader/model/image.dart';

class ShimmerView extends StatelessWidget {
  const ShimmerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ImageInfoStore.getInstance(0, 0).height,
      width: ImageInfoStore.getInstance(0, 0).width,
      padding: const EdgeInsets.all(0),
      color: Colors.grey,
    );
  }
}
