import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../model/model/people/people_model.dart';
import '../../../utils/utils.dart';
import '../../../view_model/people/people_notifier.dart';
import '../../../view_model/people/people_summary_transaction_notifier.dart';
import '../../home/widgets/summary_amount.dart';
import '../../modal/modal_option_people/modal_option_people.dart';
import '../../modal/modal_print_transaction/modal_print_transaction.dart';

part 'image_flexible_appbar.dart';
part 'title_flexible_appbar.dart';

class PeopleDetailSliverAppbar extends ConsumerWidget {
  const PeopleDetailSliverAppbar({
    Key? key,
    required this.peopleId,
  }) : super(key: key);

  final String peopleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final future = ref.watch(getPeopleById(peopleId)).unwrapPrevious();

    if (future is AsyncLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.white));
    }

    if (future is AsyncError) {
      return future.whenOrNull(error: (error, trace) => Text("Error $error"))!;
    }

    final people = future.value ?? const PeopleModel();

    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        final isCollapse = height <= kToolbarHeight + fn.notchTop(context);

        final iconBackButton = IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        );

        final iconMoreButton = IconButton(
          onPressed: () async => await showModalBottomSheet(
            context: context,
            builder: (context) => ModalOptionPeople(
              peopleId: people.peopleId,
            ),
          ),
          icon: const Icon(Icons.more_vert_outlined, color: Colors.white),
        );

        final iconPrint = IconButton(
          onPressed: () async => await showModalBottomSheet(
            context: context,
            builder: (context) => ModalOptionPrintTransaction(peopleId: people.peopleId),
          ),
          icon: const Icon(Icons.print_outlined, color: Colors.white),
        );
        return FlexibleSpaceBar(
          titlePadding: const EdgeInsets.only(bottom: 8.0),
          centerTitle: true,
          title: _TitleFlexibleSpaceBar(
            peopleName: people.name,
            isCollapse: isCollapse,
            iconBackButton: iconBackButton,
            iconMoreButton: iconMoreButton,
          ),
          background: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppBar(
                  elevation: 0,
                  leading: iconBackButton,
                  actions: [
                    iconPrint,
                    iconMoreButton,
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0).copyWith(top: 0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ...[
                          _ImageFlexibleAppBar(
                            peopleId: people.peopleId,
                            imagePath: people.imagePath,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            people.name,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: bodyFontWhite.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                        ],
                        Expanded(
                          child: Consumer(
                            builder: (context, ref, child) {
                              final future = ref.watch(getPeopleSummaryTransactionById(peopleId));
                              return future.when(
                                data: (item) {
                                  return Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: SummaryAmount(
                                          title: describeEnum(item.hutang.transactionType)
                                              .toUpperCase(),
                                          // amount: future.balance(TransactionType.hutang),
                                          amount: item.hutang.balance,
                                        ),
                                      ),
                                      Expanded(
                                        child: SummaryAmount(
                                          title: describeEnum(item.piutang.transactionType)
                                              .toUpperCase(),
                                          // amount: future.balance(TransactionType.hutang),
                                          amount: item.piutang.balance,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                error: (error, trace) => Center(child: Text("$error")),
                                loading: () => const Center(
                                  child: CircularProgressIndicator(color: Colors.white),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
