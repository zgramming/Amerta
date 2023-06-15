import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../injection.dart';
import '../../utils/colors.dart';
import '../../utils/fonts.dart';
import '../../utils/functions.dart';
import '../widgets/transaction_list_item.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20.h),
            const DebtInfo(),
            SizedBox(height: 20.h),
            const RecentTransactionHeader(),
            const RecentTransactionList(),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}

class RecentTransactionList extends ConsumerWidget {
  const RecentTransactionList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final futureRecentTransaction = ref.watch(getRecentTransaction);
    return futureRecentTransaction.when(
      data: (transactions) {
        return ListView.builder(
          itemCount: transactions.length,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            return ProviderScope(
              child: TransactionListItem(
                id: transaction.id,
                title: transaction.title,
                amount: transaction.amount,
                startDate: transaction.startDate,
                endDate: transaction.endDate,
                personName: transaction.personName,
                type: transaction.typeTransaction,
                createdAt: transaction.createdAt,
              ),
            );
          },
        );
      },
      error: (error, stackTrace) {
        return Center(
          child: Text(
            error.toString(),
            style: lato.copyWith(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class RecentTransactionHeader extends StatelessWidget {
  const RecentTransactionHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0.w, vertical: 8.0.h),
      child: Text(
        "Transaksi Terakhir",
        style: lato.copyWith(
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class DebtInfo extends ConsumerWidget {
  const DebtInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final future = ref.watch(getSummaryTransaction);
    return future.when(
      data: (summary) {
        final formatHutangCurrency = FunctionUtils.convertToIDR(
          summary.totalHutang,
        );
        final formatPiutangCurrency = FunctionUtils.convertToIDR(
          summary.totalPiutang,
        );

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 24.0),
          color: primary,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                DebtInfoDetail(
                  title: "Total Hutang",
                  value: formatHutangCurrency,
                  icon: Icons.upcoming_rounded,
                ),
                const SizedBox(width: 10.0),
                DebtInfoDetail(
                  title: "Total Piutang",
                  value: formatPiutangCurrency,
                  icon: Icons.outbond_rounded,
                ),
              ],
            ),
          ),
        );
      },
      error: (error, stackTrace) {
        return Center(
          child: Text(
            error.toString(),
            style: lato.copyWith(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class DebtInfoDetail extends StatelessWidget {
  const DebtInfoDetail({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
  }) : super(key: key);

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 15.r,
            child: Icon(
              icon,
              color: primary,
            ),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: latoWhite.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 10.sp,
                  ),
                ),
                SizedBox(height: 8.0.h),
                FittedBox(
                  child: Text(
                    value,
                    style: latoWhite.copyWith(fontWeight: FontWeight.w300),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
