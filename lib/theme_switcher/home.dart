import 'package:animations/theme_switcher/app.dart';
import 'package:animations/theme_switcher/widgets/overlay_widget.dart';
import 'package:flutter/material.dart';

class ThemeSwitcher extends StatefulWidget {
  const ThemeSwitcher({super.key});

  @override
  State<ThemeSwitcher> createState() => _ThemeSwitcherState();
}

class _ThemeSwitcherState extends State<ThemeSwitcher> {
  ThemeData initialThemeData = themeMode.value == ThemeMode.light
      ? ThemeData.light(
          useMaterial3: true,
        )
      : ThemeData.dark(
          useMaterial3: true,
        );

  _handleThemeIconPressed() {
    _toggleThemeMode();

    OverlayEntry overlayEntry = OverlayEntry(
      builder: (_) => const ThemeOverlayWidget(),
    );

    if (!overlayEntry.mounted) {
      Overlay.of(context).insert(overlayEntry);
    }

    // wait for 1 second then remove the overlay and reset the theme on this
    // screen to the global theme data
    Future.delayed(const Duration(milliseconds: 2000), () {
      // reset the initial theme mode

      if (context.mounted) {
        initialThemeData = Theme.of(context);
      }
      setState(() {});

      if (overlayEntry.mounted) {
        overlayEntry.remove();
        overlayEntry.dispose();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: initialThemeData,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Telegram Theme Animation'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: IconButton(
                icon: themeMode.value == ThemeMode.dark
                    ? const Icon(Icons.light_mode)
                    : const Icon(
                        Icons.dark_mode,
                      ),
                onPressed: _handleThemeIconPressed,
              ),
            ),
          ],
        ),
        body: const Column(),
      ),
    );
  }

  _toggleThemeMode() {
    if (themeMode.value == ThemeMode.light) {
      themeMode.value = ThemeMode.dark;
    } else {
      themeMode.value = ThemeMode.light;
    }
  }
}
