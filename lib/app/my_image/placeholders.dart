import 'package:flutter/material.dart';

import '../blurhash/blurhash_image.dart';
import 'image/image.dart';

class MyPlaceholder {
  static MyPlaceholderBuilder blurHash(String hash, {BoxFit? fit}) {
    return (context) => SizedBox.expand(
          child: Image(
            image: BlurHashImage(hash),
            fit: fit ?? BoxFit.cover,
          ),
        );
  }

  static MyPlaceholderBuilder circleAvatar({
    required Color backgroundColor,
    required Widget text,
  }) {
    return (context) => SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: CircleAvatar(
            backgroundColor: backgroundColor,
            child: text,
          ),
        );
  }

  static MyPlaceholderBuilder circularProgressIndicator() {
    return (context) => const Center(
          child: CircularProgressIndicator(),
        );
  }

  static MyPlaceholderBuilder frame() {
    return (context) => const SizedBox.expand(child: Placeholder());
  }
}
