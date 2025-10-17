import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instakarm/core/theme/app_theme.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
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
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              // Subheadline
              Text(
                'Level up your Mind',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                  color: Colors.black.withAlpha(230),
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
                    foregroundColor: const Color(0xFF000000),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
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
