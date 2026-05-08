import 'package:flutter/material.dart';

import '../data/dummy_news.dart';
import '../theme/app_theme.dart';
import '../widgets/news_image.dart';
import '../widgets/zyn_logo.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({
    super.key,
    required this.availableCategories,
    required this.onComplete,
  });

  final List<String> availableCategories;
  final ValueChanged<Set<String>> onComplete;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final Set<String> _selectedCategories = <String>{};
  int _pageIndex = 0;

  late final List<_OnboardingItem> _items = <_OnboardingItem>[
    _OnboardingItem(
      title: 'Selamat Datang di ZYN',
      description:
          'Nikmati pengalaman membaca yang terasa premium, cepat, dan nyaman seperti aplikasi berita modern favoritmu.',
      imageUrl: dummyNews[0].imageUrl,
      imageHint: dummyNews[0].imageHint,
      accentLabel: 'Mobile-first news',
    ),
    _OnboardingItem(
      title: 'Dapatkan Berita Real-Time',
      description:
          'Headline penting, ringkasan tajam, dan visual yang rapi disusun untuk ritme baca harian yang serba cepat.',
      imageUrl: dummyNews[10].imageUrl,
      imageHint: dummyNews[10].imageHint,
      accentLabel: 'Update sepanjang hari',
    ),
    _OnboardingItem(
      title: 'Ikuti Trending News Setiap Hari',
      description:
          'Pilih topik favoritmu agar feed pertama terasa lebih personal sejak pertama kali aplikasi dibuka.',
      imageUrl: dummyNews[25].imageUrl,
      imageHint: dummyNews[25].imageHint,
      accentLabel: 'Trending + personal',
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
      widget.onComplete(_selectedCategories);
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 360),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final wideLayout = media.size.width >= 420;
    final heroHeight = wideLayout ? 420.0 : 360.0;

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              AppTheme.primary.withValues(alpha: 0.18),
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).scaffoldBackgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            children: [
              Row(
                children: [
                  const ZynLogo(size: 44, radius: 14, showPlate: true),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Mulai dengan ZYN',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => widget.onComplete(_selectedCategories),
                    child: const Text('Lewati'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: heroHeight,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _items.length,
                  onPageChanged: (value) => setState(() => _pageIndex = value),
                  itemBuilder: (context, index) {
                    return _OnboardingHero(
                      item: _items[index],
                      isActive: index == _pageIndex,
                    );
                  },
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_items.length, (index) {
                  final active = index == _pageIndex;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: active ? 26 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      gradient: active ? AppTheme.brandGradient : null,
                      color: active
                          ? null
                          : Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 22),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pilih topik favoritmu',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Agar beranda pertama terasa lebih relevan, pilih satu atau beberapa topik utama yang ingin kamu ikuti.',
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: widget.availableCategories.map((category) {
                          final selected = _selectedCategories.contains(
                            category,
                          );
                          return FilterChip(
                            label: Text(category),
                            selected: selected,
                            onSelected: (_) {
                              setState(() {
                                if (selected) {
                                  _selectedCategories.remove(category);
                                } else {
                                  _selectedCategories.add(category);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                      if (_selectedCategories.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Text(
                          'Pilihanmu: ${_selectedCategories.join(', ')}',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _pageIndex == 0
                                  ? null
                                  : () {
                                      _pageController.previousPage(
                                        duration: const Duration(
                                          milliseconds: 320,
                                        ),
                                        curve: Curves.easeOutCubic,
                                      );
                                    },
                              child: const Text('Sebelumnya'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FilledButton(
                              onPressed: _goNext,
                              child: Text(
                                _isLastPage ? 'Mulai Sekarang' : 'Selanjutnya',
                              ),
                            ),
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
    );
  }
}

class _OnboardingHero extends StatelessWidget {
  const _OnboardingHero({required this.item, required this.isActive});

  final _OnboardingItem item;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: const Duration(milliseconds: 260),
      scale: isActive ? 1 : 0.98,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Color(0xFF0F5EEA),
              Color(0xFF1798FF),
              Color(0xFF2EC5FF),
            ],
          ),
          borderRadius: BorderRadius.circular(32),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  item.accentLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(26),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      NewsImage(
                        imageUrl: item.imageUrl,
                        imageHint: item.imageHint,
                        borderRadius: BorderRadius.circular(26),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: <Color>[
                              Colors.black.withValues(alpha: 0.02),
                              Colors.black.withValues(alpha: 0.60),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Spacer(),
                            Text(
                              item.title,
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    height: 1.15,
                                  ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              item.description,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 15,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
    required this.accentLabel,
  });

  final String title;
  final String description;
  final String imageUrl;
  final String imageHint;
  final String accentLabel;
}
