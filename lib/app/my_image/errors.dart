import 'package:flutter/material.dart';

import 'image/image.dart';
import 'placeholders.dart';

class MyError {
  static MyErrorBuilder blurHash(
    String hash, {
    BoxFit? fit,
    Text? message,
    IconData? icon,
    Color? iconColor,
    double? iconSize,
  }) {
    return placeholderWithErrorIcon(
      MyPlaceholder.blurHash(hash, fit: fit),
      message: message,
      icon: icon,
      iconColor: iconColor,
      iconSize: iconSize,
    );
  }

  /// Displays a [CircleAvatar] as errorWidget
  static MyErrorBuilder circleAvatar({
    required Color backgroundColor,
    required Widget text,
  }) {
    return (context, error, stacktrace) => SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: CircleAvatar(
            backgroundColor: backgroundColor,
            child: text,
          ),
        );
  }

  static MyErrorBuilder icon({
    IconData icon = Icons.error,
    Color? color,
  }) {
    return (context, error, stacktrace) => Icon(
          icon,
          color: color,
        );
  }

  static MyErrorBuilder placeholderWithErrorIcon(
    MyPlaceholderBuilder placeholderBuilder, {
    IconData? icon,
    Color? iconColor,
    double? iconSize,
    Text? message,
  }) {
    icon ??= Icons.error_outline;
    iconSize ??= 30.0;
    return (context, error, stacktrace) => Stack(
          alignment: Alignment.center,
          children: [
            placeholderBuilder(context),
            Opacity(
                opacity: 0.75,
                child: Icon(
                  icon,
                  size: iconSize,
                  color: iconColor,
                )),
            if (message != null)
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: message,
                ),
              )
          ],
        );
  }
}
