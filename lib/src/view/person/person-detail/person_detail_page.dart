// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../injection.dart';
import '../../../model/model/parameter_transaction_by_person_type_model.dart';
import '../../../utils/colors.dart';
import '../../../utils/enums.dart';
import '../../../utils/fonts.dart';
import '../../widgets/transaction_info_row.dart';
import '../../widgets/transaction_list_item.dart';
import 'widgets/modal_print_transaction_person_detail.dart';

class PersonDetailPage extends ConsumerStatefulWidget {
  const PersonDetailPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  final int id;

  @override
  createState() => _PersonDetailPageState();
}

class _PersonDetailPageState extends ConsumerState<PersonDetailPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final tabs = <TypeTransaction>[
    TypeTransaction.hutang,
    TypeTransaction.piutang,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: 0,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final futurePerson = ref.watch(getPersonById(widget.id));
    return futurePerson.when(
      data: (person) {
        return Scaffold(
          body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  title: Text(person?.name ?? ""),
                  pinned: true,
                  floating: true,
                  forceElevated: innerBoxIsScrolled,
                  expandedHeight: 250.h,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.print_outlined),
                      onPressed: () async {
                        await showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (context) =>
                              ModalPrintTransactionPersonDetail(
                            personId: widget.id,
                          ),
                        );
                      },
                    ),
                  ],
                  flexibleSpace: PersonSummaryTransaction(personId: widget.id),
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(50.h),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                      ),
                      child: TabBar(
                        // labelColor: Colors.white,
                        controller: _tabController,
                        tabs: tabs
                            .map((type) => Tab(text: type.name.toUpperCase()))
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: tabs.map((type) {
                return SafeArea(
                  top: false,
                  bottom: false,
                  child: Builder(
                    builder: (BuildContext context) => TransactionByTypeList(
                      personId: widget.id,
                      type: type,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
      error: (error, stackTrace) => Scaffold(
        body: Center(child: Text(error.toString())),
      ),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}

class PersonSummaryTransaction extends ConsumerWidget {
  const PersonSummaryTransaction({
    Key? key,
    required this.personId,
  }) : super(key: key);

  final int personId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final future = ref.watch(getPersonSummaryTransaction(personId));
    return future.when(
      data: (summary) {
        final formatedHutangCurrency = NumberFormat.currency(
          locale: 'id',
          symbol: 'Rp.',
          decimalDigits: 0,
        ).format(summary.totalAmountHutang);

        final formatedPiutangCurrency = NumberFormat.currency(
          locale: 'id',
          symbol: 'Rp.',
          decimalDigits: 0,
        ).format(summary.totalAmountPiutang);

        final totalCountTransaksi =
            summary.totalCountHutang + summary.totalCountPiutang;

        return FlexibleSpaceBar(
          background: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.center,
            child: Card(
              margin: const EdgeInsets.only(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Rekapitulasi transaksi",
                      style: lato.copyWith(
                        fontSize: 14.sp,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    TransactionInfoRow(
                      icon: Icons.money_rounded,
                      iconColor: black,
                      title: "Total hutang ",
                      titleStyle: lato.copyWith(
                        fontSize: 12.sp,
                        color: Colors.black,
                      ),
                      content: formatedHutangCurrency,
                      contentStyle: lato.copyWith(
                        fontSize: 12.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    TransactionInfoRow(
                      icon: Icons.payments_rounded,
                      iconColor: black,
                      title: "Total piutang ",
                      titleStyle: lato.copyWith(
                        fontSize: 12.sp,
                        color: Colors.black,
                      ),
                      content: formatedPiutangCurrency,
                      contentStyle: lato.copyWith(
                        fontSize: 12.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    TransactionInfoRow(
                      icon: Icons.replay_circle_filled,
                      iconColor: black,
                      title: "Total transaksi ",
                      titleStyle: lato.copyWith(
                        fontSize: 12.sp,
                        color: Colors.black,
                      ),
                      content: "$totalCountTransaksi transaksi",
                      contentStyle: lato.copyWith(
                        fontSize: 12.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      error: (error, stackTrace) => Center(child: Text(error.toString())),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

class TransactionByTypeList extends ConsumerWidget {
  const TransactionByTypeList({
    Key? key,
    required this.type,
    required this.personId,
  }) : super(key: key);

  final TypeTransaction type;
  final int personId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ParameterTransactionByPersonTypeModel(
      personId: personId,
      type: type,
    );
    final futureTransaction = ref.watch(getTransactionByType(model));
    return futureTransaction.when(
      data: (transactions) {
        if (transactions.isEmpty) {
          return const Center(child: Text("Tidak ada transaksi"));
        }

        return ListView.builder(
          key: PageStorageKey(type.name),
          itemCount: transactions.length,
          shrinkWrap: true,
          padding: const EdgeInsets.all(16.0),
          itemBuilder: (context, index) {
            final transaction = transactions[index];

            return TransactionListItem(
              id: transaction.id,
              amount: transaction.amount,
              createdAt: transaction.createdAt,
              type: transaction.typeTransaction,
              endDate: transaction.endDate,
              personName: transaction.personName,
              startDate: transaction.startDate,
              title: transaction.title,
              paymentAmount: transaction.paymentAmount,
              isPaid: transaction.isPaid,
            );
          },
        );
      },
      error: (error, stackTrace) => Center(child: Text(error.toString())),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
