import 'package:farnfond/core/onboarding_image.dart';
import 'package:farnfond/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IntroductionScreen(
          showBackButton: true,
          back: const Icon(Icons.arrow_back_rounded),
          showBottomPart: true,
          showDoneButton: true,
          done: const Icon(Icons.done_rounded),
          onDone: () {
            Get.offAll(() => const LoginScreen());
          },
          showNextButton: true,
          next: const Icon(Icons.arrow_forward_rounded),
          showSkipButton: false,
          pages: [
            PageViewModel(
              titleWidget: Text(
                "Welcome to Far n' Fond!",
                style: GoogleFonts.sacramento(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              body: "Bringing hearts closer, no matter the distance.",
              image: const OnboardingImage(
                assetImagePath: 'assets/onboarding_one.png',
              ),
              decoration: const PageDecoration(
                bodyAlignment: Alignment.center,
                fullScreen: true,
                pageMargin: EdgeInsets.all(8),
              ),
            ),
            PageViewModel(
              titleWidget: Text(
                "Stay Connected",
                style: GoogleFonts.sacramento(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              body:
                  "Enjoy seamless chatting, video calls, and interactive activities to feel together even when you're apart.",
              image: const OnboardingImage(
                assetImagePath: "assets/onboarding_two.png",
              ),
              decoration: const PageDecoration(
                bodyAlignment: Alignment.center,
                fullScreen: true,
                pageMargin: EdgeInsets.all(8),
              ),
            ),
            PageViewModel(
              titleWidget: Text(
                "Create Memories",
                style: GoogleFonts.sacramento(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              body:
                  "Share calendars, set countdowns for your next visit, and send real-time location updates to keep the love alive",
              image: const OnboardingImage(
                assetImagePath: "assets/onboarding_three.png",
              ),
              decoration: const PageDecoration(
                bodyAlignment: Alignment.center,
                fullScreen: true,
                pageMargin: EdgeInsets.all(8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
