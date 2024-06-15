import 'package:farnfond/core/onboarding_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = GetStorage();

    Future<bool> getPermissions() async {
      var locationStatus = await Permission.location.request();
      var locationAlwaysStatus = await Permission.locationAlways.request();
      var ignoreBatteryOptimizations =
          await Permission.ignoreBatteryOptimizations.request();

      if (!locationStatus.isGranted) {
        Get.snackbar(
          "Location Permission Required",
          "Please enable location permissions to use the app.",
        );
      }

      if (!locationAlwaysStatus.isGranted) {
        Get.snackbar(
          "Location Permission Required",
          "Please enable location permissions to use the app.",
        );
      }

      if (!ignoreBatteryOptimizations.isGranted) {
        Get.snackbar(
          "Battery Optimization Permission Required",
          "Please disable battery optimizations for the app to work properly.",
        );
      }

      return await Permission.location.isGranted &&
          await Permission.locationAlways.isGranted &&
          await Permission.ignoreBatteryOptimizations.isGranted;
    }

    return SafeArea(
      child: Scaffold(
        body: IntroductionScreen(
          showBackButton: true,
          back: const Icon(Icons.arrow_back_rounded),
          showBottomPart: true,
          showDoneButton: true,
          done: const Icon(Icons.done_rounded),
          onDone: () {
            getPermissions().then((bool value) {
              if (!value) {
                return;
              }
              storage.write('hasSeenOnboarding', true);
              Get.offAndToNamed('/');
            });
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
