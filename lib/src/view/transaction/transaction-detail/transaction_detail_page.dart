import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../injection.dart';
import '../../../model/model/payment_model.dart';
import '../../../utils/fonts.dart';
import '../../../utils/functions.dart';
import '../../../utils/routers.dart';
import 'widgets/transaction_detail_info.dart';

class TransactionDetailPage extends ConsumerWidget {
  const TransactionDetailPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final future = ref.watch(getTransactionById(id));
    return future.when(
      data: (transaction) {
        if (transaction == null) {
          return Scaffold(
            body: Center(
              child: Text(
                "Data tidak ditemukan",
                style: lato.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(transaction.title),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20.h),
              TransactionDetailInfo(
                title: transaction.title,
                type: transaction.typeTransaction,
                amount: transaction.amount,
                paid: transaction.paid,
                startDate: transaction.startDate,
                endDate: transaction.endDate,
                createdAt: transaction.createdAt,
                personName: transaction.personName,
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Riwayat Pembayaran",
                  style: latoBold.copyWith(fontSize: 12.sp),
                ),
              ),
              SizedBox(height: 10.h),
              TransactionPaymentList(transactionId: id)
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => context.pushNamed(
              paymentRoute,
              pathParameters: {
                'transactionId': "$id",
                'id': '0',
              },
            ),
            label: const Text("Pembayaran"),
            icon: const Icon(Icons.add),
          ),
        );
      },
      error: (error, stackTrace) {
        return Scaffold(
          body: Center(
            child: Text(
              error.toString(),
              style: lato.copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
      loading: () {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

class TransactionPaymentList extends ConsumerWidget {
  const TransactionPaymentList({
    super.key,
    required this.transactionId,
  });

  final int transactionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      paymentNotifier(transactionId).select((value) => value.onDelete),
      (previous, next) {
        next.when(
          data: (data) {
            context.pop();
            return FunctionUtils.showSuccessDialog(
              context: context,
              message: data ?? "",
            );
          },
          error: (error, stackTrace) {
            context.pop();
            return FunctionUtils.showAlertDialog(
                context: context, message: error.toString());
          },
          loading: () => FunctionUtils.showLoadingDialog(context: context),
        );
      },
    );

    final futurePayment = ref.watch(paymentNotifier(transactionId));

    return futurePayment.asyncItems.when(
      data: (payments) {
        return Expanded(
          child: Builder(builder: (context) {
            if (payments.isEmpty) {
              return const Center(child: Text("Belum ada pembayaran"));
            }
            return ListView.builder(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: 100.0,
              ),
              itemCount: payments.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final payment = payments[index];
                return TransactionPaymentListItem(payment: payment);
              },
            );
          }),
        );
      },
      error: (error, stackTrace) => Center(child: Text(error.toString())),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

class TransactionPaymentListItem extends ConsumerWidget {
  final PaymentModel payment;
  const TransactionPaymentListItem({
    Key? key,
    required this.payment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formatDate = DateFormat("dd MMMM yyyy");
    final formatAmountCurrency = NumberFormat.simpleCurrency(
      locale: "id_ID",
      decimalDigits: 0,
      name: "Rp ",
    ).format(payment.amount);
    return ListTile(
      onTap: () {},
      contentPadding: const EdgeInsets.only(),
      leading: const CircleAvatar(
        backgroundColor: Colors.orange,
        child: Icon(
          Icons.payments_rounded,
          color: Colors.white,
        ),
      ),
      title: Text(
        formatAmountCurrency,
        style: lato.copyWith(fontSize: 12.sp),
      ),
      subtitle: Text.rich(
        TextSpan(
          text: formatDate.format(payment.createdAt),
          children: [
            if (payment.description != null)
              TextSpan(text: " - ${payment.description}"),
          ],
        ),
        style: lato.copyWith(fontSize: 10.sp),
      ),
      trailing: PopupMenuButton(
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              child: const Text("Edit"),
              onTap: () {
                context.pushNamed(
                  paymentRoute,
                  pathParameters: {
                    'transactionId': "${payment.transactionId}",
                    'id': "${payment.id}",
                  },
                );
              },
            ),
            PopupMenuItem(
              child: const Text("Hapus"),
              onTap: () async {
                final notifier =
                    ref.read(paymentNotifier(payment.transactionId).notifier);
                await notifier.delete(
                  paymentId: payment.id,
                  transactionId: payment.transactionId,
                );

                /// Reload Provider after delete
                ref.invalidate(getTransactionById);
              },
            ),
          ];
        },
      ),
    );
  }
}
