import 'package:flutter/material.dart';

import '../../utils/fonts.dart';

class FormBody extends StatelessWidget {
  const FormBody({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: lato.copyWith(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16.0),
        child,
      ],
    );
  }
}
