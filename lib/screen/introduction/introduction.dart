import '../base/base_screen.dart';
import 'view/continue_button.dart';
import 'view/no_waste_view.dart';
import 'view/control_view.dart';
import 'view/relax_view.dart';
import 'view/introduction_view.dart';
import 'view/skip_view.dart';
import 'view/welcome_view.dart';
import 'package:flutter/material.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  IntroductionScreenState createState() => IntroductionScreenState();
}

class IntroductionScreenState extends State<IntroductionScreen> with TickerProviderStateMixin {
  AnimationController? animationController;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );
    animationController?.animateTo(0.0);
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F8),
      body: ClipRect(
        child: Stack(
          children: [
            IntroductionView(
              animationController: animationController!,
            ),
            RelaxView(
              animationController: animationController!,
            ),
            NoWasteView(
              animationController: animationController!,
            ),
            ControlView(
              animationController: animationController!,
            ),
            WelcomeView(
              animationController: animationController!,
            ),
            SkipView(
              onBackClick: onBackClick,
              onSkipClick: onSkipClick,
              animationController: animationController!,
            ),
            ContinueButton(
              animationController: animationController!,
              onNextClick: onNextClick,
            ),
          ],
        ),
      ),
    );
  }

  void onSkipClick() {
    animationController?.animateTo(
      0.8,
      duration: const Duration(milliseconds: 1200),
    );
  }

  void onBackClick() {
    if (animationController!.value >= 0 && animationController!.value <= 0.2) {
      animationController?.animateTo(0.0);
    } else if (animationController!.value > 0.2 && animationController!.value <= 0.4) {
      animationController?.animateTo(0.2);
    } else if (animationController!.value > 0.4 && animationController!.value <= 0.6) {
      animationController?.animateTo(0.4);
    } else if (animationController!.value > 0.6 && animationController!.value <= 0.8) {
      animationController?.animateTo(0.6);
    } else if (animationController!.value > 0.8 && animationController!.value <= 1.0) {
      animationController?.animateTo(0.8);
    }
  }

  void onNextClick() {
    if (animationController!.value >= 0 && animationController!.value <= 0.2) {
      animationController?.animateTo(0.4);
    } else if (animationController!.value > 0.2 && animationController!.value <= 0.4) {
      animationController?.animateTo(0.6);
    } else if (animationController!.value > 0.4 && animationController!.value <= 0.6) {
      animationController?.animateTo(0.8);
    } else if (animationController!.value > 0.6 && animationController!.value <= 0.8) {
      goToApp();
    }
  }

  void goToApp() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BaseScreen(),
      ),
    );
  }
}
