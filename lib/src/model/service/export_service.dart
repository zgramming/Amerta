// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../database/helper.dart';

class ExportService {
  final DatabaseHelper databaseHelper;
  ExportService({
    required this.databaseHelper,
  });
  Future<File> export() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = "${dir.path}/amerta_export.json";
    final file = File(path);

    final result = await databaseHelper.getExportedData();
    final encodedPerson =
        jsonEncode(result.persons.map((e) => e.toJson()).toList());
    final encodedTransaction =
        jsonEncode(result.transactions.map((e) => e.toJson()).toList());
    final encodedPayment =
        jsonEncode(result.payments.map((e) => e.toJson()).toList());

    final mapping = Map.from({
      "persons": encodedPerson,
      "transactions": encodedTransaction,
      "payments": encodedPayment,
    });

    final encodeMapping = jsonEncode(mapping);

    await file.writeAsString(encodeMapping);

    return file;
  }
}
