import 'package:animations/theme_switcher/home.dart';
import 'package:flutter/material.dart';

class ThemeOverlayWidget extends StatefulWidget {
  const ThemeOverlayWidget({super.key});

  @override
  State<ThemeOverlayWidget> createState() => _ThemeOverlayWidgetState();
}

class _ThemeOverlayWidgetState extends State<ThemeOverlayWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _radiusAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _radiusAnimation = Tween<double>(begin: 0, end: 1000).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.addListener(() {
      setState(() {});
    });

    _animationController.forward();

    super.initState();
  }

  @override
  void dispose() {
    if (mounted) {
      _animationController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: ClipOval(
              clipper: _CustomCircleClipper(_radiusAnimation.value),
              child: const ThemeSwitcher(),
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomCircleClipper extends CustomClipper<Rect> {
  _CustomCircleClipper(this.radius);
  late double radius;
  @override
  Rect getClip(Size size) {
    return Rect.fromCircle(center: Offset(size.width - 20, 50), radius: radius);
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) => true;
}
