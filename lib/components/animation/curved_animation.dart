import 'package:flutter/material.dart';

class CurvedAnimationCustom extends StatefulWidget {
  const CurvedAnimationCustom({Key? key}) : super(key: key);

  @override
  _CurvedAnimationCustomState createState() => _CurvedAnimationCustomState();
}

class _CurvedAnimationCustomState extends State<CurvedAnimationCustom>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      animationBehavior: AnimationBehavior.preserve,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.5, end: 1.5).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut, // Smooth animation curve
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: Image.asset('assets/images/Emoji.png'),
    );
  }
}
