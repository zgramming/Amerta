// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/fonts.dart';

class TransactionInfoRow extends StatelessWidget {
  const TransactionInfoRow({
    Key? key,
    required this.icon,
    this.iconColor,
    required this.title,
    this.content,
    this.titleStyle,
    this.contentStyle,
  }) : super(key: key);

  final IconData icon;
  final Color? iconColor;
  final String title;
  final String? content;

  final TextStyle? titleStyle;
  final TextStyle? contentStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: iconColor ?? Colors.white,
          size: 10.sp,
        ),
        const SizedBox(width: 10.0),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: title,
                style: titleStyle,
              ),
              TextSpan(
                text: content,
                style: contentStyle ??
                    latoWhite.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          style: latoWhite.copyWith(fontSize: 10.sp),
        ),
      ],
    );
  }
}
