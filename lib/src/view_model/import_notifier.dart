import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/repository/import_repository.dart';

class ImportNotifier extends StateNotifier<ImportState> {
  final ImportRepository repository;
  ImportNotifier({
    required this.repository,
  }) : super(const ImportState());

  Future<void> import(File file) async {
    state = state.copyWith(onImport: const AsyncLoading());
    final result = await repository.import(file);
    result.fold(
      (l) =>
          state = state.copyWith(onImport: AsyncError(l, StackTrace.current)),
      (r) => state = state.copyWith(onImport: AsyncData(r)),
    );
  }
}

class ImportState extends Equatable {
  final AsyncValue<String?> onImport;
  const ImportState({
    this.onImport = const AsyncData(null),
  });

  @override
  List<Object> get props => [onImport];

  @override
  bool get stringify => true;

  ImportState copyWith({
    AsyncValue<String?>? onImport,
  }) {
    return ImportState(
      onImport: onImport ?? this.onImport,
    );
  }
}
