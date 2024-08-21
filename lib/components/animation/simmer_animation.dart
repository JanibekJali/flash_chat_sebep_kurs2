import 'package:flutter/material.dart';

class CustomShimmer extends StatefulWidget {
  final Widget child;

  CustomShimmer({required this.child});

  @override
  _CustomShimmerState createState() => _CustomShimmerState();
}

class _CustomShimmerState extends State<CustomShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true); // Makes the shimmer effect go back and forth
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (rect) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.grey.withOpacity(0.3),
                Colors.grey.withOpacity(0.7),
                Colors.grey.withOpacity(0.3),
              ],
              stops: [
                _controller.value - 0.3,
                _controller.value,
                _controller.value + 0.3,
              ],
            ).createShader(rect);
          },
          child: widget.child,
        );
      },
      child: widget.child,
    );
  }
}

class ShimmerDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Custom Shimmer Effect"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomShimmer(
              child: Container(
                width: double.infinity,
                height: 200,
                color: Colors.grey[300],
              ),
            ),
            SizedBox(height: 20),
            CustomShimmer(
              child: Container(
                width: double.infinity,
                height: 20,
                color: Colors.grey[300],
              ),
            ),
            SizedBox(height: 10),
            CustomShimmer(
              child: Container(
                width: double.infinity,
                height: 20,
                color: Colors.grey[300],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
