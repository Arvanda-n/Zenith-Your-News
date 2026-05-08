import 'package:flutter/material.dart';

import '../data/dummy_news.dart';
import '../theme/app_theme.dart';
import '../widgets/news_image.dart';
import '../widgets/zyn_logo.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.onComplete});

  final VoidCallback onComplete;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _pageIndex = 0;

  late final List<_OnboardingItem> _items = [
    _OnboardingItem(
      title: 'Berita Cepat, Tampilan Elegan',
      description:
          'Baca headline terbaru dengan visual modern, ringan, dan nyaman untuk aktivitas harianmu.',
      imageUrl: dummyNews[0].imageUrl,
      imageHint: dummyNews[0].imageHint,
      icon: Icons.auto_stories_rounded,
    ),
    _OnboardingItem(
      title: 'Update Real-Time Setiap Saat',
      description:
          'Ikuti breaking news, tren utama, dan kabar penting dalam satu aplikasi yang rapi.',
      imageUrl: dummyNews[10].imageUrl,
      imageHint: dummyNews[10].imageHint,
      icon: Icons.bolt_rounded,
    ),
    _OnboardingItem(
      title: 'Topik Trending Lebih Mudah Diikuti',
      description:
          'Temukan berita populer dan rekomendasi yang relevan dengan minatmu setiap hari.',
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
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFF),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 14, 22, 8),
              child: Row(
                children: [
                  const ZynLogo(
                    size: 48,
                    radius: 16,
                    showPlate: true,
                    padding: EdgeInsets.all(4),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'ZYN News',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: widget.onComplete,
                    child: const Text('Lewati'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _items.length,
                onPageChanged: (value) => setState(() => _pageIndex = value),
                itemBuilder: (context, index) {
                  return _OnboardingPage(
                    item: _items[index],
                    isActive: index == _pageIndex,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_items.length, (index) {
                      final active = index == _pageIndex;

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        width: active ? 28 : 9,
                        height: 9,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          color: active
                              ? AppTheme.primary
                              : const Color(0xFFD5E3F5),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: FilledButton(
                      onPressed: _goNext,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      child: Text(
                        _isLastPage ? 'Mulai Membaca' : 'Selanjutnya',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
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
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.item, required this.isActive});

  final _OnboardingItem item;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 280),
      opacity: isActive ? 1 : 0.65,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
        child: Column(
          children: [
            Expanded(
              flex: 6,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(36),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primary.withValues(alpha: 0.16),
                            blurRadius: 32,
                            offset: const Offset(0, 18),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(36),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            NewsImage(
                              imageUrl: item.imageUrl,
                              imageHint: item.imageHint,
                              borderRadius: BorderRadius.circular(36),
                            ),
                            DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.10),
                                    Colors.black.withValues(alpha: 0.55),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 18,
                    left: 18,
                    child: _GlassBadge(icon: item.icon),
                  ),
                  Positioned(right: -10, bottom: 32, child: _FloatingCard()),
                ],
              ),
            ),
            const SizedBox(height: 34),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Text(
                    item.title,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      height: 1.12,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    item.description,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      height: 1.55,
                      color: const Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlassBadge extends StatelessWidget {
  const _GlassBadge({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.7)),
      ),
      child: Icon(icon, color: AppTheme.primary, size: 26),
    );
  }
}

class _FloatingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 132,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: const Row(
        children: [
          Icon(Icons.trending_up_rounded, color: Color(0xFF06B6D4), size: 22),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Trending',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 13,
                color: Color(0xFF0F172A),
              ),
            ),
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
