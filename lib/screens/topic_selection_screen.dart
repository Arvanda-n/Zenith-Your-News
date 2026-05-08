import 'package:flutter/material.dart';

class TopicSelectionScreen extends StatefulWidget {
  const TopicSelectionScreen({
    super.key,
    required this.availableCategories,
    required this.onComplete,
  });

  final List<String> availableCategories;
  final ValueChanged<Set<String>> onComplete;

  @override
  State<TopicSelectionScreen> createState() => _TopicSelectionScreenState();
}

class _TopicSelectionScreenState extends State<TopicSelectionScreen> {
  final Set<String> _selectedCategories = <String>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pilih Topik')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            Text(
              'Pilih topik favoritmu',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              'Halaman ini dipisah dari onboarding supaya intro tetap fokus, sementara preferensi topik bisa kamu atur dengan lebih tenang.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: widget.availableCategories.map((category) {
                    final selected = _selectedCategories.contains(category);
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
              ),
            ),
            if (_selectedCategories.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Pilihanmu: ${_selectedCategories.join(', ')}',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => widget.onComplete(_selectedCategories),
              child: const Text('Lanjutkan ke Login'),
            ),
          ],
        ),
      ),
    );
  }
}
