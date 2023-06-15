import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/colors.dart';
import '../../utils/fonts.dart';

class PrintTransactionTile extends StatelessWidget {
  const PrintTransactionTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onTap,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final IconData icon;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.0),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          leading: CircleAvatar(
            radius: 15.r,
            backgroundColor: primary,
            child: Icon(icon, color: white, size: 15),
          ),
          title: Text(title),
          subtitle: Text(
            subtitle,
            style: lato.copyWith(fontSize: 10.sp, color: Colors.grey[600]),
          ),
        ),
      ),
    );
  }
}
