import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Instant Karma',
          style: textTheme.titleLarge?.copyWith(color: colorScheme.onPrimary),
        ),
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg/start.png',
              fit: BoxFit.cover,
            ),
          ),
          // UI Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Image.asset('assets/images/logo.png', width: 200, height: 200),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Wir sind was wir tun',
                            style: textTheme.headlineSmall?.copyWith(color: colorScheme.onPrimary),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tausende Menschen verwenden Instant Karma auf ihrem Weg ein achtsameres Leben zu führen.',
                            textAlign: TextAlign.center,
                            style: textTheme.bodyLarge?.copyWith(color: colorScheme.onPrimary),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () => context.go('/onboarding'),
                              child: const Text('Jetzt beginnen'),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Schon einen Account?',
                                  style: textTheme.bodyMedium?.copyWith(color: colorScheme.onPrimary),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // TODO: Implement Login
                                  },
                                  child: const Text('Log In'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
