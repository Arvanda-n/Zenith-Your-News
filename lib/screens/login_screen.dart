import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/zyn_logo.dart';

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

  Future<_SocialProfileResult?> _showGoogleAccountSheet() {
    return showModalBottomSheet<_SocialProfileResult>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const _GoogleAccountSheet(),
    );
  }

  Future<_SocialProfileResult?> _showFacebookSheet() {
    return showModalBottomSheet<_SocialProfileResult>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const _FacebookContinueSheet(),
    );
  }

  Future<void> _handleSocialAuth(_SocialProvider provider) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final result = provider == _SocialProvider.google
        ? await _showGoogleAccountSheet()
        : await _showFacebookSheet();

    if (result == null) {
      return;
    }

    widget.onLogin(
      name: result.displayName,
      username: result.username,
      email: result.email,
      password: '${provider.id}-auth',
    );

    if (!mounted) {
      return;
    }

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          provider == _SocialProvider.google
              ? 'Simulasi pemilihan akun Google berhasil.'
              : 'Simulasi login Facebook berhasil.',
        ),
      ),
    );
    navigator.maybePop();
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
                Container(
                  padding: const EdgeInsets.all(20),
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
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ZynLogo(size: 48, radius: 14, showPlate: true),
                      const SizedBox(height: 18),
                      Text(
                        'Masuk ke ZYN',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Baca berita real-time, simpan artikel penting, dan nikmati pengalaman mobile news yang lebih personal.',
                        style: TextStyle(color: Colors.white70, height: 1.5),
                      ),
                    ],
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
                              ? 'Buat akun untuk sinkronisasi simpanan, preferensi, dan pengalaman baca lintas sesi.'
                              : 'Gunakan akunmu untuk membuka simpanan, notifikasi, dan kurasi berita yang lebih relevan.',
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
                              labelText: 'Nama tampilan',
                            ),
                            validator: (value) {
                              if (value?.trim().isEmpty ?? true) {
                                return 'Nama tampilan wajib diisi';
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
                  label: 'Masuk dengan Google',
                  subtitle: 'Simulasi pemilihan akun Google',
                  badge: const _GoogleBadge(),
                  onTap: () => _handleSocialAuth(_SocialProvider.google),
                ),
                const SizedBox(height: 12),
                _SocialAuthButton(
                  label: 'Masuk dengan Facebook',
                  subtitle: 'Simulasi membuka halaman Facebook',
                  badge: const _FacebookBadge(),
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
  });

  final String label;
  final String subtitle;
  final Widget badge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return OutlinedButton(
      onPressed: onTap,
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
          const Icon(Icons.chevron_right_rounded),
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
      child: RichText(
        text: const TextSpan(
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          children: [
            TextSpan(
              text: 'G',
              style: TextStyle(color: Color(0xFF4285F4)),
            ),
            TextSpan(
              text: '',
              style: TextStyle(color: Color(0xFFEA4335)),
            ),
          ],
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

class _GoogleAccountSheet extends StatelessWidget {
  const _GoogleAccountSheet();

  @override
  Widget build(BuildContext context) {
    final accounts = <_SocialProfileResult>[
      const _SocialProfileResult(
        displayName: 'Nadia Putri',
        username: 'nadiaputri',
        email: 'nadia.putri@gmail.com',
      ),
      const _SocialProfileResult(
        displayName: 'Raka Fajar',
        username: 'rakafajar',
        email: 'raka.fajar@gmail.com',
      ),
    ];

    return _SocialSheetContainer(
      title: 'Pilih akun Google',
      subtitle:
          'Simulasi ini meniru pemilihan akun Google seperti di aplikasi asli.',
      child: Column(
        children: accounts
            .map(
              (account) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const _GoogleBadge(),
                title: Text(account.displayName),
                subtitle: Text(account.email),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => Navigator.of(context).pop(account),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _FacebookContinueSheet extends StatelessWidget {
  const _FacebookContinueSheet();

  @override
  Widget build(BuildContext context) {
    const profile = _SocialProfileResult(
      displayName: 'Alya Zhafira',
      username: 'alyazhafira',
      email: 'alya.zhafira@facebook.zyn.app',
    );

    return _SocialSheetContainer(
      title: 'Facebook',
      subtitle:
          'Simulasi ini meniru membuka aplikasi atau halaman Facebook untuk melanjutkan login.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Row(
              children: [
                _FacebookBadge(),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Lanjutkan sebagai Alya Zhafira',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(profile),
            child: const Text('Lanjutkan dengan Facebook'),
          ),
        ],
      ),
    );
  }
}

class _SocialSheetContainer extends StatelessWidget {
  const _SocialSheetContainer({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(28),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(subtitle),
              const SizedBox(height: 18),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialProfileResult {
  const _SocialProfileResult({
    required this.displayName,
    required this.username,
    required this.email,
  });

  final String displayName;
  final String username;
  final String email;
}

enum _SocialProvider {
  google(id: 'google', label: 'Google'),
  facebook(id: 'facebook', label: 'Facebook');

  const _SocialProvider({required this.id, required this.label});

  final String id;
  final String label;
}
