import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../my_image/image/image.dart';
import 'image_provider/cached_network_image_provider.dart';

typedef ImageWidgetBuilder = Widget Function(
  BuildContext context,
  ImageProvider imageProvider,
);

typedef PlaceholderWidgetBuilder = Widget Function(
  BuildContext context,
  String url,
);

typedef ProgressIndicatorBuilder = Widget Function(
  BuildContext context,
  String url,
  DownloadProgress progress,
);

typedef LoadingErrorWidgetBuilder = Widget Function(
  BuildContext context,
  String url,
  dynamic error,
);

class CachedNetworkImage extends StatelessWidget {
  static CacheManagerLogLevel get logLevel => CacheManager.logLevel;

  static set logLevel(CacheManagerLogLevel level) => CacheManager.logLevel = level;

  static Future evictFromCache(
    String url, {
    String? cacheKey,
    BaseCacheManager? cacheManager,
    double scale = 1.0,
  }) async {
    cacheManager = cacheManager ?? DefaultCacheManager();
    await cacheManager.removeFile(cacheKey ?? url);
    return CachedNetworkImageProvider(url, scale: scale).evict();
  }

  final CachedNetworkImageProvider _image;

  final BaseCacheManager? cacheManager;

  final String imageUrl;

  final String? cacheKey;
  final ImageWidgetBuilder? imageBuilder;
  final PlaceholderWidgetBuilder? placeholder;
  final ProgressIndicatorBuilder? progressIndicatorBuilder;
  final LoadingErrorWidgetBuilder? errorWidget;
  final Duration? placeholderFadeInDuration;
  final Duration? fadeOutDuration;
  final Curve fadeOutCurve;
  final Duration fadeInDuration;
  final Curve fadeInCurve;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Alignment alignment;
  final ImageRepeat repeat;
  final bool matchTextDirection;
  final Map<String, String>? httpHeaders;
  final bool useOldImageOnUrlChange;
  final Color? color;
  final BlendMode? colorBlendMode;
  final FilterQuality filterQuality;
  final int? memCacheWidth;
  final int? memCacheHeight;
  final int? maxWidthDiskCache;
  final int? maxHeightDiskCache;

  CachedNetworkImage({
    Key? key,
    required this.imageUrl,
    this.httpHeaders,
    this.imageBuilder,
    this.placeholder,
    this.progressIndicatorBuilder,
    this.errorWidget,
    this.fadeOutDuration = const Duration(milliseconds: 1000),
    this.fadeOutCurve = Curves.easeOut,
    this.fadeInDuration = const Duration(milliseconds: 500),
    this.fadeInCurve = Curves.easeIn,
    this.width,
    this.height,
    this.fit,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.matchTextDirection = false,
    this.cacheManager,
    this.useOldImageOnUrlChange = false,
    this.color,
    this.filterQuality = FilterQuality.low,
    this.colorBlendMode,
    this.placeholderFadeInDuration,
    this.memCacheWidth,
    this.memCacheHeight,
    this.cacheKey,
    this.maxWidthDiskCache,
    this.maxHeightDiskCache,
  })  : _image = CachedNetworkImageProvider(
          imageUrl,
          headers: httpHeaders,
          cacheManager: cacheManager,
          cacheKey: cacheKey,
          maxWidth: maxWidthDiskCache,
          maxHeight: maxHeightDiskCache,
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var myPlaceholderBuilder = placeholder != null ? _myPlaceholderBuilder : null;
    var myProgressIndicatorBuilder = progressIndicatorBuilder != null ? _myProgressIndicatorBuilder : null;

    if (myPlaceholderBuilder == null && myProgressIndicatorBuilder == null) {
      myPlaceholderBuilder = (context) => Container();
    }

    return MyImage(
      image: _image,
      imageBuilder: imageBuilder != null ? _myImageBuilder : null,
      placeholderBuilder: myPlaceholderBuilder,
      progressIndicatorBuilder: myProgressIndicatorBuilder,
      errorBuilder: errorWidget != null ? _myErrorBuilder : null,
      fadeOutDuration: fadeOutDuration,
      fadeOutCurve: fadeOutCurve,
      fadeInDuration: fadeInDuration,
      fadeInCurve: fadeInCurve,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      matchTextDirection: matchTextDirection,
      color: color,
      filterQuality: filterQuality,
      colorBlendMode: colorBlendMode,
      placeholderFadeInDuration: placeholderFadeInDuration,
      gaplessPlayback: useOldImageOnUrlChange,
      memCacheWidth: memCacheWidth,
      memCacheHeight: memCacheHeight,
    );
  }

  Widget _myImageBuilder(BuildContext context, Widget child) {
    return imageBuilder!(context, _image);
  }

  Widget _myPlaceholderBuilder(BuildContext context) {
    return placeholder!(context, imageUrl);
  }

  Widget _myProgressIndicatorBuilder(
    BuildContext context,
    ImageChunkEvent? progress,
  ) {
    int? totalSize;
    var downloaded = 0;
    if (progress != null) {
      totalSize = progress.expectedTotalBytes;
      downloaded = progress.cumulativeBytesLoaded;
    }
    return progressIndicatorBuilder!(context, imageUrl, DownloadProgress(imageUrl, totalSize, downloaded));
  }

  Widget _myErrorBuilder(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    return errorWidget!(context, imageUrl, error);
  }
}
