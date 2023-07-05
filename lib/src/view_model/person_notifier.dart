// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/model/person_filter_model.dart';
import '../model/model/person_model.dart';
import '../model/repository/person_repository.dart';

class PersonNotifier extends StateNotifier<PersonState> {
  final PersonRepository repository;
  final PersonFilterModel filter;
  PersonNotifier({
    required this.repository,
    required this.filter,
  }) : super(const PersonState()) {
    getAll();
  }

  Future<void> getAll() async {
    state = state.copyWith(asyncItems: const AsyncLoading());
    final result = await repository.getAll(filter: filter);
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
