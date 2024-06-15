import 'package:farnfond/screens/home_screen.dart';
import 'package:farnfond/screens/onboarding_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import 'firebase_options.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = GetStorage();
    final bool hasSeenOnboarding = storage.read('hasSeenOnboarding') ?? false;

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/": (context) => const HomeScreen(),
        "/onboarding": (context) => const OnboardingScreen(),
      },
      initialRoute: hasSeenOnboarding ? "/" : "/onboarding",
      // initialRoute: "/onboarding",
      title: "Far n' Fond",
      theme: ThemeData.dark(
        useMaterial3: true,
      ).copyWith(
        textTheme:
            GoogleFonts.rubikTextTheme(Theme.of(context).textTheme).copyWith(
          labelSmall: const TextStyle(
            color: Color(0xFFF4F4FB),
          ),
          labelMedium: const TextStyle(
            color: Color(0xFFF4F4FB),
          ),
          labelLarge: const TextStyle(
            color: Color(0xFFF4F4FB),
          ),
          displaySmall: GoogleFonts.sacramento(),
          displayMedium: GoogleFonts.sacramento(),
          displayLarge: GoogleFonts.sacramento(),
          bodySmall: const TextStyle(
            color: Color(0xFFF4F4FB),
          ),
          bodyMedium: const TextStyle(
            color: Color(0xFFF4F4FB),
          ),
          bodyLarge: const TextStyle(
            color: Color(0xFFF4F4FB),
          ),
          headlineSmall: const TextStyle(
            color: Color(0xFFF4F4FB),
          ),
          headlineMedium: const TextStyle(
            color: Color(0xFFF4F4FB),
          ),
          headlineLarge: const TextStyle(
            color: Color(0xFFF4F4FB),
          ),
          titleSmall: const TextStyle(
            color: Color(0xFFF4F4FB),
          ),
          titleMedium: const TextStyle(
            color: Color(0xFFF4F4FB),
          ),
          titleLarge: const TextStyle(
            color: Color(0xFFF4F4FB),
          ),
        ),
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
        colorScheme: const ColorScheme(
          primary: Color(0xFF5E69EE),
          secondary: Color(0xFFF4F4FB),
          surface: Color(0xFF1A1A1A),
          tertiary: Color(0xFF39AFEA),
          brightness: Brightness.dark,
          error: Color(0xFFD32F2F),
          onSurface: Color(0xFFF4F4FB),
          onError: Color(0xFFF4F4FB),
          onPrimary: Color(0xFFF4F4FB),
          onTertiary: Color(0xFF1A1A1A),
          onSecondary: Color(0xFF5E69EE),
        ),
      ),
    );
  }
}
