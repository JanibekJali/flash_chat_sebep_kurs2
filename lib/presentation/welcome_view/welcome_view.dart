import 'package:flash_chat/components/animation/curved_animation.dart';
import 'package:flash_chat/components/animation/text_animation.dart';
import 'package:flash_chat/components/buttons/custom_button.dart';
import 'package:flash_chat/presentation/login_view/login_view.dart';
import 'package:flash_chat/presentation/register_view/register_view.dart';
import 'package:flutter/material.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CurvedAnimationCustom(),
                TextAnimation(),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            CustomButton(
              data: "Кириш",
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginView()));
              },
            ),
            SizedBox(
              height: 20,
            ),
            CustomButton(
              data: "Катталуу",
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RegisterView()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
