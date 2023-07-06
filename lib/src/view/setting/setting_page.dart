import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../injection.dart';
import '../../utils/functions.dart';

class SettingPage extends ConsumerWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      exportNotifier.select((value) => value.onExport),
      (previous, next) {
        next.when(
          data: (data) {
            context.pop();
            FunctionUtils.showSuccessDialog(
              context: context,
              title: 'Success',
              message: 'Exported to ${data?.path}',
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Kembali'),
                ),
                Builder(
                  builder: (context) {
                    return ElevatedButton.icon(
                      onPressed: () async {
                        try {
                          final box = context.findRenderObject() as RenderBox?;
                          final xFile = XFile(data!.path);
                          log("Share file: ${xFile.path}");
                          final result = await Share.shareXFiles(
                            [xFile],
                            text: 'Exported database',
                            subject: 'Exported database',
                            sharePositionOrigin:
                                box!.localToGlobal(Offset.zero) & box.size,
                          );

                          final isSuccess =
                              result.status == ShareResultStatus.success;

                          if (isSuccess && context.mounted) {
                            context.pop();
                          }
                        } catch (e) {
                          log("Share error: $e");
                        }
                      },
                      icon: const Icon(Icons.share),
                      label: const Text('Share'),
                    );
                  },
                ),
              ],
            );
          },
          error: (e, s) {
            context.pop();
            return FunctionUtils.showAlertDialog(
              context: context,
              title: 'Error',
              message: e.toString(),
            );
          },
          loading: () => FunctionUtils.showLoadingDialog(context: context),
        );
      },
    );
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          margin: const EdgeInsets.only(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                leading: const Icon(Icons.arrow_upward_rounded),
                title: const Text('Export Database'),
                subtitle: const Text("Export database to JSON file"),
                trailing: const Icon(Icons.keyboard_arrow_right),
                onTap: () async {
                  await ref.read(exportNotifier.notifier).export();
                },
              ),
              ListTile(
                leading: const Icon(Icons.arrow_downward_rounded),
                title: const Text('Import Database'),
                subtitle: const Text("Import database from JSON file"),
                trailing: const Icon(Icons.keyboard_arrow_right),
                onTap: () async {
                  await showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => const _ModalImportDatabase(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModalImportDatabase extends ConsumerWidget {
  const _ModalImportDatabase();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(importNotifier.select((value) => value.onImport),
        (previous, next) {
      next.when(
        data: (data) {
          context.pop();
          FunctionUtils.showSuccessDialog(
            context: context,
            title: 'Success',
            message: data ?? 'Imported database',
          );
        },
        error: (error, stackTrace) => FunctionUtils.showAlertDialog(
          context: context,
          title: 'Error',
          message: error.toString(),
        ),
        loading: () => FunctionUtils.showLoadingDialog(context: context),
      );
    });

    return AlertDialog(
      title: const Text('Import Database'),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.warning,
            size: 48.0,
            color: Colors.amber,
            semanticLabel: 'Warning',
          ),
          SizedBox(height: 10.0),
          Text(
            'File yang diimport akan menggantikan database yang ada. Pastikan file yang diimport adalah hasil export dari aplikasi ini. Apakah anda yakin ingin melanjutkan?',
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 10.0),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
          },
          child: const Text('Kembali'),
        ),
        ElevatedButton.icon(
          onPressed: () async {
            final resultPicker = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['json'],
            );

            if (resultPicker != null) {
              final path = resultPicker.files.single.path;
              final file = File(path!);

              await ref.read(importNotifier.notifier).import(file);
            }
          },
          icon: const Icon(Icons.upload_file),
          label: const Text('Upload'),
        ),
      ],
    );
  }
}
