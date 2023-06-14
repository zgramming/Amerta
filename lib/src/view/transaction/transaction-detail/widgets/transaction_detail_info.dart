// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:amerta/src/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'package:amerta/src/utils/enums.dart';

import '../../../../utils/colors.dart';
import '../../../../utils/fonts.dart';
import '../../../widgets/transaction_info_row.dart';

class TransactionDetailInfo extends StatelessWidget {
  const TransactionDetailInfo({
    Key? key,
    this.margin,
    required this.title,
    required this.type,
    required this.amount,
    required this.paid,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.personName,
  }) : super(key: key);

  final EdgeInsetsGeometry? margin;

  final String title;
  final TypeTransaction type;
  final double amount;
  final double paid;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;
  final String personName;

  @override
  Widget build(BuildContext context) {
    final formatDate = DateFormat("d MMMM yyyy");
    final formatAmount = FunctionUtils.convertToIDR(amount);
    final formatPaid = FunctionUtils.convertToIDR(paid);
    final formatRemainingPaid = FunctionUtils.convertToIDR(amount - paid);
    return Stack(
      children: [
        Container(
          margin: margin ?? const EdgeInsets.symmetric(horizontal: 16.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                style: latoWhite.copyWith(fontSize: 16.0.sp),
              ),
              SizedBox(height: 10.h),
              TransactionInfoRow(
                icon: Icons.money_rounded,
                title: "Mempunyai ${type.name} sebesar ",
                content: formatAmount,
              ),
              SizedBox(height: 5.h),
              TransactionInfoRow(
                icon: Icons.payments_rounded,
                title: "Pembayaran sudah masuk ",
                content: formatPaid,
                contentStyle: latoWhite.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5.h),
              TransactionInfoRow(
                icon: Icons.payments_rounded,
                title: "Sisa Pembayaran ",
                content: formatRemainingPaid,
                contentStyle: latoWhite.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5.h),
              TransactionInfoRow(
                icon: Icons.calendar_month,
                title:
                    "Periode ${formatDate.format(startDate)} - ${formatDate.format(endDate)}",
              ),
              SizedBox(height: 5.h),
              TransactionInfoRow(
                icon: Icons.calendar_today,
                title: "Dibuat tanggal ${formatDate.format(createdAt)}",
              ),
              SizedBox(height: 5.h),
              TransactionInfoRow(
                icon: Icons.person,
                title: personName,
              ),
              SizedBox(height: 5.h),
            ],
          ),
        ),
        Positioned(
          right: 0,
          child: Transform.rotate(
            angle: 0.785398,
            child: Card(
              color: Colors.orange,
              margin: const EdgeInsets.only(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  type.name.toUpperCase(),
                  style: latoWhite.copyWith(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
