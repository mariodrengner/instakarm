import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFD4FC79),
              Color(0xFF96E6A1),
            ],
            stops: [0.0, 1.0],
            transform: GradientRotation(135 * 3.1415926535 / 180),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App-Logo
              Image.asset(
                'assets/images/logo.png',
                width: 120,
                height: 120,
              ),
              const SizedBox(height: 24),
              // Titel
              Text(
                'InstaKarm',
                style: GoogleFonts.rubik(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              // Subheadline
              Text(
                'Level up your Mind',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const Spacer(),
              // CTA-Button
              Padding(
                padding: const EdgeInsets.only(bottom: 64.0),
                child: ElevatedButton(
                  onPressed: () {
                    context.go('/onboarding');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF96E6A1),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 48, vertical: 16),
                    textStyle: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  child: const Text('Los geht\'s'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}