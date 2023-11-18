import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:imageloader/component/image_view.dart';
import 'package:imageloader/model/image.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    var listNotifier = ValueNotifier<List<Widget>>([]);
    final completeList = List<Widget>.empty(growable: true);

    // Initiaize the Image Info store with the right size parameters
    ImageInfoStore.getInstance(300, size.width);

    return Scaffold(
        body: SafeArea(
            child: SizedBox(
            height: size.height,
            width: size.width,
            child: Expanded(
                child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      SizedBox(
                        height: size.height,
                        width: size.width,
                        child: ValueListenableBuilder(
                          valueListenable: listNotifier,
                          builder: (context, list, index) {
                            // Return this as you see it.
                            return GridView(
                              addAutomaticKeepAlives: false,
                              padding: const EdgeInsets.all(10),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing:10,
                                mainAxisSpacing: 10,
                              ),
                              children: list,
                            );
                          }
                        )
                      ),

                      TextButton(
                        onPressed: () {
                            final list = List<Widget>.empty(growable: true);

                            // First, add everything in the complete list.
                            if(completeList.isNotEmpty) {
                                list.addAll(completeList);
                            }

                            // Add 7 items to it then...
                            for(int i = 0; i < 7; i++) {
                                // Build the current item
                                final item = UtilityImageView(ValueNotifier<Uint8List?>(null));

                                // Add it to the list of items.
                                list.add(item);

                                // Add it to the overall list of item.
                                completeList.add(item);
                            }

                            // This is our new list.
                            listNotifier.value = list;
                        },

                        child: Container(
                          padding: const EdgeInsets.only(top: 15, bottom: 15, left: 30, right: 30),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade200,
                            borderRadius: BorderRadius.circular(12)
                          ),
                          child: const Text(
                            "Load more",
                            style: TextStyle(
                                color: Colors.white,
                            )
                          )
                        )
                      )
                    ],
                )
              ),
            )
          )
        );
  }
}
