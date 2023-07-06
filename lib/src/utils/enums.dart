import 'package:json_annotation/json_annotation.dart';

enum TypeTransaction {
  @JsonValue('hutang')
  hutang,
  @JsonValue('piutang')
  piutang
}

enum PrintTrxType { hutang, piutang, all }

enum PrintTrxPurpose { invoice, report }
