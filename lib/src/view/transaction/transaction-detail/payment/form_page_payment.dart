import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../injection.dart';
import '../../../../model/model/form_payment_model.dart';
import '../../../../model/model/payment_model.dart';
import '../../../../utils/functions.dart';
import '../../../../utils/styles.dart';
import '../../../widgets/form_body.dart';
import '../widgets/transaction_detail_info.dart';

class FormPagePayment extends ConsumerStatefulWidget {
  const FormPagePayment({
    Key? key,
    required this.transactionId,
    required this.paymentId,
  }) : super(key: key);

  final int transactionId;
  final int paymentId;

  @override
  createState() => _FormPagePaymentState();
}

class _FormPagePaymentState extends ConsumerState<FormPagePayment> {
  final formKey = GlobalKey<FormState>();

  late final TextEditingController _amountController;
  late final TextEditingController _descriptionController;

  Future<void> submit(PaymentModel? payment) async {
    final validate = formKey.currentState?.validate();
    if (validate == null || !validate) return;

    final notifier = ref.read(paymentNotifier(widget.transactionId).notifier);
    final amount = _amountController.text;

    if (payment == null) {
      final model = FormPaymentModel(
        amount: amount.isEmpty ? 0 : double.parse(amount),
        description: _descriptionController.text,
        transactionId: widget.transactionId,
        id: null,
      );
      await notifier.save(model);

      formKey.currentState?.reset();
    } else {
      final model = FormPaymentModel(
        amount: amount.isEmpty ? 0 : double.parse(amount),
        description: _descriptionController.text,
        transactionId: widget.transactionId,
        id: widget.paymentId,
      );

      await notifier.update(model);
    }

    if (mounted) {
      /// Reload Provider
      ref.invalidate(getRecentTransaction);
      ref.invalidate(getSummaryTransaction);
      ref.invalidate(getTransactionById(widget.transactionId));
    }
  }

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      getPaymentById(widget.paymentId),
      (previous, next) {
        next.whenData((val) {
          if (val != null) {
            _amountController.text = val.amount.toString();
            _descriptionController.text = val.description ?? "";
          }
        });
      },
    );

    ref.listen(
      paymentNotifier(widget.transactionId).select((value) => value.onUpdate),
      (previous, next) {
        next.when(
          data: (message) {
            // close modal loading
            context.pop();

            return FunctionUtils.showSuccessDialog(
              context: context,
              message: message ?? "Default message",
            );
          },
          error: (error, stackTrace) {
            // close modal loading
            context.pop();

            return FunctionUtils.showAlertDialog(
              context: context,
              message: error.toString(),
            );
          },
          loading: () => FunctionUtils.showLoadingDialog(context: context),
        );
      },
    );

    ref.listen(
      paymentNotifier(widget.transactionId).select((value) => value.onSave),
      (previous, next) {
        next.when(
          data: (message) {
            // close modal loading
            context.pop();

            return FunctionUtils.showSuccessDialog(
              context: context,
              message: message ?? "Default message",
            );
          },
          error: (error, stackTrace) {
            // close modal loading
            context.pop();

            return FunctionUtils.showAlertDialog(
              context: context,
              message: error.toString(),
            );
          },
          loading: () => FunctionUtils.showLoadingDialog(context: context),
        );
      },
    );

    final futurePayment = ref.watch(getPaymentById(widget.paymentId));
    return futurePayment.when(
      data: (payment) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              payment?.id == null ? "Tambah Pembayaran" : "Edit Pembayaran",
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _PaymentTransactionDetailInfo(
                          transactionId: widget.transactionId,
                        ),
                        const SizedBox(height: 20.0),
                        FormBody(
                          title: "Jumlah",
                          child: TextFormField(
                            controller: _amountController,
                            decoration: inputDecorationRounded(),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Jumlah tidak boleh kosong";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        FormBody(
                          title: "Deskripsi (opsional)",
                          child: TextFormField(
                            controller: _descriptionController,
                            minLines: 3,
                            maxLines: 3,
                            decoration: inputDecorationRounded(),
                            keyboardType: TextInputType.multiline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    await submit(payment);
                  },
                  child: Text(payment == null ? "Tambah" : "Edit"),
                ),
              ),
            ],
          ),
        );
      },
      error: (error, stackTrace) => Scaffold(
        body: Center(child: Text(error.toString())),
      ),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}

class _PaymentTransactionDetailInfo extends ConsumerWidget {
  const _PaymentTransactionDetailInfo({
    required this.transactionId,
  });
  final int transactionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final future = ref.watch(getTransactionById(transactionId));
    return future.when(
      data: (transaction) {
        if (transaction == null) return const SizedBox.shrink();
        return TransactionDetailInfo(
          title: transaction.title,
          type: transaction.typeTransaction,
          amount: transaction.amount,
          paid: transaction.paid,
          startDate: transaction.startDate,
          endDate: transaction.endDate,
          createdAt: transaction.createdAt,
          personName: transaction.personName,
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text(error.toString())),
    );
  }
}
