import 'package:flutter/material.dart';

class OnboardingImage extends StatelessWidget {
  const OnboardingImage({super.key, required this.assetImagePath});

  final String assetImagePath;

  @override
  Widget build(BuildContext context) {
    return Image(
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        return Container(
          foregroundDecoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black,
              ],
              stops: [0.4, 1],
            ),
          ),
          child: child,
        );
      },
      image: AssetImage(assetImagePath),
    );
  }
}
