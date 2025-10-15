import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'widgets/onboarding_page.dart';
import 'widgets/page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with TickerProviderStateMixin {
  late PageController _pageViewController;
  late TabController _tabController;
  int _currentPageIndex = 0;

  final List<Widget> pages = [
    OnboardingPage(
      title: 'Ganz locker und leicht',
      image: 'assets/images/onboarding/1.png',
      text: 'Ein Quest mit 7 einfachen Aufgaben pro Tag',
    ),
    OnboardingPage(
      title: 'Deine Gewohnheiten',
      text: 'So funktioniert’s…',
    ),
    OnboardingPage(
      title: 'Leg los',
      text: 'Starte heute…',
    ),
  ];

  void _handlePageViewChanged(int currentPageIndex) {
    _tabController.index = currentPageIndex;
    setState(() {
      _currentPageIndex = currentPageIndex;
    });
  }

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController(viewportFraction: 0.8);
    _tabController = TabController(length: pages.length, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLastPage = _currentPageIndex == pages.length - 1;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Instant Karma',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        actions: [
          if (!isLastPage)
            TextButton(
              onPressed: () {
                _pageViewController.jumpToPage(pages.length - 1);
              },
              child: const Text('Überspringen'),
            ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            'assets/images/bg/onboarding.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: PageView.builder(
                  controller: _pageViewController,
                  itemCount: pages.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 32, horizontal: 8),
                      child: pages[index],
                    );
                  },
                  onPageChanged: _handlePageViewChanged,
                ),
              ),
              PageIndicator(
                tabController: _tabController,
                currentPageIndex: _currentPageIndex,
              ),
            ],
          ),
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child: ElevatedButton(
              onPressed: () {
                if (isLastPage) {
                  context.go('/home');
                } else {
                  _pageViewController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
              child: Text(isLastPage ? 'Los geht\'s' : 'Weiter'),
            ),
          )
        ],
      ),
    );
  }
}
