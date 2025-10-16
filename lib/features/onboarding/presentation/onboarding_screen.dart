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
    // Watch the provider state for changes
    final viewModelState = ref.watch(onboardingViewModelProvider);
    final viewModelNotifier = ref.read(onboardingViewModelProvider.notifier);

    // Update text controller if state changes from outside (e.g., random name generation)
    if (_nameController.text != viewModelState.userName) {
       _nameController.text = viewModelState.userName;
    }

    final isLastPage = _currentPage == 2;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0C10),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: [
                  _buildIntroPage(),
                  _buildDifficultyPage(viewModelState, viewModelNotifier),
                  _buildNamePage(viewModelState, viewModelNotifier),
                ],
              ),
            ),
            _buildBottomBar(viewModelState, isLastPage),
          ],
        ),
      ),
    );
  }

  Widget _buildIntroPage() {
    return _OnboardingPageContent(
      title: 'Willkommen bei InstaKarm',
      subtitle: 'Jeden Tag kleine Aufgaben. Motivation, Spaß und Fortschritt in deinem Alltag.',
      child: Image.asset('assets/images/onboarding/1.png', height: 250),
    );
  }

  Widget _buildDifficultyPage(OnboardingState viewModelState, OnboardingViewModel viewModelNotifier) {
    return _OnboardingPageContent(
      title: 'Wie viel möchtest du dir vornehmen?',
      subtitle: 'Passe die Herausforderung an deinen Alltag an.',
      child: Column(
        children: [
          _DifficultyButton(
            label: 'Einfach',
            tasks: 1,
            categories: 1,
            isSelected: viewModelState.tasksPerDay == 1,
            onTap: () => viewModelNotifier.setDifficulty(1, 1),
          ),
          _DifficultyButton(
            label: 'Mittel',
            tasks: 3,
            categories: 3,
            isSelected: viewModelState.tasksPerDay == 3,
            onTap: () => viewModelNotifier.setDifficulty(3, 3),
          ),
          _DifficultyButton(
            label: 'Schwer',
            tasks: 7,
            categories: 7,
            isSelected: viewModelState.tasksPerDay == 7,
            onTap: () => viewModelNotifier.setDifficulty(7, 7),
          ),
        ],
      ),
    );
  }

  Widget _buildNamePage(OnboardingState viewModelState, OnboardingViewModel viewModelNotifier) {
    return _OnboardingPageContent(
      title: 'Wie sollen wir dich nennen?',
      subtitle: 'Du kannst den Namen jederzeit ändern.',
      child: Column(
        children: [
          TextField(
            controller: _nameController,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(color: Colors.white, fontSize: 24),
            decoration: InputDecoration(
              hintText: 'z.B. MutMacher3000',
              hintStyle: GoogleFonts.inter(color: Colors.white.withOpacity(0.5)),
              border: InputBorder.none,
              suffixIcon: IconButton(
                icon: const Icon(Icons.refresh, color: Color(0xFF66FCF1)),
                onPressed: () {
                  // Re-generates a random name
                  ref.read(onboardingViewModelProvider.notifier).regenerateRandomName();
                },
              ),
            ),
            onChanged: viewModelNotifier.updateUserName,
          ),
        ],
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
                backgroundColor: const Color(0xFF45A29E),
                foregroundColor: Colors.white,
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
                style: GoogleFonts.inter(color: Colors.white.withOpacity(0.6)),
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
        color: _currentPage == index ? const Color(0xFF66FCF1) : Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
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
            style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 16, color: Colors.white.withOpacity(0.8), height: 1.5),
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
          color: isSelected ? const Color(0xFF45A29E) : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF66FCF1) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 4),
            Text(
              '$tasks Aufgabe${tasks > 1 ? 'n' : ''} in $categories Kategorie${categories > 1 ? 'n' : ''}',
              style: GoogleFonts.inter(fontSize: 14, color: Colors.white.withOpacity(0.8)),
            ),
          ],
        ),
      ),
    );
  }
}
