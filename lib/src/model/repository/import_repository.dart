import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../utils/failure.dart';
import '../service/import_service.dart';

class ImportRepository {
  final ImportService service;
  ImportRepository({
    required this.service,
  });

  Future<Either<Failure, String>> import(File file) async {
    try {
      final result = await service.import(file);
      return Right(result);
    } catch (e) {
      return Left(CommonFailure(e.toString()));
    }
  }
}
