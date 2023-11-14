import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'utils/dependency_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DependencyHandler dependencyHandler = DependencyHandler();
  await dependencyHandler.initializeDB();

  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
