import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instant Karma'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: Center(
            child: Column(
              spacing: 16,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(flex: 4, child: Container()),
                Expanded(flex: 2, child: Column(
                  spacing: 8,
                  children: [
                    const Text('Wir sind was wir tun', style: TextStyle(fontSize: 24)),
                    const Text('Tausende Menschen verwenden Instant Karma auf ihrem Weg ein achtsameres Leben zu führen.', textAlign: TextAlign.center),
                  ],
                )),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () => context.go('/onboarding'),
                        child: const Text('Jetzt beginnen'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Schon einen Account?'),
                          TextButton(
                            onPressed: null,
                            child: const Text('Log In'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
