import 'package:amerta/src/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:amerta/src/injection.dart';

import '../../../model/model/pdf_report_filter_model.dart';
import '../../../utils/functions.dart';
import '../../../utils/routers.dart';
import '../../widgets/print_transaction_tile.dart';

class ModalPrintTransactionPerson extends ConsumerWidget {
  const ModalPrintTransactionPerson({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PrintTransactionTile(
            title: "Cetak Hutang",
            subtitle: "Cetak semua hutang ke PDF",
            icon: Icons.upcoming_rounded,
            onTap: () async {
              final notifier = ref.read(pdfReportNotifier.notifier);
              await notifier.generateAllReport(
                filter: const PDFReportFilterModel(type: PrintTrxType.hutang),
                onSuccess: (file) {
                  context.pop();
                  context.pushNamed(previewPDFRoute, extra: file);
                },
                onError: (message) {
                  context.pop();
                  FunctionUtils.showAlertDialog(
                      context: context, message: message);
                },
                onLoading: () =>
                    FunctionUtils.showLoadingDialog(context: context),
              );
            },
          ),
          PrintTransactionTile(
            title: "Cetak Piutang",
            subtitle: "Cetak semua piutang ke PDF",
            icon: Icons.outbond_rounded,
            onTap: () async {
              final notifier = ref.read(pdfReportNotifier.notifier);
              await notifier.generateAllReport(
                filter: const PDFReportFilterModel(type: PrintTrxType.piutang),
                onSuccess: (file) {
                  context.pop();
                  context.pushNamed(previewPDFRoute, extra: file);
                },
                onError: (message) {
                  context.pop();
                  FunctionUtils.showAlertDialog(
                      context: context, message: message);
                },
                onLoading: () =>
                    FunctionUtils.showLoadingDialog(context: context),
              );
            },
          ),
          PrintTransactionTile(
            title: "Cetak semua transaksi",
            subtitle: "Cetak semua transaksi ke PDF",
            icon: Icons.handshake_outlined,
            onTap: () async {
              final notifier = ref.read(pdfReportNotifier.notifier);
              await notifier.generateAllReport(
                filter: const PDFReportFilterModel(type: PrintTrxType.all),
                onSuccess: (file) {
                  context.pop();
                  context.pushNamed(previewPDFRoute, extra: file);
                },
                onError: (message) {
                  context.pop();
                  FunctionUtils.showAlertDialog(
                      context: context, message: message);
                },
                onLoading: () =>
                    FunctionUtils.showLoadingDialog(context: context),
              );
            },
          ),
        ],
      ),
    );
  }
}
