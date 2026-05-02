import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            "Masukkan email akun Anda dan kami akan kirim tautan reset password.",
            style: TextStyle(height: 1.6),
          ),
          const SizedBox(height: 18),
          const TextField(decoration: InputDecoration(labelText: 'Email')),
          const SizedBox(height: 14),
          FilledButton(onPressed: () {}, child: const Text('Send Reset Link')),
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
            child: const Text('Back to Login'),
          ),
        ],
      ),
    );
  }
}
