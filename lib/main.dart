import 'package:animations/theme-switcher/home.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.light);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeMode,
      builder: (ctx, theme, _) => MaterialApp(
        themeMode: theme,
        title: 'Flutter Demo',
        theme: ThemeData.light(
          useMaterial3: true,
        ),
        darkTheme: ThemeData.dark(
          useMaterial3: true,
        ),
        home: const ThemeSwitcher(),
      ),
    );
  }
}
