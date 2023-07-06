import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/repository/export_repository.dart';

class ExportNotifier extends StateNotifier<ExportState> {
  final ExportRepository repository;
  ExportNotifier({
    required this.repository,
  }) : super(const ExportState());

  Future<void> export() async {
    state = state.copyWith(
      onExport: const AsyncValue.loading(),
    );
    final result = await repository.export();
    result.fold(
      (failure) => state = state.copyWith(
        onExport: AsyncValue.error(failure, StackTrace.current),
      ),
      (data) => state = state.copyWith(
        onExport: AsyncValue.data(data),
      ),
    );
  }
}

class ExportState extends Equatable {
  final AsyncValue<File?> onExport;
  const ExportState({
    this.onExport = const AsyncValue.data(null),
  });

  @override
  List<Object> get props => [onExport];

  @override
  bool get stringify => true;

  ExportState copyWith({
    AsyncValue<File?>? onExport,
  }) {
    return ExportState(
      onExport: onExport ?? this.onExport,
    );
  }
}
