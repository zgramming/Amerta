import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../injection.dart';
import '../../utils/colors.dart';
import '../../utils/fonts.dart';
import '../../utils/functions.dart';
import '../../utils/styles.dart';
import '../widgets/transaction_list_item.dart';

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

class _DebtInfo extends ConsumerStatefulWidget {
  const _DebtInfo();

  @override
  ConsumerState<_DebtInfo> createState() => _DebtInfoState();
}

class _DebtInfoState extends ConsumerState<_DebtInfo> {
  bool withPayment = true;

  double getPercentage(double value, double total) {
    return double.parse(((value / total) * 100).toStringAsFixed(2));
  }

  @override
  Widget build(BuildContext context) {
    final future = ref.watch(getSummaryTransaction);
    return future.when(
      data: (summary) {
        final hutang =
            withPayment ? summary.totalHutangWithPayment : summary.totalHutang;
        final piutang = withPayment
            ? summary.totalPiutangWithPayment
            : summary.totalPiutang;
        final accumulated = hutang + piutang;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 24.0),
          color: primary,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _DebtInfoDetail(
                            title: "HUTANG",
                            value: FunctionUtils.convertToIDR(hutang),
                            icon: Icons.upcoming_rounded,
                          ),
                          const SizedBox(height: 20.0),
                          _DebtInfoDetail(
                            title: "PIUTANG",
                            value: FunctionUtils.convertToIDR(piutang),
                            icon: Icons.outbond_rounded,
                          ),
                          const SizedBox(height: 20.0),
                          _DebtInfoDetail(
                            title: "AKUMULASI",
                            value: FunctionUtils.convertToIDR(accumulated),
                            icon: Icons.balance,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: PieChart(
                          PieChartData(
                            sections: [
                              PieChartSectionData(
                                color: Colors.red[300],
                                value: hutang,
                                title:
                                    "HTG ${getPercentage(hutang, accumulated)}%",
                                radius: 50.r,
                                titleStyle: latoWhite.copyWith(
                                  fontSize: 8.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              PieChartSectionData(
                                color: Colors.green[300],
                                value: piutang,
                                title:
                                    "PTG ${getPercentage(piutang, accumulated)}%",
                                radius: 50.r,
                                titleStyle: latoWhite.copyWith(
                                  fontSize: 8.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      withPayment = !withPayment;
                    });
                  },
                  icon: Icon(
                    withPayment ? Icons.visibility : Icons.visibility_off,
                    color: primary,
                  ),
                  style: elevatedButtonStyle(
                      padding: const EdgeInsets.all(0),
                      backgroundColor: Colors.white),
                  label: Text(
                    withPayment ? "Tanpa Pembayaran" : "Dengan Pembayaran",
                  ),
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

class _DebtInfoDetail extends StatelessWidget {
  const _DebtInfoDetail({
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
    return Row(
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
                  fontWeight: FontWeight.normal,
                  fontSize: 8.sp,
                ),
              ),
              const SizedBox(height: 5.0),
              FittedBox(
                child: Text(
                  value,
                  style: latoWhite.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

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
            const _DebtInfo(),
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
