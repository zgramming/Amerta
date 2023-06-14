// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

class PreviewPDFPage extends StatefulWidget {
  const PreviewPDFPage({
    Key? key,
    required this.file,
  }) : super(key: key);

  final File file;

  @override
  State<PreviewPDFPage> createState() => _PreviewPDFPageState();
}

class _PreviewPDFPageState extends State<PreviewPDFPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview PDF'),
      ),
      body: PdfPreview(
        build: (format) => widget.file.readAsBytes(),
      ),
    );
  }
}
