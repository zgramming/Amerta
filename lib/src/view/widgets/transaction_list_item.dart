import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../injection.dart';
import '../../utils/colors.dart';
import '../../utils/enums.dart';
import '../../utils/fonts.dart';
import '../../utils/functions.dart';
import '../../utils/routers.dart';

class TransactionListItem extends ConsumerWidget {
  const TransactionListItem({
    Key? key,
    required this.id,
    required this.title,
    required this.personName,
    required this.amount,
    required this.startDate,
    required this.endDate,
    required this.type,
    required this.createdAt,
  }) : super(key: key);

  final int id;
  final String title;
  final String personName;
  final double amount;
  final DateTime startDate;
  final DateTime endDate;
  final TypeTransaction type;
  final DateTime createdAt;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(8.0),
          onTap: () {
            context.pushNamed(
              transactionDetailRoute,
              pathParameters: {'id': '$id'},
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _TransactionListItemHeader(
                id: id,
                type: type,
                createdAt: createdAt,
              ),
              ListTile(
                title: _TransactionListItemTitle(title: title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 10.h),
                    _TransactionListItemAmount(amount: amount),
                    SizedBox(height: 2.h),
                    _TransactionListItemPerson(personName: personName),
                    SizedBox(height: 2.h),
                    _TransactionListItemDate(
                      startDate: startDate,
                      endDate: endDate,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TransactionListItemAmount extends StatelessWidget {
  final double amount;
  const _TransactionListItemAmount({
    Key? key,
    required this.amount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedCurrency = FunctionUtils.convertToIDR(amount);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.attach_money,
          size: 10.sp,
        ),
        SizedBox(width: 4.w),
        Text(
          formattedCurrency,
          style: lato.copyWith(
            fontSize: 10.sp,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _TransactionListItemPerson extends StatelessWidget {
  final String personName;
  const _TransactionListItemPerson({
    Key? key,
    required this.personName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.person_outline, size: 10.sp),
        SizedBox(width: 4.w),
        Text(
          personName,
          style: lato.copyWith(fontSize: 10.sp, color: Colors.grey),
        ),
      ],
    );
  }
}

class _TransactionListItemDate extends StatelessWidget {
  const _TransactionListItemDate({
    required this.startDate,
    required this.endDate,
  });

  final DateTime startDate;
  final DateTime endDate;

  @override
  Widget build(BuildContext context) {
    final formatDate = DateFormat('d MMMM yyyy ');

    final formatStartDate = formatDate.format(startDate);
    final formatEndDate = formatDate.format(endDate);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.calendar_month_outlined,
          size: 10.sp,
        ),
        SizedBox(width: 4.w),
        Text(
          "$formatStartDate - $formatEndDate",
          style: lato.copyWith(
            fontSize: 10.sp,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class _TransactionListItemTitle extends StatelessWidget {
  final String title;
  const _TransactionListItemTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: lato.copyWith(
        fontSize: 12.sp,
        fontWeight: FontWeight.bold,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _TransactionListItemHeader extends ConsumerWidget {
  const _TransactionListItemHeader({
    Key? key,
    required this.id,
    required this.type,
    required this.createdAt,
  }) : super(key: key);

  final int id;
  final TypeTransaction type;
  final DateTime createdAt;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formatDate = DateFormat('d MMMM yyyy ');

    final typeText = type == TypeTransaction.hutang ? "Hutang" : "Piutang";
    final icon = type == TypeTransaction.hutang
        ? Icons.upcoming_outlined
        : Icons.outbound_rounded;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 12.0,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.2),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 10.0.r,
                backgroundColor: primary,
                child: FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(icon),
                  ),
                ),
              ),
              SizedBox(width: 8.0.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    typeText,
                    style: lato.copyWith(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    formatDate.format(createdAt),
                    style: lato.copyWith(
                      fontSize: 8.sp,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Builder(builder: (context) {
            return PopupMenuButton(
              onSelected: (value) async {
                switch (value) {
                  case 'edit':
                    context.pushNamed(
                      formTransactionRoute,
                      pathParameters: {'id': '$id'},
                    );
                    break;

                  case 'print':
                    final pdfNotifier = ref.read(pdfReportNotifier.notifier);

                    await pdfNotifier.generateReportDetailTransaction(
                      id,
                      onSuccess: (file) {
                        context.pop();
                        context.pushNamed(previewPDFRoute, extra: file);
                      },
                      onError: (message) {
                        context.pop();
                        FunctionUtils.showAlertDialog(
                          context: context,
                          message: message,
                        );
                      },
                      onLoading: () =>
                          FunctionUtils.showLoadingDialog(context: context),
                    );
                  default:
                }
              },
              itemBuilder: (_) {
                return [
                  const PopupMenuItem(value: 'edit', child: Text("Edit")),
                  const PopupMenuItem(value: 'print', child: Text("Cetak PDF")),
                ];
              },
              child: const Icon(Icons.more_vert),
            );
          }),
        ],
      ),
    );
  }
}
