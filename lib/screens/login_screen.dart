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

  Future<void> _handleSocialAuth(_SocialProvider provider) async {
    final result = await showModalBottomSheet<_SocialProfileResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CompleteProfileSheet(provider: provider),
    );

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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Masuk dengan ${provider.label} berhasil. Profil kamu sudah dilengkapi.',
        ),
      ),
    );
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.08),
              theme.colorScheme.surface,
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
            children: [
              SafeArea(
                bottom: false,
                child: Row(
                  children: [
                    if (widget.showBackButton)
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back_rounded),
                      )
                    else
                      const SizedBox(width: 12, height: 48),
                    const Spacer(),
                    if (widget.canSkip)
                      TextButton(
                        onPressed: _skip,
                        child: const Text('Lewati dulu'),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  gradient: AppTheme.brandGradient,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.18),
                      blurRadius: 30,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ),
                padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ZynLogo(size: 26, radius: 8),
                          SizedBox(width: 10),
                          Text(
                            'Akun ZYN',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _isRegisterMode ? 'Daftar ke ZYN' : 'Masuk ke ZYN',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isRegisterMode
                          ? 'Buat akun untuk simpanan berita, personalisasi minat, dan sinkronisasi lintas sesi.'
                          : 'Masuk untuk sinkronisasi simpanan, preferensi berita, dan pengalaman membaca yang lebih personal.',
                      style: const TextStyle(
                        color: Colors.white70,
                        height: 1.5,
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
                        'Pilih mode akun',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Masuk lebih dulu untuk sinkronisasi, atau lewati dan lanjut membaca.',
                      ),
                      const SizedBox(height: 16),
                      SegmentedButton<_AuthMode>(
                        expandedInsets: EdgeInsets.zero,
                        segments: const [
                          ButtonSegment<_AuthMode>(
                            value: _AuthMode.masuk,
                            label: Text('Masuk'),
                          ),
                          ButtonSegment<_AuthMode>(
                            value: _AuthMode.daftar,
                            label: Text('Daftar'),
                          ),
                        ],
                        selected: <_AuthMode>{_mode},
                        onSelectionChanged: (value) =>
                            setState(() => _mode = value.first),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      if (_isRegisterMode) ...[
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Nama tampilan',
                          ),
                          validator: (value) {
                            if (_isRegisterMode &&
                                (value?.trim().isEmpty ?? true)) {
                              return 'Nama tampilan wajib diisi';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                          ),
                          validator: (value) {
                            final username = value?.trim() ?? '';
                            if (_isRegisterMode && username.isEmpty) {
                              return 'Username wajib diisi';
                            }
                            if (username.isNotEmpty && username.length < 4) {
                              return 'Username minimal 4 karakter';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                      ] else ...[
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Nama tampilan',
                            hintText: 'Opsional untuk melengkapi profil',
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
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
                          labelText: 'Kata sandi',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _hidePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () =>
                                setState(() => _hidePassword = !_hidePassword),
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
                        child: Text(
                          _isRegisterMode
                              ? 'Daftar dengan Email'
                              : 'Masuk dengan Email',
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
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text('atau lanjutkan dengan'),
                  ),
                  Expanded(child: Divider(color: theme.dividerColor)),
                ],
              ),
              const SizedBox(height: 16),
              _AuthProviderButton(
                provider: _SocialProvider.google,
                onTap: () => _handleSocialAuth(_SocialProvider.google),
              ),
              const SizedBox(height: 10),
              _AuthProviderButton(
                provider: _SocialProvider.email,
                onTap: () => _handleSocialAuth(_SocialProvider.email),
              ),
              const SizedBox(height: 10),
              _AuthProviderButton(
                provider: _SocialProvider.facebook,
                onTap: () => _handleSocialAuth(_SocialProvider.facebook),
              ),
              if (widget.onForgotPassword != null) ...[
                const SizedBox(height: 10),
                TextButton(
                  onPressed: widget.onForgotPassword,
                  child: const Text('Lupa kata sandi?'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _AuthProviderButton extends StatelessWidget {
  const _AuthProviderButton({required this.provider, required this.onTap});

  final _SocialProvider provider;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Row(
        children: [
          Icon(provider.icon),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '${provider.actionLabel} ${provider.label}',
              textAlign: TextAlign.left,
            ),
          ),
          const Icon(Icons.chevron_right_rounded),
        ],
      ),
    );
  }
}

class _CompleteProfileSheet extends StatefulWidget {
  const _CompleteProfileSheet({required this.provider});

  final _SocialProvider provider;

  @override
  State<_CompleteProfileSheet> createState() => _CompleteProfileSheetState();
}

class _CompleteProfileSheetState extends State<_CompleteProfileSheet> {
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  final _usernameController = TextEditingController();

  @override
  void dispose() {
    _displayNameController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final username = _usernameController.text.trim();
    Navigator.of(context).pop(
      _SocialProfileResult(
        displayName: _displayNameController.text.trim(),
        username: username,
        email: '${username.toLowerCase()}@${widget.provider.id}.zyn.app',
      ),
    );
  }

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
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lengkapi profil ${widget.provider.label}',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sebelum lanjut, isi nama tampilan dan username agar akunmu siap dipakai untuk bookmark, preferensi, dan sinkronisasi.',
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: _displayNameController,
                  decoration: const InputDecoration(labelText: 'Nama tampilan'),
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
                  decoration: const InputDecoration(labelText: 'Username'),
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
                const SizedBox(height: 18),
                FilledButton(
                  onPressed: _submit,
                  child: const Text('Simpan dan lanjutkan'),
                ),
              ],
            ),
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
  google(
    id: 'google',
    label: 'Google',
    actionLabel: 'Masuk dengan',
    icon: Icons.g_mobiledata,
  ),
  email(
    id: 'email',
    label: 'Email',
    actionLabel: 'Masuk dengan',
    icon: Icons.alternate_email_rounded,
  ),
  facebook(
    id: 'facebook',
    label: 'Facebook',
    actionLabel: 'Masuk dengan',
    icon: Icons.facebook_rounded,
  );

  const _SocialProvider({
    required this.id,
    required this.label,
    required this.actionLabel,
    required this.icon,
  });

  final String id;
  final String label;
  final String actionLabel;
  final IconData icon;
}
