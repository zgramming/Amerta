import 'package:dartz/dartz.dart';

import '../../utils/failure.dart';
import '../model/person_model.dart';
import '../model/person_summary_transaction_model.dart';
import '../service/person_service.dart';

class PersonRepository {
  final PersonService service;
  const PersonRepository({
    required this.service,
  });

  Future<Either<Failure, List<PersonModel>>> getAll() async {
    try {
      final result = await service.getAll();
      return Right(result);
    } catch (e) {
      return Left(CommonFailure(e.toString()));
    }
  }

  Future<Either<Failure, PersonModel?>> getById(int id) async {
    try {
      final result = await service.getById(id);
      return Right(result);
    } catch (e) {
      return Left(CommonFailure(e.toString()));
    }
  }

  Future<Either<Failure, PersonSummaryTransactionModel>> getSummaryTransaction(
      int personId) async {
    try {
      final result = await service.getSummaryTransaction(personId);
      return Right(result);
    } catch (e) {
      return Left(CommonFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<PersonModel>>> save(PersonModel person) async {
    try {
      final result = await service.save(person);
      return Right(result);
    } catch (e) {
      return Left(CommonFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<PersonModel>>> update(PersonModel person) async {
    try {
      final result = await service.update(person);
      return Right(result);
    } catch (e) {
      return Left(CommonFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<PersonModel>>> delete(int id) async {
    try {
      final result = await service.delete(id);
      return Right(result);
    } catch (e) {
      return Left(CommonFailure(e.toString()));
    }
  }
}
