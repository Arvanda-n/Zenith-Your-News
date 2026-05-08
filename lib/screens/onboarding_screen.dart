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
                  AppTheme.primary.withValues(alpha: 0.04),
                  theme.scaffoldBackgroundColor,
                ],
              ),
            ),
            child: Stack(
              children: [
                const _FloatingGlow(
                  top: -26,
                  left: -48,
                  size: 170,
                  opacity: 0.10,
                ),
                const _FloatingGlow(
                  top: 140,
                  right: -40,
                  size: 120,
                  opacity: 0.12,
                ),
                const _FloatingGlow(
                  bottom: 90,
                  left: -26,
                  size: 94,
                  opacity: 0.12,
                ),
                const _FloatingGlow(
                  bottom: 30,
                  right: -18,
                  size: 100,
                  opacity: 0.10,
                ),
                Positioned(
                  left: 48,
                  top: 110,
                  child: _Sparkle(
                    color: AppTheme.primary.withValues(alpha: 0.36),
                  ),
                ),
                Positioned(
                  right: 72,
                  top: 208,
                  child: _Sparkle(
                    color: AppTheme.secondary.withValues(alpha: 0.30),
                  ),
                ),
                Positioned(
                  left: 32,
                  bottom: 146,
                  child: _Sparkle(
                    color: AppTheme.primary.withValues(alpha: 0.22),
                  ),
                ),
              ],
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
          final imageSize = _resolveHeroSize(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
          );
          final topGap = constraints.maxHeight < 520 ? 16.0 : 30.0;
          final titleGap = constraints.maxHeight < 520 ? 22.0 : 40.0;

          return Padding(
            padding: const EdgeInsets.fromLTRB(24, 88, 24, 12),
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: topGap),
                    _HeroOrb(item: item, size: imageSize),
                    SizedBox(height: titleGap),
                    Text(
                      item.title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w800, height: 1.1),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      item.description,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.color?.withValues(alpha: 0.58),
                        height: 1.55,
                      ),
                    ),
                    SizedBox(height: constraints.maxHeight < 520 ? 14 : 28),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  double _resolveHeroSize({required double width, required double height}) {
    final byWidth = width >= 420 ? 320.0 : 272.0;
    final byHeight = height < 430 ? height * 0.46 : height * 0.54;
    return byHeight.clamp(176.0, byWidth);
  }
}

class _HeroOrb extends StatelessWidget {
  const _HeroOrb({required this.item, required this.size});

  final _OnboardingItem item;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: <Color>[
                    AppTheme.secondary.withValues(alpha: 0.24),
                    AppTheme.primary.withValues(alpha: 0.08),
                    AppTheme.primary.withValues(alpha: 0.03),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 22,
            left: 22,
            right: 22,
            bottom: 22,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.52),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: AppTheme.primary.withValues(alpha: 0.10),
                    blurRadius: 28,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ClipOval(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      NewsImage(
                        imageUrl: item.imageUrl,
                        imageHint: item.imageHint,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: <Color>[
                              Colors.white.withValues(alpha: 0.02),
                              Colors.black.withValues(alpha: 0.28),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: size * 0.33,
            left: size * 0.33,
            child: Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.86),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: AppTheme.primary.withValues(alpha: 0.14),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(item.icon, color: AppTheme.primary, size: 40),
            ),
          ),
          Positioned(
            top: 34,
            left: -8,
            child: _Sparkle(color: AppTheme.primary.withValues(alpha: 0.32)),
          ),
          Positioned(
            bottom: 24,
            right: -2,
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.primary.withValues(alpha: 0.22),
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingGlow extends StatelessWidget {
  const _FloatingGlow({
    this.top,
    this.left,
    this.right,
    this.bottom,
    required this.size,
    required this.opacity,
  });

  final double? top;
  final double? left;
  final double? right;
  final double? bottom;
  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.primary.withValues(alpha: opacity),
        ),
      ),
    );
  }
}

class _Sparkle extends StatelessWidget {
  const _Sparkle({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28,
      height: 28,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Icon(Icons.star_rounded, size: 14, color: color),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Icon(Icons.star_rounded, size: 10, color: color),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Icon(Icons.star_rounded, size: 8, color: color),
          ),
        ],
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
