import 'package:instakarm/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instakarm/features/onboarding/presentation/providers/onboarding_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _nameController = TextEditingController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  Future<void> _completeOnboarding() async {
    // Read the notifier to call methods on it
    await ref.read(onboardingViewModelProvider.notifier).completeOnboarding();
    if (mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<OnboardingState>>(onboardingViewModelProvider,
        (previous, next) {
      next.whenData((state) {
        if (_nameController.text != state.userName) {
          _nameController.text = state.userName;
        }
      });
    });

    final viewModelState = ref.watch(onboardingViewModelProvider);
    final viewModelNotifier = ref.read(onboardingViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      body: viewModelState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
        data: (stateData) {
          final isLastPage = _currentPage == 2;
          return Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  children: [
                    const _IntroPage(),
                    _DifficultyPage(
                      viewState: stateData,
                      viewNotifier: viewModelNotifier,
                    ),
                    _NamePage(
                      nameController: _nameController,
                      viewNotifier: viewModelNotifier,
                    ),
                  ],
                ),
              ),
              _buildBottomBar(stateData, isLastPage),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBottomBar(OnboardingState viewModelState, bool isLastPage) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) => _buildDot(index: index)),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLastPage ? _completeOnboarding : () {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryCta,
                foregroundColor: AppTheme.primaryCtaForeground,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              child: viewModelState.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(isLastPage ? 'Jetzt starten' : 'Weiter'),
            ),
          ),
          if (!isLastPage)
            TextButton(
              onPressed: _completeOnboarding,
              child: Text(
                'Überspringen und gleich loslegen',
                style: GoogleFonts.inter(color: Colors.black.withAlpha(153)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDot({required int index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(right: 8),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? AppTheme.dotActive : AppTheme.dotInactive,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

// Step 1: Intro Page
class _IntroPage extends StatelessWidget {
  const _IntroPage();

  @override
  Widget build(BuildContext context) {
    return const _OnboardingPageContent(
      title: 'Willkommen bei InstaKarm',
      subtitle:
          'Jeden Tag kleine Aufgaben. Motivation, Spaß und Fortschritt in deinem Alltag.',
      child: _OnboardingImage('assets/images/onboarding/1.png'),
    );
  }
}

// Step 2: Difficulty Page
class _DifficultyPage extends StatelessWidget {
  final OnboardingState viewState;
  final OnboardingViewModel viewNotifier;

  const _DifficultyPage({
    required this.viewState,
    required this.viewNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return _OnboardingPageContent(
      title: 'Wie viel möchtest du dir vornehmen?',
      subtitle: 'Passe die Herausforderung an deinen Alltag an.',
      child: Column(
        children: [
          _DifficultyButton(
            label: 'Einfach',
            tasks: 1,
            categories: 1,
            isSelected: viewState.difficulty == 'easy',
            onTap: () => viewNotifier.setDifficulty('easy', 1, 1),
          ),
          _DifficultyButton(
            label: 'Mittel',
            tasks: 3,
            categories: 3,
            isSelected: viewState.difficulty == 'medium',
            onTap: () => viewNotifier.setDifficulty('medium', 3, 3),
          ),
          _DifficultyButton(
            label: 'Schwer',
            tasks: 7,
            categories: 7,
            isSelected: viewState.difficulty == 'hard',
            onTap: () => viewNotifier.setDifficulty('hard', 7, 7),
          ),
        ],
      ),
    );
  }
}

// Step 3: Name Page
class _NamePage extends StatelessWidget {
  final TextEditingController nameController;
  final OnboardingViewModel viewNotifier;

  const _NamePage({
    required this.nameController,
    required this.viewNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return _OnboardingPageContent(
      title: 'Wie sollen wir dich nennen?',
      subtitle: 'Du kannst den Namen jederzeit ändern.',
      child: Column(
        children: [
          TextField(
            controller: nameController,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(color: Colors.black87, fontSize: 24),
            decoration: InputDecoration(
              hintText: 'z.B. MutMacher3000',
              hintStyle: GoogleFonts.inter(
                  color: Colors.black.withAlpha((255 * 0.5).round())),
              border: InputBorder.none,
              suffixIcon: IconButton(
                icon: const Icon(Icons.refresh, color: AppTheme.primaryCta),
                onPressed: viewNotifier.regenerateRandomName,
              ),
            ),
            onChanged: viewNotifier.updateUserName,
          ),
        ],
      ),
    );
  }
}

// Onboarding Image Widget
class _OnboardingImage extends StatelessWidget {
  final String assetPath;

  const _OnboardingImage(this.assetPath);

  @override
  Widget build(BuildContext context) {
    return Image.asset(assetPath, height: 250);
  }
}

// Helper widget for consistent page layout
class _OnboardingPageContent extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _OnboardingPageContent({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 16, color: Colors.black.withAlpha(204), height: 1.5),
          ),
          const SizedBox(height: 48),
          child,
        ],
      ),
    );
  }
}

// Helper widget for difficulty buttons
class _DifficultyButton extends StatelessWidget {
  final String label;
  final int tasks;
  final int categories;
  final bool isSelected;
  final VoidCallback onTap;

  const _DifficultyButton({
    required this.label,
    required this.tasks,
    required this.categories,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryCta : Colors.black.withAlpha(10),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primaryCta : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.black87),
            ),
            const SizedBox(height: 4),
            Text(
              '$tasks Aufgabe${tasks > 1 ? 'n' : ''} in $categories Kategorie${categories > 1 ? 'n' : ''}',
              style: GoogleFonts.inter(
                  fontSize: 14, color: isSelected ? Colors.white.withAlpha(204) : Colors.black.withAlpha(204)),
            ),
          ],
        ),
      ),
    );
  }
}
