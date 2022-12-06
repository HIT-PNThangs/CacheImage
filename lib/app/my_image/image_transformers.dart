import 'package:flutter/material.dart';

import 'image/image.dart';

class MyImageTransformer {
  /// Clips the image as a circle, like a [CircleAvatar]
  static MyImageBuilder circleAvatar() {
    return (context, child) => Center(
          child: AspectRatio(
            aspectRatio: 1.0,
            child: ClipOval(
              child: child,
            ),
          ),
        );
  }
}
