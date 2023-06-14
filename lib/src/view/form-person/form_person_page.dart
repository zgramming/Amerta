// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:amerta/src/injection.dart';
import 'package:amerta/src/utils/functions.dart';
import 'package:amerta/src/utils/styles.dart';
import 'package:amerta/src/view/widgets/form_body.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../model/model/person_model.dart';
import '../../utils/fonts.dart';

class FormPersonPage extends ConsumerStatefulWidget {
  const FormPersonPage({
    super.key,
    required this.id,
  });

  final int id;

  @override
  createState() => _FormPersonPageState();
}

class _FormPersonPageState extends ConsumerState<FormPersonPage> {
  final formKey = GlobalKey<FormState>();

  late final TextEditingController nameController;

  Future<void> save(PersonModel? person) async {
    try {
      final validate = formKey.currentState?.validate();
      if (validate == null || !validate) {
        return;
      }

      if (person == null) {
        await ref.read(personNotifier.notifier).save(
              PersonModel(
                id: 1,
                createdAt: DateTime.now(),
                name: nameController.text,
                updatedAt: DateTime.now(),
              ),
            );
        formKey.currentState?.reset();
      } else {
        await ref.read(personNotifier.notifier).update(
              PersonModel(
                id: person.id,
                createdAt: person.createdAt,
                name: nameController.text,
                updatedAt: DateTime.now(),
              ),
            );
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
    nameController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(getPersonById(widget.id), (previous, next) {
      next.whenData((value) {
        nameController.text = value?.name ?? "";
      });
    });

    ref.listen(personNotifier.select((value) => value.onUpdate),
        (previous, next) {
      next.when(
        data: (data) {
          context.pop();
          return FunctionUtils.showSuccessDialog(
            context: context,
            message: data ?? "",
          );
        },
        error: (error, stackTrace) {
          context.pop();

          return FunctionUtils.showAlertDialog(
              context: context, message: error.toString());
        },
        loading: () => FunctionUtils.showLoadingDialog(context: context),
      );
    });

    ref.listen(personNotifier.select((value) => value.onSave),
        (previous, next) {
      next.when(
        data: (data) {
          context.pop();

          return FunctionUtils.showSuccessDialog(
            context: context,
            message: data ?? "",
          );
        },
        error: (error, stackTrace) {
          context.pop();

          return FunctionUtils.showAlertDialog(
              context: context, message: error.toString());
        },
        loading: () => FunctionUtils.showLoadingDialog(context: context),
      );
    });

    final futurePerson = ref.watch(getPersonById(widget.id));
    return futurePerson.when(
      data: (person) {
        return Scaffold(
          appBar: AppBar(
            title: Text(person == null ? "Tambah" : "Ubah"),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        FormBody(
                          title: "Nama",
                          child: TextFormField(
                            controller: nameController,
                            decoration: inputDecorationRounded(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Nama tidak boleh kosong";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  onPressed: () => save(person),
                  icon: const Icon(Icons.save),
                  label: const Text("Simpan"),
                ),
              ),
            ],
          ),
        );
      },
      error: (error, stackTrace) => Scaffold(
        body: Center(
          child: Text(
            error.toString(),
            style: lato.copyWith(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
