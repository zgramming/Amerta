import 'package:amerta/src/view_model/shared/shared_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../utils/functions.dart';
import '../../../utils/styles.dart';
import '../../widgets/form_body.dart';

class ModalFilterTransaction extends ConsumerStatefulWidget {
  const ModalFilterTransaction({
    super.key,
  });

  @override
  createState() => _ModalFilterTransactionState();
}

class _ModalFilterTransactionState
    extends ConsumerState<ModalFilterTransaction> {
  final dateFormat = DateFormat('dd MMMM yyyy');
  final formKey = GlobalKey<FormState>();

  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  late final TextEditingController _startDateController;
  late final TextEditingController _endDateController;

  Future<void> filter() async {
    final validate = formKey.currentState?.validate();

    if (validate == null || !validate) return;

    ref.read(transactionFilterProvider.notifier).update((state) {
      return state.copyWith(
        startDate: _selectedStartDate!,
        endDate: _selectedEndDate!,
      );
    });

    context.pop();
  }

  @override
  void initState() {
    super.initState();
    final defaultFilter = ref.read(transactionFilterProvider);
    _startDateController = TextEditingController(
      text: dateFormat.format(defaultFilter.startDate),
    );
    _endDateController = TextEditingController(
      text: dateFormat.format(defaultFilter.endDate),
    );

    _selectedStartDate = defaultFilter.startDate;
    _selectedEndDate = defaultFilter.endDate;
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        margin: const EdgeInsets.all(16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10.0.h),
                FormBody(
                  title: "Start Date",
                  child: TextFormField(
                    controller: _startDateController,
                    readOnly: true,
                    decoration: inputDecorationRounded().copyWith(
                      hintText: "Start Date",
                      contentPadding: const EdgeInsets.all(10.0),
                    ),
                    onTap: () async {
                      final result = await FunctionUtils.showDateTimePicker(
                        context,
                        initialDate: _selectedStartDate,
                        withTimePicker: false,
                      );

                      if (result != null) {
                        setState(() {
                          _startDateController.text = dateFormat.format(result);
                          _selectedStartDate = result;
                        });
                      }
                    },
                    validator: (value) {
                      final isNull = value == null || value.isEmpty;
                      if (isNull) return "Start date must be filled";

                      if (_selectedEndDate == null) {
                        return "End date must be filled";
                      }

                      final startDate = dateFormat.parse(value);

                      if (startDate.isAfter(_selectedEndDate!)) {
                        return "Start date must be before end date";
                      }

                      return null;
                    },
                  ),
                ),
                SizedBox(height: 10.0.h),
                FormBody(
                  title: "End Date",
                  child: TextFormField(
                    controller: _endDateController,
                    readOnly: true,
                    decoration: inputDecorationRounded().copyWith(
                      hintText: "End Date",
                      contentPadding: const EdgeInsets.all(10.0),
                    ),
                    onTap: () async {
                      final result = await FunctionUtils.showDateTimePicker(
                        context,
                        initialDate: _selectedEndDate,
                        withTimePicker: false,
                      );

                      if (result != null) {
                        setState(() {
                          _endDateController.text = dateFormat.format(result);
                          _selectedEndDate = result;
                        });
                      }
                    },
                    validator: (value) {
                      final isNull = value == null || value.isEmpty;
                      if (isNull) return "End date must be filled";

                      if (_selectedStartDate == null) {
                        return "Start date must be filled";
                      }

                      final endDate = dateFormat.parse(value);

                      if (endDate.isBefore(_selectedStartDate!)) {
                        return "End date must be after start date";
                      }

                      return null;
                    },
                  ),
                ),
                SizedBox(height: 10.0.h),
                ElevatedButton(onPressed: filter, child: const Text("Filter")),
                SizedBox(height: 10.0.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
