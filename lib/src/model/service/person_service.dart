// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:amerta/src/model/database/helper.dart';
import 'package:amerta/src/model/model/person_model.dart';
import 'package:amerta/src/model/model/person_summary_transaction.dart';
import 'package:amerta/src/utils/failure.dart';

class PersonService {
  final DatabaseHelper databaseHelper;
  const PersonService({
    required this.databaseHelper,
  });

  Future<List<PersonModel>> getAll() async {
    final result = await databaseHelper.getAllPerson();
    return result;
  }

  Future<PersonModel?> getById(int id) async {
    final result = await databaseHelper.getPersonById(id);
    return result;
  }

  Future<PersonSummaryTransaction> getSummaryTransaction(int personId) async {
    final result = await databaseHelper.getPersonSummaryTransaction(personId);
    return result;
  }

  Future<List<PersonModel>> save(PersonModel person) async {
    await databaseHelper.savePerson(person);
    return getAll();
  }

  Future<List<PersonModel>> update(PersonModel person) async {
    await databaseHelper.updatePerson(person);
    return getAll();
  }

  Future<List<PersonModel>> delete(int id) async {
    await databaseHelper.deletePerson(id);
    return getAll();
  }
}

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

  Future<Either<Failure, PersonSummaryTransaction>> getSummaryTransaction(
      int personId) async {
    try {
      final result = await service.getSummaryTransaction(personId);
      return Right(result);
    } catch (e) {
      log(e.toString());
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

class PersonNotifier extends StateNotifier<PersonState> {
  final PersonRepository repository;
  PersonNotifier({
    required this.repository,
  }) : super(const PersonState()) {
    getAll();
  }

  Future<void> getAll() async {
    state = state.copyWith(asyncItems: const AsyncLoading());
    final result = await repository.getAll();
    result.fold(
      (failure) => state =
          state.copyWith(asyncItems: AsyncError(failure, StackTrace.current)),
      (data) {
        return state = state.copyWith(asyncItems: AsyncData(data));
      },
    );
  }

  Future<void> save(PersonModel person) async {
    state = state.copyWith(onSave: const AsyncLoading());
    await Future.delayed(const Duration(seconds: 1));
    final result = await repository.save(person);
    result.fold(
      (failure) => state =
          state.copyWith(onSave: AsyncError(failure, StackTrace.current)),
      (data) => state = state.copyWith(
        asyncItems: AsyncData(data),
        onSave: const AsyncData("Success save person"),
      ),
    );
  }

  Future<void> update(PersonModel person) async {
    state = state.copyWith(onUpdate: const AsyncLoading());
    final result = await repository.update(person);
    result.fold(
      (failure) => state =
          state.copyWith(onUpdate: AsyncError(failure, StackTrace.current)),
      (data) => state = state.copyWith(
        asyncItems: AsyncData(data),
        onUpdate: const AsyncData("Success update person"),
      ),
    );
  }

  Future<void> delete(int id) async {
    state = state.copyWith(onDelete: const AsyncLoading());
    final result = await repository.delete(id);
    result.fold(
      (failure) => state =
          state.copyWith(onDelete: AsyncError(failure, StackTrace.current)),
      (data) {
        return state = state.copyWith(
          asyncItems: AsyncData(data),
          onDelete: const AsyncData("Success delete person"),
        );
      },
    );
  }
}

class PersonState extends Equatable {
  final AsyncValue<List<PersonModel>> asyncItems;
  final AsyncValue<String?> onSave;
  final AsyncValue<String?> onDelete;
  final AsyncValue<String?> onUpdate;

  const PersonState({
    this.asyncItems = const AsyncData([]),
    this.onSave = const AsyncData(null),
    this.onDelete = const AsyncData(null),
    this.onUpdate = const AsyncData(null),
  });

  @override
  List<Object> get props => [asyncItems, onSave, onDelete, onUpdate];

  @override
  bool get stringify => true;

  PersonState copyWith({
    AsyncValue<List<PersonModel>>? asyncItems,
    AsyncValue<String?>? onSave,
    AsyncValue<String?>? onDelete,
    AsyncValue<String?>? onUpdate,
  }) {
    return PersonState(
      asyncItems: asyncItems ?? this.asyncItems,
      onSave: onSave ?? this.onSave,
      onDelete: onDelete ?? this.onDelete,
      onUpdate: onUpdate ?? this.onUpdate,
    );
  }
}
