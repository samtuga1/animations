import 'package:animations/theme_switcher/home.dart';
import 'package:flutter/material.dart';

ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.light);

class ThemeSwitcherApp extends StatelessWidget {
  const ThemeSwitcherApp({super.key});

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
