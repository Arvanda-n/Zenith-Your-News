import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SafeArea(
            bottom: false,
            child: Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_rounded),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Lupa kata sandi',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          const Text(
            "Masukkan email akun Anda dan kami akan kirim tautan reset password.",
            style: TextStyle(height: 1.6),
          ),
          const SizedBox(height: 18),
          const TextField(decoration: InputDecoration(labelText: 'Email')),
          const SizedBox(height: 14),
          FilledButton(onPressed: () {}, child: const Text('Kirim tautan reset')),
          const SizedBox(height: 10),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                'Info: Link reset akan dikirim jika email terdaftar.',
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Kembali ke Masuk'),
          ),
        ],
      ),
    );
  }
}
