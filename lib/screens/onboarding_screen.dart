import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

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

  static const _items = <_OnboardingItem>[
    _OnboardingItem(
      title: 'Baca berita dengan lebih fokus',
      description:
          'ZYN merangkum berita penting dengan tampilan yang bersih, visual, dan nyaman dibaca kapan saja.',
      icon: Icons.chrome_reader_mode_rounded,
    ),
    _OnboardingItem(
      title: 'Temukan topik yang benar-benar kamu suka',
      description:
          'Dari Teknologi sampai Kesehatan, kamu bisa mulai dari minat yang paling relevan untuk ritme harianmu.',
      icon: Icons.interests_rounded,
    ),
    _OnboardingItem(
      title: 'Dapatkan pengalaman yang lebih personal',
      description:
          'Pilih minat awalmu agar ZYN menampilkan sorotan dan kurasi yang terasa lebih pas sejak pertama dibuka.',
      icon: Icons.auto_awesome_rounded,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canContinue = _selectedCategories.isNotEmpty;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: AppTheme.brandGradient,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'Mulai dengan ZYN',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => widget.onComplete(_selectedCategories),
                  child: const Text('Lewati'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 300,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (value) => setState(() => _pageIndex = value),
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return _OnboardingHero(item: item);
                },
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_items.length, (index) {
                final active = index == _pageIndex;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: active ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: active ? AppTheme.brandGradient : null,
                    color: active ? null : AppTheme.primary.withValues(alpha: 0.18),
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Pilih minat berita kamu',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Pilih satu atau beberapa topik agar Beranda terasa lebih personal sejak awal.',
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: widget.availableCategories.map((category) {
                        final selected = _selectedCategories.contains(category);
                        return FilterChip(
                          label: Text(category),
                          selected: selected,
                          onSelected: (_) => setState(() {
                            if (selected) {
                              _selectedCategories.remove(category);
                            } else {
                              _selectedCategories.add(category);
                            }
                          }),
                        );
                      }).toList(),
                    ),
                    if (_selectedCategories.isNotEmpty) ...[
                      const SizedBox(height: 18),
                      Text(
                        'Dipilih: ${_selectedCategories.join(', ')}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    const SizedBox(height: 18),
                    FilledButton(
                      onPressed: canContinue
                          ? () => widget.onComplete(_selectedCategories)
                          : null,
                      child: const Text('Lanjutkan ke Beranda'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingHero extends StatelessWidget {
  const _OnboardingHero({required this.item});

  final _OnboardingItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1D4ED8),
            Color(0xFF4F46E5),
            Color(0xFF7C3AED),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(item.icon, color: Colors.white, size: 30),
            ),
            const Spacer(),
            Text(
              item.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
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
    );
  }
}

class _OnboardingItem {
  const _OnboardingItem({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;
}
