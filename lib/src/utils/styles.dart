import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'colors.dart';
import 'fonts.dart';

ButtonStyle elevatedButtonStyle({
  Color? backgroundColor,
  EdgeInsetsGeometry? padding,
  BorderRadiusGeometry? radius,
}) =>
    ElevatedButton.styleFrom(
      padding: padding ?? const EdgeInsets.all(16.0),
      backgroundColor: backgroundColor ?? primary,
      shape: RoundedRectangleBorder(
        borderRadius: radius ?? BorderRadius.circular(10.0),
      ),
    );

ButtonStyle outlineButtonStyle({
  Color? backgroundColor,
  EdgeInsetsGeometry? padding,
  BorderRadiusGeometry? radius,
}) =>
    OutlinedButton.styleFrom(
      padding: padding ?? const EdgeInsets.all(16.0),
      // backgroundColor: backgroundColor ?? primary,
      shape: RoundedRectangleBorder(
        borderRadius: radius ?? BorderRadius.circular(10.0),
      ),
    );

InputDecoration inputDecorationRounded({double? radius}) => InputDecoration(
      filled: true,
      isDense: true,
      fillColor: Colors.grey[200],
      contentPadding: const EdgeInsets.all(16.0),
      hintStyle: lato.copyWith(fontSize: 12.0),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(radius ?? 10.r),
      ),
    );
