import 'package:farnfond/core/global_state.dart';
import 'package:farnfond/screens/home_screen.dart';
import 'package:farnfond/screens/onboarding_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final userStream = FirebaseAuth.instance.authStateChanges();

  @override
  void initState() {
    userStream.listen((user) {
      if (user == null) {
        Get.offAll(() => const OnboardingScreen());
      } else {
        Get.offAll(() => const HomeScreen());
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    userStream.drain();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Far n' Fond",
      initialBinding: BindingsBuilder(
        () {
          Get.lazyPut<GlobalStateController>(() => GlobalStateController());
        },
      ),
      defaultTransition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 500),
      theme: ThemeData.dark(
        useMaterial3: true,
      ).copyWith(
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: const Color(0xFF5E69EE),
          ),
        ),
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
          displaySmall: GoogleFonts.pacifico(),
          displayMedium: GoogleFonts.pacifico(),
          displayLarge: GoogleFonts.pacifico(),
          bodySmall: const TextStyle(
            color: Color(0xFFF4F4FB),
          ),
          bodyMedium: const TextStyle(
            color: Color(0xFFF4F4FB),
          ),
          bodyLarge: const TextStyle(
            color: Color(0xFFF4F4FB),
          ),
          headlineSmall: GoogleFonts.pacifico(),
          headlineMedium: GoogleFonts.pacifico(),
          headlineLarge: GoogleFonts.pacifico(),
          titleSmall: GoogleFonts.pacifico(),
          titleMedium: GoogleFonts.pacifico(),
          titleLarge: GoogleFonts.pacifico(),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5E69EE),
            foregroundColor: const Color(0xFFF4F4FB),
            fixedSize: const Size(
              double.maxFinite,
              50,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(
            color: Color(0xFFF4F4FB),
          ),
          labelStyle: TextStyle(
            color: Color(0xFFF4F4FB),
          ),
          errorStyle: TextStyle(
            color: Color(0xFFD32F2F),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFF5E69EE),
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFF5E69EE),
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFFD32F2F),
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFFD32F2F),
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
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
      home: const OnboardingScreen(),
    );
  }
}
