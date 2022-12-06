import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import 'blurhash.dart';

const DEFAULT_SIZE = 32;

class BlurHashImage extends ImageProvider<BlurHashImage> {
  const BlurHashImage(this.blurHash,
      {this.decodingWidth = DEFAULT_SIZE, this.decodingHeight = DEFAULT_SIZE, this.scale = 1.0});

  final String blurHash;
  final double scale;
  final int decodingWidth;
  final int decodingHeight;

  @override
  Future<BlurHashImage> obtainKey(ImageConfiguration configuration) => SynchronousFuture<BlurHashImage>(this);

  @override
  ImageStreamCompleter load(BlurHashImage key, DecoderCallback decode) => OneFrameImageStreamCompleter(_loadAsync(key));

  Future<ImageInfo> _loadAsync(BlurHashImage key) async {
    assert(key == this);

    final image = await blurHashDecodeImage(
      blurHash: blurHash,
      width: decodingWidth,
      height: decodingHeight,
    );
    return ImageInfo(image: image, scale: key.scale);
  }

  @override
  bool operator ==(Object other) => other.runtimeType != runtimeType
      ? false
      : other is BlurHashImage && other.blurHash == blurHash && other.scale == scale;

  @override
  int get hashCode => hashValues(blurHash.hashCode, scale);

  @override
  String toString() => '$runtimeType($blurHash, scale: $scale)';
}
