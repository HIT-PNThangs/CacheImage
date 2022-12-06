import 'package:flutter/widgets.dart';

import 'fade_widget.dart';
import 'image.dart';

enum _PlaceholderType {
  none,
  static,
  progress,
}

class ImageHandler {
  final ImageProvider image;

  final double? width;
  final double? height;

  final BoxFit? fit;

  final AlignmentGeometry alignment;

  final ImageRepeat repeat;

  final bool matchTextDirection;

  final Color? color;

  final BlendMode? colorBlendMode;

  final FilterQuality filterQuality;

  late _PlaceholderType _placeholderType;

  final MyImageBuilder? imageBuilder;

  final MyPlaceholderBuilder? placeholderBuilder;

  final MyProgressIndicatorBuilder? progressIndicatorBuilder;

  final MyErrorBuilder? errorBuilder;

  final Duration placeholderFadeInDuration;

  final Duration fadeOutDuration;

  final Curve fadeOutCurve;

  final Duration fadeInDuration;

  final Curve fadeInCurve;

  bool alwaysShowPlaceHolder;

  ImageHandler({
    required this.image,
    required this.width,
    required this.height,
    required this.fit,
    required this.alignment,
    required this.repeat,
    required this.matchTextDirection,
    required this.color,
    required this.colorBlendMode,
    required this.filterQuality,
    required this.imageBuilder,
    required this.placeholderBuilder,
    required this.progressIndicatorBuilder,
    required this.errorBuilder,
    required this.placeholderFadeInDuration,
    required this.fadeOutDuration,
    required this.fadeOutCurve,
    required this.fadeInDuration,
    required this.fadeInCurve,
    required this.alwaysShowPlaceHolder,
  }) {
    _placeholderType = _definePlaceholderType();
  }

  ImageFrameBuilder imageFrameBuilder() {
    switch (_placeholderType) {
      case _PlaceholderType.none:
        return _imageBuilder;
      case _PlaceholderType.static:
        return _placeholderBuilder;
      case _PlaceholderType.progress:
        return _preLoadingBuilder;
    }
  }

  ImageLoadingBuilder? imageLoadingBuilder() {
    return _placeholderType == _PlaceholderType.progress ? _loadingBuilder : null;
  }

  ImageErrorWidgetBuilder? errorWidgetBuilder() {
    return errorBuilder != null ? _errorBuilder : null;
  }

  Widget build(BuildContext context) {
    return Image(
      key: ValueKey(image),
      image: image,
      loadingBuilder: imageLoadingBuilder(),
      frameBuilder: imageFrameBuilder(),
      errorBuilder: errorWidgetBuilder(),
      fit: fit,
      width: width,
      height: height,
      alignment: alignment,
      repeat: repeat,
      color: color,
      colorBlendMode: colorBlendMode,
      matchTextDirection: matchTextDirection,
      filterQuality: filterQuality,
    );
  }

  Widget _stack(Widget revealing, Widget disappearing) {
    return Stack(
      fit: StackFit.passthrough,
      alignment: Alignment.center,
      children: [
        FadeWidget(
          duration: fadeInDuration,
          curve: fadeInCurve,
          child: revealing,
        ),
        FadeWidget(
          duration: fadeOutDuration,
          curve: fadeOutCurve,
          direction: AnimationDirection.reverse,
          child: disappearing,
        )
      ],
    );
  }

  Widget _imageBuilder(BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
    if (frame == null) {
      return child;
    }
    return _image(context, child);
  }

  Widget _placeholderBuilder(BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
    if (frame == null) {
      if (placeholderFadeInDuration != Duration.zero) {
        return FadeWidget(
          duration: placeholderFadeInDuration,
          curve: fadeInCurve,
          child: _placeholder(context),
        );
      } else {
        return _placeholder(context);
      }
    }
    if (wasSynchronouslyLoaded && !alwaysShowPlaceHolder) {
      return _image(context, child);
    }
    return _stack(
      _image(context, child),
      _placeholder(context),
    );
  }

  bool _wasSynchronouslyLoaded = false;
  bool _isLoaded = false;

  Widget _preLoadingBuilder(BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
    _wasSynchronouslyLoaded = wasSynchronouslyLoaded;
    _isLoaded = frame != null;
    return child;
  }

  Widget _loadingBuilder(BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
    if (_isLoaded) {
      if (_wasSynchronouslyLoaded) {
        return _image(context, child);
      }
      return _stack(
        _image(context, child),
        _progressIndicator(context, null),
      );
    }

    if (placeholderFadeInDuration != Duration.zero) {
      return FadeWidget(
        duration: placeholderFadeInDuration,
        curve: fadeInCurve,
        child: _progressIndicator(context, loadingProgress),
      );
    } else {
      return _progressIndicator(context, loadingProgress);
    }
  }

  Widget _image(BuildContext context, Widget child) {
    if (imageBuilder != null) {
      return imageBuilder!(context, child);
    } else {
      return child;
    }
  }

  Widget _errorBuilder(
    BuildContext context,
    Object error,
    StackTrace? stacktrace,
  ) {
    if (errorBuilder == null) {
      throw StateError('Try to build errorBuilder with errorBuilder null');
    }

    return errorBuilder!(context, error, stacktrace);
  }

  Widget _progressIndicator(BuildContext context, ImageChunkEvent? loadingProgress) {
    if (progressIndicatorBuilder == null) {
      throw StateError('Try to build progressIndicatorBuilder with progressIndicatorBuilder null');
    }

    return progressIndicatorBuilder!(context, loadingProgress);
  }

  Widget _placeholder(BuildContext context) {
    if (placeholderBuilder != null) {
      return placeholderBuilder!(context);
    }

    return Container();
  }

  _PlaceholderType _definePlaceholderType() {
    assert(placeholderBuilder == null || progressIndicatorBuilder == null);

    if (placeholderBuilder != null) return _PlaceholderType.static;

    if (progressIndicatorBuilder != null) {
      return _PlaceholderType.progress;
    }

    return _PlaceholderType.none;
  }
}
