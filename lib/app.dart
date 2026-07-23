import 'package:flutter/material.dart';

import 'screens/root_shell.dart';
import 'theme/app_theme.dart';

class LetterApp extends StatelessWidget {
  const LetterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '想いを、言葉に。',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: const RootShell(),
    );
  }
}
