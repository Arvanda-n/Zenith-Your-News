import 'package:flutter/material.dart';

import '../data/dummy_news.dart';
import '../theme/app_theme.dart';
import '../widgets/news_image.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.onComplete});

  final VoidCallback onComplete;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _pageIndex = 0;

  late final List<_OnboardingItem> _items = <_OnboardingItem>[
    _OnboardingItem(
      title: 'Selamat Datang di ZYN',
      description:
          'Nikmati pengalaman membaca berita yang lebih elegan, ringan, dan nyaman untuk ritme harianmu.',
      imageUrl: dummyNews[0].imageUrl,
      imageHint: dummyNews[0].imageHint,
      icon: Icons.waving_hand_rounded,
    ),
    _OnboardingItem(
      title: 'Dapatkan Berita Real-Time',
      description:
          'Headline penting, pembaruan cepat, dan visual premium hadir dalam satu aplikasi mobile-first.',
      imageUrl: dummyNews[10].imageUrl,
      imageHint: dummyNews[10].imageHint,
      icon: Icons.bolt_rounded,
    ),
    _OnboardingItem(
      title: 'Ikuti Trending News Setiap Hari',
      description:
          'Pantau topik yang sedang ramai dan mulai hari dengan feed berita yang terasa lebih relevan.',
      imageUrl: dummyNews[25].imageUrl,
      imageHint: dummyNews[25].imageHint,
      icon: Icons.local_fire_department_rounded,
    ),
  ];

  bool get _isLastPage => _pageIndex == _items.length - 1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goNext() {
    if (_isLastPage) {
      widget.onComplete();
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 360),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);
    final topPadding = media.padding.top + 12;

    return Scaffold(
      body: Stack(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  const Color(0xFFF7FAFF),
                  AppTheme.primary.withValues(alpha: 0.05),
                  theme.scaffoldBackgroundColor,
                ],
              ),
            ),
          ),
          Positioned(
            top: topPadding,
            left: 20,
            right: 20,
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.auto_stories_rounded,
                    color: AppTheme.primary,
                    size: 18,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: widget.onComplete,
                  icon: const Icon(Icons.skip_next_rounded),
                  label: const Text('Lewati'),
                ),
              ],
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _items.length,
                    onPageChanged: (value) =>
                        setState(() => _pageIndex = value),
                    itemBuilder: (context, index) {
                      return _OnboardingPage(
                        item: _items[index],
                        isActive: index == _pageIndex,
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 26),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_items.length, (index) {
                          final active = index == _pageIndex;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            width: active ? 26 : 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: active
                                  ? AppTheme.primary
                                  : Colors.black.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(999),
                              boxShadow: active
                                  ? <BoxShadow>[
                                      BoxShadow(
                                        color: AppTheme.primary.withValues(
                                          alpha: 0.18,
                                        ),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ]
                                  : null,
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _goNext,
                          style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(64),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
                            ),
                            elevation: 8,
                            shadowColor: AppTheme.primary.withValues(
                              alpha: 0.24,
                            ),
                          ),
                          child: Text(
                            _isLastPage ? 'Mulai Sekarang' : 'Selanjutnya',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.item, required this.isActive});

  final _OnboardingItem item;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 260),
      opacity: isActive ? 1 : 0.82,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxHeight < 640;
          final horizontalPadding = constraints.maxWidth < 360 ? 20.0 : 24.0;

          return Stack(
            children: [
              Positioned.fill(child: _HeroVisual(item: item)),
              Positioned(
                top: compact ? 92 : 108,
                left: horizontalPadding,
                right: horizontalPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.88),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: AppTheme.primary.withValues(alpha: 0.08),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(item.icon, color: AppTheme.primary, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'News Daily Brief',
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(
                                  color: AppTheme.primary,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: compact ? 18 : 24),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 320),
                      child: Text(
                        item.title,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w900,
                              height: 1.05,
                              color: const Color(0xFF0E1726),
                            ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 320),
                      child: Text(
                        item.description,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: const Color(
                            0xFF364152,
                          ).withValues(alpha: 0.82),
                          height: 1.55,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _HeroVisual extends StatelessWidget {
  const _HeroVisual({required this.item});

  final _OnboardingItem item;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: NewsImage(
            imageUrl: item.imageUrl,
            imageHint: item.imageHint,
            borderRadius: BorderRadius.zero,
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const <double>[0.0, 0.20, 0.42, 0.68, 1.0],
                colors: <Color>[
                  const Color(0xFFF7FAFF),
                  const Color(0xFFF7FAFF).withValues(alpha: 0.96),
                  const Color(0xFFF7FAFF).withValues(alpha: 0.74),
                  const Color(0xFFF7FAFF).withValues(alpha: 0.20),
                  const Color(0xFFF7FAFF).withValues(alpha: 0.06),
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const <double>[0.0, 0.56, 0.86, 1.0],
                colors: <Color>[
                  AppTheme.primary.withValues(alpha: 0.04),
                  Colors.transparent,
                  AppTheme.primary.withValues(alpha: 0.05),
                  AppTheme.primary.withValues(alpha: 0.08),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 24,
          top: 36,
          child: _AccentBubble(icon: item.icon, angle: -0.14, size: 88),
        ),
        Positioned(
          right: 26,
          top: 44,
          child: _AccentBubble(
            icon: Icons.auto_awesome_rounded,
            angle: 0.14,
            size: 52,
            filled: false,
          ),
        ),
        Positioned(
          right: 82,
          top: 122,
          child: _AccentBubble(
            icon: Icons.bolt_rounded,
            angle: -0.08,
            size: 42,
            filled: false,
          ),
        ),
      ],
    );
  }
}

class _AccentBubble extends StatelessWidget {
  const _AccentBubble({
    required this.icon,
    required this.angle,
    required this.size,
    this.filled = true,
  });

  final IconData icon;
  final double angle;
  final double size;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: filled
              ? Colors.white.withValues(alpha: 0.86)
              : AppTheme.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(size * 0.32),
          border: Border.all(
            color: AppTheme.primary.withValues(alpha: filled ? 0.08 : 0.16),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppTheme.primary.withValues(alpha: 0.10),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: size * 0.36,
          color: AppTheme.primary.withValues(alpha: 0.84),
        ),
      ),
    );
  }
}

class _OnboardingItem {
  const _OnboardingItem({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.imageHint,
    required this.icon,
  });

  final String title;
  final String description;
  final String imageUrl;
  final String imageHint;
  final IconData icon;
}
