import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../injection.dart';
import '../../model/model/form_transaction_model.dart';
import '../../model/model/person_model.dart';
import '../../model/model/transaction_detail_model.dart';
import '../../utils/enums.dart';
import '../../utils/functions.dart';
import '../../utils/routers.dart';
import '../../utils/styles.dart';
import '../widgets/form_body.dart';

class FormTransactionPage extends ConsumerStatefulWidget {
  const FormTransactionPage({
    super.key,
    required this.id,
  });

  final int id;

  @override
  createState() => _FormTransactionPageState();
}

class _FormTransactionPageState extends ConsumerState<FormTransactionPage> {
  DateTime? startDatePicked;
  DateTime? endDatePicked;
  TypeTransaction typeTransaction = TypeTransaction.hutang;
  int? selectedPerson;

  final formatDate = DateFormat('dd MMMM yyyy');
  final formKey = GlobalKey<FormState>();

  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  late final TextEditingController amountController;
  late final TextEditingController startDateController;
  late final TextEditingController endDateController;

  Future<void> save(TransactionDetailModel? transaction) async {
    try {
      final validate = formKey.currentState?.validate();
      if (validate == null || !validate) {
        return;
      }
      if (selectedPerson == null) throw "Person is required";

      final amount = amountController.text.isEmpty
          ? 0.0
          : double.parse(amountController.text);

      if (transaction == null) {
        final transaction = FormTransactionModel(
          id: null,
          personId: selectedPerson!,
          title: titleController.text,
          description: descriptionController.text,
          typeTransaction: typeTransaction,
          amount: amount,
          startDate: startDatePicked ?? DateTime.now(),
          endDate: endDatePicked ?? DateTime.now(),
        );

        await ref.read(transactionNotifier.notifier).save(transaction);

        formKey.currentState?.reset();
        titleController.clear();
        descriptionController.clear();
        amountController.clear();
      } else {
        final transaction = FormTransactionModel(
          id: widget.id,
          personId: selectedPerson!,
          title: titleController.text,
          description: descriptionController.text,
          typeTransaction: typeTransaction,
          amount: amount,
          startDate: startDatePicked ?? DateTime.now(),
          endDate: endDatePicked ?? DateTime.now(),
        );

        await ref.read(transactionNotifier.notifier).update(transaction);
      }

      if (mounted) {
        /// Reload Provider
        ref.invalidate(getRecentTransaction);
        ref.invalidate(getSummaryTransaction);
      }
    } catch (e) {
      await FunctionUtils.showAlertDialog(
        context: context,
        title: "Error",
        message: e.toString(),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final fixedNow = DateTime(now.year, now.month, now.day);
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    amountController = TextEditingController();
    startDateController =
        TextEditingController(text: formatDate.format(fixedNow));
    endDateController = TextEditingController(
      text: formatDate.format(fixedNow.add(const Duration(days: 30))),
    );

    startDatePicked = fixedNow;
    endDatePicked = fixedNow.add(const Duration(days: 30));
  }

  @override
  void dispose() {
    startDateController.dispose();
    endDateController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    amountController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(getTransactionById(widget.id), (previous, next) {
      next.whenData((value) {
        if (value != null) {
          titleController.text = value.title;
          descriptionController.text = value.description ?? "";
          amountController.text = value.amount.toString();
          startDateController.text = formatDate.format(value.startDate);
          endDateController.text = formatDate.format(value.endDate);
          startDatePicked = value.startDate;
          endDatePicked = value.endDate;
          typeTransaction = value.typeTransaction;
          selectedPerson = value.personId;
        }
      });
    });

    ref.listen(transactionNotifier.select((value) => value.onUpdate),
        (previous, next) {
      next.when(
        data: (data) => FunctionUtils.showSuccessDialog(
          context: context,
          message: data ?? "Default message",
        ).then((value) => context.pop()),
        error: (error, stackTrace) => FunctionUtils.showAlertDialog(
          context: context,
          title: "Error",
          message: error.toString(),
        ).then((value) => context.pop()),
        loading: () => FunctionUtils.showLoadingDialog(context: context),
      );
    });

    ref.listen(
      transactionNotifier.select((value) => value.onSave),
      (previous, next) async {
        next.when(
          data: (data) {
            context.pop();
            FunctionUtils.showSuccessDialog(
              context: context,
              message: data ?? "Default message",
            );
          },
          error: (error, stackTrace) {
            context.pop();
            FunctionUtils.showAlertDialog(
              context: context,
              title: "Error",
              message: error.toString(),
            );
          },
          loading: () {
            FunctionUtils.showLoadingDialog(context: context);
          },
        );
      },
    );

    final futureTransaction = ref.watch(getTransactionById(widget.id));

    return futureTransaction.when(
      data: (transaction) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Form Transaction'),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _DropdownPerson(
                            onSelectedPerson: (person) {
                              setState(() => selectedPerson = person.id);
                            },
                            personId: selectedPerson,
                          ),
                          const SizedBox(height: 20),
                          FormBody(
                            title: "Title",
                            child: TextFormField(
                              controller: titleController,
                              decoration: inputDecorationRounded(),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Title is required";
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          FormBody(
                            title: "Amount",
                            child: TextFormField(
                              controller: amountController,
                              decoration: inputDecorationRounded(),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Amount is required";
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          FormBody(
                            title: "Description",
                            child: TextFormField(
                              controller: descriptionController,
                              minLines: 3,
                              maxLines: 3,
                              decoration: inputDecorationRounded(),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          FormBody(
                            title: "Start Date",
                            child: TextFormField(
                              controller: startDateController,
                              readOnly: true,
                              decoration: inputDecorationRounded(),
                              onTap: () async {
                                final datetime =
                                    await FunctionUtils.showDateTimePicker(
                                  context,
                                  initialDate: startDatePicked,
                                  withTimePicker: false,
                                );
                                if (datetime != null) {
                                  setState(() {
                                    startDatePicked = datetime;
                                    startDateController.text =
                                        formatDate.format(datetime);
                                  });
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Start Date is required";
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          FormBody(
                            title: "End Date",
                            child: TextFormField(
                              controller: endDateController,
                              readOnly: true,
                              decoration: inputDecorationRounded(),
                              onTap: () async {
                                final datetime =
                                    await FunctionUtils.showDateTimePicker(
                                  context,
                                  initialDate: endDatePicked,
                                  withTimePicker: false,
                                );
                                if (datetime != null) {
                                  setState(() {
                                    endDatePicked = datetime;
                                    endDateController.text =
                                        formatDate.format(datetime);
                                  });
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "End Date is required";
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          FormBody(
                            title: "Type",
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                RadioListTile(
                                  title: const Text("Hutang"),
                                  value: TypeTransaction.hutang,
                                  groupValue: typeTransaction,
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() => typeTransaction = value);
                                    }
                                  },
                                ),
                                RadioListTile(
                                  title: const Text("Piutang"),
                                  value: TypeTransaction.piutang,
                                  groupValue: typeTransaction,
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() => typeTransaction = value);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    await save(transaction);
                  },
                  child: const Text('Simpan'),
                ),
              ),
            ],
          ),
        );
      },
      error: (error, stackTrace) => Scaffold(
        body: Center(
          child: Text(error.toString()),
        ),
      ),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}

class _DropdownPerson extends ConsumerWidget {
  final Function(PersonModel person) onSelectedPerson;
  final int? personId;
  const _DropdownPerson({
    required this.onSelectedPerson,
    required this.personId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final persons =
        ref.watch(personNotifier.select((value) => value.asyncItems)).value ??
            [];
    final selectedPerson =
        persons.firstWhereOrNull((element) => element.id == personId);
    return FormBody(
      title: "Person",
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField(
              value: selectedPerson,
              decoration: inputDecorationRounded(),
              items: persons
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e.name),
                    ),
                  )
                  .toList(),
              onChanged: (val) {
                if (val != null) {
                  onSelectedPerson(val);
                }
              },
            ),
          ),
          IconButton(
            onPressed: () {
              context.pushNamed(formPersonRoute, pathParameters: {
                "id": "0",
              });
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
