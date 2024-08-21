import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class TextAnimation extends StatelessWidget {
  const TextAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DefaultTextStyle(
        style: const TextStyle(
          fontSize: 20.0,
        ),
        child: AnimatedTextKit(
          // repeatForever: true,
          animatedTexts: [
            WavyAnimatedText(
              'Flash Chat',
              speed: const Duration(milliseconds: 250),
              textStyle: const TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
          isRepeatingAnimation: true,
          onTap: () {
            log("Tap Event");
          },
        ),
      ),
    );
  }
}
