import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/app_theme.dart';

enum _AuthMode { masuk, daftar }

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.onLogin,
    this.onForgotPassword,
    this.onSkip,
    this.canSkip = true,
    this.showBackButton = true,
  });

  final VoidCallback? onForgotPassword;
  final VoidCallback? onSkip;
  final bool canSkip;
  final bool showBackButton;
  final void Function({
    required String email,
    required String password,
    String? name,
    String? username,
  })
  onLogin;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _hidePassword = true;
  bool _isOpeningExternalAuth = false;
  _AuthMode _mode = _AuthMode.masuk;

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool get _isRegisterMode => _mode == _AuthMode.daftar;

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    widget.onLogin(
      name: _nameController.text.trim(),
      username: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isRegisterMode
              ? 'Daftar berhasil. Selamat datang di ZYN.'
              : 'Masuk berhasil. Selamat datang di ZYN.',
        ),
      ),
    );
    Navigator.of(context).maybePop();
  }

  void _skip() {
    widget.onSkip?.call();
    Navigator.of(context).maybePop();
  }

  Future<void> _handleSocialAuth(_SocialProvider provider) async {
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _isOpeningExternalAuth = true);

    final uri = Uri.parse(provider.url);
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);

    if (!mounted) {
      return;
    }

    setState(() => _isOpeningExternalAuth = false);
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          opened
              ? 'Membuka ${provider.label}. Selesaikan login di layanan resmi.'
              : 'Gagal membuka ${provider.label}. Coba lagi nanti.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              theme.colorScheme.primary.withValues(alpha: 0.14),
              theme.scaffoldBackgroundColor,
              theme.scaffoldBackgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                20,
                12,
                20,
                media.padding.bottom + 36,
              ),
              children: [
                Row(
                  children: [
                    if (widget.showBackButton)
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back_rounded),
                      )
                    else
                      const SizedBox(width: 48),
                    const Spacer(),
                    if (widget.canSkip)
                      TextButton(
                        onPressed: _skip,
                        child: const Text('Lewati dulu'),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _isRegisterMode ? 'Buat akun ZYN' : 'Masuk ke akun ZYN',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _isRegisterMode
                      ? 'Daftar untuk menyimpan berita, preferensi topik, dan pengalaman baca yang lebih personal.'
                      : 'Masuk untuk membuka simpanan, notifikasi, dan kurasi berita yang lebih relevan.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodySmall?.color,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 22),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _ModeToggleChip(
                          label: 'Masuk',
                          selected: _mode == _AuthMode.masuk,
                          onTap: () => setState(() => _mode = _AuthMode.masuk),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _ModeToggleChip(
                          label: 'Daftar',
                          selected: _mode == _AuthMode.daftar,
                          onTap: () => setState(() => _mode = _AuthMode.daftar),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isRegisterMode
                              ? 'Daftar dengan email'
                              : 'Masuk dengan email',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _isRegisterMode
                              ? 'Isi data inti agar akunmu siap dipakai di semua sesi.'
                              : 'Gunakan akun yang sudah pernah kamu pakai sebelumnya.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.textTheme.bodySmall?.color,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 18),
                        if (_isRegisterMode) ...[
                          TextFormField(
                            controller: _nameController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: 'Nama lengkap',
                            ),
                            validator: (value) {
                              if (value?.trim().isEmpty ?? true) {
                                return 'Nama lengkap wajib diisi';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _usernameController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: 'Username',
                            ),
                            validator: (value) {
                              final username = value?.trim() ?? '';
                              if (username.isEmpty) {
                                return 'Username wajib diisi';
                              }
                              if (username.length < 4) {
                                return 'Username minimal 4 karakter';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                        ],
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
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
                            labelText: 'Kata sandi',
                            suffixIcon: IconButton(
                              icon: Icon(
                                _hidePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () => setState(
                                () => _hidePassword = !_hidePassword,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if ((value ?? '').length < 6) {
                              return 'Kata sandi minimal 6 karakter';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),
                        FilledButton(
                          onPressed: _submit,
                          child: Text(_isRegisterMode ? 'Daftar' : 'Masuk'),
                        ),
                        if (widget.onForgotPassword != null && !_isRegisterMode)
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: widget.onForgotPassword,
                              child: const Text('Lupa kata sandi?'),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(child: Divider(color: theme.dividerColor)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'atau lanjutkan dengan',
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                    Expanded(child: Divider(color: theme.dividerColor)),
                  ],
                ),
                const SizedBox(height: 16),
                _SocialAuthButton(
                  label: 'Lanjutkan dengan Google',
                  subtitle: 'Membuka halaman resmi akun Google',
                  badge: const _GoogleBadge(),
                  busy: _isOpeningExternalAuth,
                  onTap: () => _handleSocialAuth(_SocialProvider.google),
                ),
                const SizedBox(height: 12),
                _SocialAuthButton(
                  label: 'Lanjutkan dengan Facebook',
                  subtitle: 'Membuka halaman resmi Facebook',
                  badge: const _FacebookBadge(),
                  busy: _isOpeningExternalAuth,
                  onTap: () => _handleSocialAuth(_SocialProvider.facebook),
                ),
                const SizedBox(height: 18),
                Center(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6,
                    children: [
                      Text(
                        _isRegisterMode
                            ? 'Sudah punya akun?'
                            : 'Belum punya akun?',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.bodySmall?.color,
                        ),
                      ),
                      TextButton(
                        onPressed: () => setState(() {
                          _mode = _isRegisterMode
                              ? _AuthMode.masuk
                              : _AuthMode.daftar;
                        }),
                        child: Text(_isRegisterMode ? 'Masuk' : 'Daftar'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ModeToggleChip extends StatelessWidget {
  const _ModeToggleChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient: selected ? AppTheme.brandGradient : null,
            color: selected ? null : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.18),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : theme.colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialAuthButton extends StatelessWidget {
  const _SocialAuthButton({
    required this.label,
    required this.subtitle,
    required this.badge,
    required this.onTap,
    required this.busy,
  });

  final String label;
  final String subtitle;
  final Widget badge;
  final VoidCallback onTap;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return OutlinedButton(
      onPressed: busy ? null : onTap,
      style: OutlinedButton.styleFrom(
        backgroundColor: theme.colorScheme.surface,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        side: BorderSide(color: theme.dividerColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Row(
        children: [
          badge,
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(height: 1.4),
                ),
              ],
            ),
          ),
          if (busy)
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2.2),
            )
          else
            const Icon(Icons.open_in_new_rounded),
        ],
      ),
    );
  }
}

class _GoogleBadge extends StatelessWidget {
  const _GoogleBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black12),
      ),
      alignment: Alignment.center,
      child: const Text(
        'G',
        style: TextStyle(
          color: Color(0xFF4285F4),
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _FacebookBadge extends StatelessWidget {
  const _FacebookBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(
        color: Color(0xFF1877F2),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: const Text(
        'f',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 20,
        ),
      ),
    );
  }
}

enum _SocialProvider {
  google(
    id: 'google',
    label: 'Google',
    url: 'https://accounts.google.com/signin/v2/identifier',
  ),
  facebook(
    id: 'facebook',
    label: 'Facebook',
    url: 'https://www.facebook.com/login.php',
  );

  const _SocialProvider({
    required this.id,
    required this.label,
    required this.url,
  });

  final String id;
  final String label;
  final String url;
}
