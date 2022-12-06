import 'package:flutter/material.dart';

import 'errors.dart';
import 'image/image.dart';
import 'image_transformers.dart';
import 'placeholders.dart';
import 'progress_indicators.dart';

class MySet {
  final MyImageBuilder? imageBuilder;

  final MyPlaceholderBuilder? placeholderBuilder;

  final MyProgressIndicatorBuilder? progressIndicatorBuilder;

  final MyErrorBuilder? errorBuilder;

  MySet._({
    this.imageBuilder,
    this.placeholderBuilder,
    this.progressIndicatorBuilder,
    this.errorBuilder,
  }) : assert(placeholderBuilder != null || progressIndicatorBuilder != null);

  factory MySet.blurHash(
    String hash, {
    BoxFit? fit,
    Text? errorMessage,
  }) {
    return MySet._(
      placeholderBuilder: MyPlaceholder.blurHash(hash, fit: fit),
      errorBuilder: MyError.blurHash(hash, fit: fit),
    );
  }

  factory MySet.circleAvatar({
    required Color backgroundColor,
    required Widget text,
  }) {
    return MySet._(
      placeholderBuilder: MyPlaceholder.circleAvatar(backgroundColor: backgroundColor, text: text),
      imageBuilder: MyImageTransformer.circleAvatar(),
      errorBuilder: MyError.circleAvatar(backgroundColor: backgroundColor, text: text),
    );
  }

  factory MySet.circularIndicatorAndIcon({bool showProgress = false}) {
    return MySet._(
      placeholderBuilder: showProgress ? null : MyPlaceholder.circularProgressIndicator(),
      progressIndicatorBuilder: showProgress ? MyProgressIndicator.circularProgressIndicator() : null,
      errorBuilder: MyError.icon(),
    );
  }
}
