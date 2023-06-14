import 'package:amerta/src/injection.dart';
import 'package:amerta/src/model/database/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/app.dart';

/// dart run build_runner watch --delete-conflicting-outputs
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = MyDatabase();

  runApp(
    ProviderScope(
      overrides: [
        myDatabaseProvider.overrideWithValue(database),
      ],
      child: const MyApp(),
    ),
  );
}
