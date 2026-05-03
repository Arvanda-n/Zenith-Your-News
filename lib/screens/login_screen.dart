import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.onForgotPassword,
    required this.onLogin,
  });

  final VoidCallback onForgotPassword;
  final void Function({
    required String email,
    required String password,
    String? name,
  })
  onLogin;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _hidePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    widget.onLogin(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login berhasil. Selamat datang di ZYN.')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 20),
            const Text(
              'Welcome to ZYN',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              'Login untuk sinkronisasi bookmark dan personalisasi berita.',
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nama'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) {
                final email = value?.trim() ?? '';
                if (email.isEmpty) {
                  return 'Email wajib diisi';
                }
                if (!email.contains('@') || !email.contains('.')) {
                  return 'Format email belum valid';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _passwordController,
              obscureText: _hidePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    _hidePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () => setState(() => _hidePassword = !_hidePassword),
                ),
              ),
              validator: (value) {
                if ((value ?? '').length < 6) {
                  return 'Password minimal 6 karakter';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),
            FilledButton(onPressed: _submit, child: const Text('Login')),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () {
                widget.onLogin(
                  name: 'Google User',
                  email: 'google.user@example.com',
                  password: 'google-auth',
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Login Google simulasi berhasil.'),
                  ),
                );
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.g_mobiledata),
              label: const Text('Continue with Google'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: widget.onForgotPassword,
              child: const Text('Forgot Password?'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Skip for now'),
            ),
          ],
        ),
      ),
    );
  }
}
