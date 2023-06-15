import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../model/model/pdf_report_model.dart';
import 'constant.dart';
import 'enums.dart';

class FunctionUtils {
  static Future<DateTime?> showDateTimePicker(
    BuildContext context, {
    DateTime? initialDate,
    bool withTimePicker = true,
  }) async {
    final datePicker = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (datePicker == null) return null;

    if (withTimePicker && context.mounted) {
      final timePicker = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          );
        },
      );
      if (timePicker != null) {
        return datePicker
            .add(Duration(hours: timePicker.hour, minutes: timePicker.minute));
      }
    }

    return datePicker;
  }

  static getFirstLetters(String fullName) {
    // Split the string into words
    List<String> words =
        fullName.split(' ').where((element) => element.isNotEmpty).toList();

    if (words.isEmpty) {
      return fullName.substring(0, 1).toUpperCase();
    }

    // Get the first letter from each word
    List<String> firstLetters = words.map((word) => word[0]).toList();

    // Concatenate the first letters
    String result = firstLetters.join('');

    return result.toUpperCase(); // Convert to uppercase if needed
  }

  static Future<void> showAlertDialog({
    String title = "Error",
    required BuildContext context,
    required String message,
  }) async {
    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.error, color: Colors.red),
              const SizedBox(height: 16.0),
              Text(message),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  static Future<void> showSuccessDialog({
    String title = "Success",
    required BuildContext context,
    required String message,
  }) async {
    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: Colors.green),
              const SizedBox(height: 16.0),
              Text(message),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  static Future<void> showLoadingDialog({
    required BuildContext context,
    String message = "Loading...",
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16.0),
              Text(message),
            ],
          ),
        );
      },
    );
  }

  static String convertToIDR(num number) {
    return NumberFormat.currency(
      locale: "id",
      symbol: "Rp.",
      decimalDigits: 0,
    ).format(number);
  }

  static Future<File> generatePDFTransaction({
    required List<PDFReportModel> transactions,
  }) async {
    final doc = pw.Document();
    final byteLogo = await rootBundle.load(pathLogo);
    final logo = byteLogo.buffer.asUint8List(
      byteLogo.offsetInBytes,
      byteLogo.lengthInBytes,
    );
    final dateFormat = DateFormat('dd MMMM yyyy');

    pw.Widget buildHeader(Uint8List logo) {
      return pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        children: [
          pw.Image(pw.MemoryImage(logo), width: 60, height: 60),
          pw.Expanded(
            child: pw.Text(
              "REPORT TRANSACTION",
              textAlign: pw.TextAlign.right,
              style: pw.TextStyle(
                fontSize: 20,
                fontWeight: pw.FontWeight.bold,
                fontStyle: pw.FontStyle.italic,
              ),
            ),
          ),
        ],
      );
    }

    pw.Widget buildFooter(pw.Context context) {
      final now = DateTime.now();
      final dateFormat = DateFormat('dd MMMM yyyy');
      final timeFormat = DateFormat('HH:mm');

      return pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            "Printed on ${dateFormat.format(now)} at ${timeFormat.format(now)}",
            style: const pw.TextStyle(
              fontSize: 14,
            ),
          ),
          pw.Text(
            "Page ${context.pageNumber} of ${context.pagesCount}",
            style: const pw.TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      );
    }

    doc.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          theme: pw.ThemeData.withFont(
            base: await PdfGoogleFonts.latoRegular(),
            bold: await PdfGoogleFonts.latoBold(),
            italic: await PdfGoogleFonts.latoItalic(),
          ),
        ),
        header: (context) {
          if (context.pageNumber == 1) {
            return buildHeader(logo);
          }
          return pw.SizedBox();
        },
        footer: (context) => buildFooter(context),
        build: (context) {
          return [
            pw.SizedBox(height: 20),
            pw.Divider(thickness: 2, color: PdfColors.grey600),
            pw.SizedBox(height: 20),
            pw.TableHelper.fromTextArray(
              border: null,
              cellStyle: const pw.TextStyle(fontSize: 10),
              headerStyle: pw.TextStyle(
                fontSize: 9,
                color: PdfColors.grey600,
                fontWeight: pw.FontWeight.bold,
              ),
              columnWidths: {
                0: const pw.FlexColumnWidth(1),
                1: const pw.FlexColumnWidth(2),
                2: const pw.FlexColumnWidth(2),
                3: const pw.FlexColumnWidth(2),
                4: const pw.FlexColumnWidth(1),
                5: const pw.FlexColumnWidth(2),
                6: const pw.FlexColumnWidth(2),
                7: const pw.FlexColumnWidth(2),
              },
              headerAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerLeft,
                2: pw.Alignment.center,
                3: pw.Alignment.centerLeft,
                4: pw.Alignment.center,
                5: pw.Alignment.centerRight,
                6: pw.Alignment.centerRight,
                7: pw.Alignment.centerRight,
              },
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerLeft,
                2: pw.Alignment.center,
                3: pw.Alignment.centerLeft,
                4: pw.Alignment.center,
                5: pw.Alignment.centerRight,
                6: pw.Alignment.centerRight,
                7: pw.Alignment.centerRight,
              },
              rowDecoration: const pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(
                    color: PdfColors.grey,
                    width: .5,
                  ),
                ),
              ),
              headers: [
                "No",
                "Title",
                "Period",
                "Name",
                "Type",
                "Amount",
                "Paid",
                "Remaining",
              ],
              data: List.generate(
                transactions.length,
                (index) {
                  final transaction = transactions[index];
                  final startDate = dateFormat.format(transaction.startDate);
                  final endDate = dateFormat.format(transaction.endDate);
                  final amount = convertToIDR(transaction.amount);
                  final paid = convertToIDR(transaction.paid);
                  final remaining = convertToIDR(
                    transaction.amount - transaction.paid,
                  );
                  final type = transaction.type == TypeTransaction.hutang
                      ? "HTG"
                      : "PTG";

                  return [
                    (index + 1).toString(),
                    transaction.title,
                    "$startDate - $endDate",
                    transaction.personName,
                    type,
                    amount,
                    paid,
                    remaining,
                  ];
                },
              ),
            ),
            pw.Builder(
              builder: (context) {
                final subtotalAmount = transactions.fold<double>(
                  0,
                  (previousValue, element) => previousValue + element.amount,
                );
                final subtotalPaid = transactions.fold<double>(
                  0,
                  (previousValue, element) => previousValue + element.paid,
                );
                final subtotalRemaining = subtotalAmount - subtotalPaid;
                final total = subtotalAmount - subtotalPaid;
                return pw.TableHelper.fromTextArray(
                  border: const pw.TableBorder(
                    bottom: pw.BorderSide(
                      color: PdfColors.grey,
                      width: .5,
                    ),
                  ),
                  cellStyle: pw.TextStyle(
                    fontSize: 12.0,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  cellAlignments: {
                    0: pw.Alignment.centerRight,
                    1: pw.Alignment.centerRight,
                  },
                  data: [
                    [
                      "Subtotal Amount",
                      convertToIDR(subtotalAmount),
                    ],
                    [
                      "Subtotal Paid",
                      convertToIDR(subtotalPaid),
                    ],
                    [
                      "Subtotal Remaining",
                      convertToIDR(subtotalRemaining),
                    ],
                    [
                      "Total",
                      convertToIDR(total),
                    ],
                  ],
                );
              },
            ),
          ];
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/example.pdf");
    await file.writeAsBytes(await doc.save());

    return file;
  }
}
