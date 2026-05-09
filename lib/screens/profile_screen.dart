import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../state/app_controller.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    required this.controller,
    required this.onOpenLogin,
    required this.onOpenNotifications,
  });

  final AppController controller;
  final VoidCallback onOpenLogin;
  final VoidCallback onOpenNotifications;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final isDark = controller.themeMode == ThemeMode.dark;
        final isLoggedIn = controller.isLoggedIn;

        return Scaffold(
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 112),
            children: [
              const SafeArea(bottom: false, child: SizedBox.shrink()),
              Container(
                decoration: BoxDecoration(
                  gradient: AppTheme.brandGradient,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withValues(alpha: 0.18),
                      blurRadius: 24,
                      offset: const Offset(0, 14),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ProfileAvatar(
                          isLoggedIn: isLoggedIn,
                          photoPath: controller.userPhotoPath,
                          photoScale: controller.userPhotoScale,
                          name: controller.userName,
                          onEditPhoto: isLoggedIn
                              ? () => _showPhotoOptions(context)
                              : onOpenLogin,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isLoggedIn
                                    ? controller.userName ?? 'Pembaca ZYN'
                                    : 'Belum masuk',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                isLoggedIn
                                    ? '@${controller.userHandle ?? 'pembacazyn'}\n${controller.userEmail ?? ''}'
                                    : 'Masuk / Daftar untuk personalisasi, simpanan, dan sinkronisasi preferensi.',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  height: 1.45,
                                ),
                              ),
                              if (isLoggedIn &&
                                  controller.userBio != null &&
                                  controller.userBio!.isNotEmpty) ...[
                                const SizedBox(height: 10),
                                Text(
                                  controller.userBio!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (isLoggedIn) ...[
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _showEditProfileSheet(context),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: BorderSide(
                                  color: Colors.white.withValues(alpha: 0.35),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                              icon: const Icon(Icons.edit_rounded),
                              label: const Text('Edit profil'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: () => _pickProfilePhoto(context),
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppTheme.primary,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                              icon: const Icon(Icons.add_a_photo_rounded),
                              label: Text(
                                controller.userPhotoPath == null
                                    ? 'Tambah foto'
                                    : 'Kelola foto',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 18),
              _ProfileGroup(
                title: 'Preferensi',
                children: [
                  SwitchListTile(
                    value: isDark,
                    onChanged: controller.toggleTheme,
                    title: const Text('Mode gelap'),
                    subtitle: const Text(
                      'Tampilan yang lebih fokus untuk malam hari',
                    ),
                  ),
                  SwitchListTile(
                    value: controller.notificationsEnabled,
                    onChanged: controller.toggleNotifications,
                    title: const Text('Notifikasi'),
                    subtitle: const Text(
                      'Aktifkan update breaking news dan ringkasan harian',
                    ),
                  ),
                  ListTile(
                    title: const Text('Status sesi'),
                    subtitle: Text(
                      isLoggedIn
                          ? 'Akun, simpanan, preferensi, dan edit profil akan dipulihkan saat aplikasi dibuka lagi.'
                          : 'Onboarding dan minat tetap disimpan secara lokal di perangkat ini.',
                    ),
                    leading: const Icon(Icons.verified_user_outlined),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _ProfileGroup(
                title: 'Pengalaman Membaca',
                children: [
                  ListTile(
                    title: const Text('Pusat Notifikasi'),
                    subtitle: Text(
                      controller.unreadNotificationCount == 0
                          ? 'Tidak ada notifikasi baru'
                          : '${controller.unreadNotificationCount} notifikasi belum dibaca',
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: onOpenNotifications,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ukuran font',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: FontScaleOption.values.map((option) {
                            return ChoiceChip(
                              label: Text(option.label),
                              selected: option == controller.fontScale,
                              onSelected: (_) =>
                                  controller.setFontScale(option),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (controller.preferredCategories.isNotEmpty) ...[
                const SizedBox(height: 14),
                _ProfileGroup(
                  title: 'Minat Anda',
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: controller.preferredCategories.map((
                          category,
                        ) {
                          return Chip(
                            label: Text(category),
                            avatar: const Icon(
                              Icons.interests_rounded,
                              size: 18,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 14),
              _ProfileGroup(
                title: 'Tentang',
                children: [
                  ListTile(
                    title: const Text('Tentang ZYN'),
                    subtitle: const Text('Zenith Your News'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationName: 'ZYN',
                        applicationVersion: 'MVP 1.0',
                        children: const [
                          Text(
                            'Aplikasi berita modern dengan fokus kenyamanan baca, personalisasi, dan visual premium.',
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 18),
              SafeArea(
                top: false,
                child: FilledButton(
                  onPressed: () async {
                    if (isLoggedIn) {
                      final confirmed = await _showLogoutConfirmation(context);
                      if (confirmed != true || !context.mounted) {
                        return;
                      }
                      controller.logout();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Berhasil keluar.')),
                      );
                      return;
                    }
                    onOpenLogin();
                  },
                  child: Text(isLoggedIn ? 'Keluar' : 'Masuk / Daftar'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickProfilePhoto(BuildContext context) async {
    await _pickProfilePhotoFromSource(context, ImageSource.gallery);
  }

  Future<void> _pickProfilePhotoFromSource(
    BuildContext context,
    ImageSource source,
  ) async {
    try {
      final picker = ImagePicker();
      final file = await picker.pickImage(
        source: source,
        imageQuality: 88,
        maxWidth: 1800,
      );

      if (file == null) {
        return;
      }

      controller.updateProfilePhotoPath(file.path);
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            source == ImageSource.camera
                ? 'Foto profil dari kamera berhasil diperbarui.'
                : 'Foto profil berhasil diperbarui.',
          ),
        ),
      );
    } catch (_) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pemilihan foto belum berhasil. Coba lagi ya.'),
        ),
      );
    }
  }

  Future<void> _showPhotoOptions(BuildContext context) async {
    final parentContext = context;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_camera_rounded),
                  title: const Text('Ambil dengan kamera'),
                  onTap: () async {
                    Navigator.of(context).pop();
                    await _pickProfilePhotoFromSource(
                      parentContext,
                      ImageSource.camera,
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library_rounded),
                  title: const Text('Pilih dari galeri'),
                  onTap: () async {
                    Navigator.of(context).pop();
                    await _pickProfilePhoto(parentContext);
                  },
                ),
                if (controller.userPhotoPath != null) ...[
                  ListTile(
                    leading: const Icon(Icons.zoom_in_map_rounded),
                    title: const Text('Atur ukuran foto'),
                    subtitle: const Text(
                      'Sesuaikan zoom agar foto profil tampil lebih pas.',
                    ),
                    onTap: () async {
                      Navigator.of(context).pop();
                      await _showPhotoAdjustSheet(parentContext);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete_outline_rounded),
                    title: const Text('Hapus foto profil'),
                    onTap: () async {
                      Navigator.of(context).pop();
                      await _confirmRemovePhoto(parentContext);
                    },
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showEditProfileSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return _EditProfileSheet(controller: controller);
      },
    );
  }

  Future<void> _showPhotoAdjustSheet(BuildContext context) async {
    final parentContext = context;
    var draftScale = controller.userPhotoScale;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Atur ukuran foto profil',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Geser untuk memperbesar atau mengembalikan framing foto profil.',
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: _ProfileAvatarPreview(
                        photoPath: controller.userPhotoPath,
                        photoScale: draftScale,
                        name: controller.userName,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Zoom ${(draftScale * 100).round()}%',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Slider(
                      value: draftScale,
                      min: 1.0,
                      max: 1.8,
                      divisions: 8,
                      label: '${(draftScale * 100).round()}%',
                      onChanged: (value) =>
                          setModalState(() => draftScale = value),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () =>
                                setModalState(() => draftScale = 1.0),
                            child: const Text('Reset'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton(
                            onPressed: () {
                              controller.updateProfilePhotoScale(draftScale);
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(parentContext).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Ukuran foto profil berhasil diperbarui.',
                                  ),
                                ),
                              );
                            },
                            child: const Text('Simpan'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _confirmRemovePhoto(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus foto profil?'),
          content: const Text(
            'Foto profil akan dihapus dari tampilan profil dan ukuran fotonya direset.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    controller.updateProfilePhotoPath(null);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Foto profil berhasil dihapus.')),
    );
  }

  Future<bool?> _showLogoutConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Keluar dari akun?'),
          content: const Text(
            'Anda akan keluar dari sesi saat ini. Bookmark akun dan data profil lokal akan dibersihkan.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Keluar'),
            ),
          ],
        );
      },
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({
    required this.isLoggedIn,
    required this.photoPath,
    required this.photoScale,
    required this.name,
    required this.onEditPhoto,
  });

  final bool isLoggedIn;
  final String? photoPath;
  final double photoScale;
  final String? name;
  final VoidCallback onEditPhoto;

  @override
  Widget build(BuildContext context) {
    final hasPhoto = photoPath != null && photoPath!.isNotEmpty;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 84,
          height: 84,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: hasPhoto
                ? Transform.scale(
                    scale: photoScale,
                    child: Image.file(
                      File(photoPath!),
                      fit: BoxFit.cover,
                      width: 84,
                      height: 84,
                      errorBuilder: (_, _, _) => _AvatarFallback(name: name),
                    ),
                  )
                : _AvatarFallback(
                    name: isLoggedIn ? name : null,
                    icon: isLoggedIn ? Icons.person : Icons.person_outline,
                  ),
          ),
        ),
        Positioned(
          right: -4,
          bottom: -4,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onEditPhoto,
              borderRadius: BorderRadius.circular(18),
              child: Ink(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.10),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  size: 18,
                  color: AppTheme.primary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileAvatarPreview extends StatelessWidget {
  const _ProfileAvatarPreview({
    required this.photoPath,
    required this.photoScale,
    required this.name,
  });

  final String? photoPath;
  final double photoScale;
  final String? name;

  @override
  Widget build(BuildContext context) {
    final hasPhoto = photoPath != null && photoPath!.isNotEmpty;

    return Container(
      width: 124,
      height: 124,
      decoration: BoxDecoration(
        gradient: AppTheme.brandGradient,
        borderRadius: BorderRadius.circular(36),
      ),
      padding: const EdgeInsets.all(10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: hasPhoto
            ? Transform.scale(
                scale: photoScale,
                child: Image.file(
                  File(photoPath!),
                  fit: BoxFit.cover,
                  width: 104,
                  height: 104,
                  errorBuilder: (_, _, _) => _AvatarFallback(name: name),
                ),
              )
            : _AvatarFallback(name: name),
      ),
    );
  }
}

class _AvatarFallback extends StatelessWidget {
  const _AvatarFallback({this.name, this.icon = Icons.person});

  final String? name;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final initial = name?.trim().isNotEmpty == true
        ? name!.trim().substring(0, 1).toUpperCase()
        : null;

    return Container(
      color: Colors.white.withValues(alpha: 0.06),
      alignment: Alignment.center,
      child: initial == null
          ? Icon(icon, color: Colors.white, size: 34)
          : Text(
              initial,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
    );
  }
}

class _EditProfileSheet extends StatefulWidget {
  const _EditProfileSheet({required this.controller});

  final AppController controller;

  @override
  State<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<_EditProfileSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _handleController;
  late final TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.controller.userName ?? '',
    );
    _handleController = TextEditingController(
      text: widget.controller.userHandle ?? '',
    );
    _bioController = TextEditingController(
      text: widget.controller.userBio ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _handleController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 8, 20, bottomInset + 20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit profil',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Perbarui nama, username, dan bio singkat agar profilmu lebih personal.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Nama lengkap',
                  prefixIcon: Icon(Icons.badge_rounded),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama lengkap wajib diisi.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _handleController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.alternate_email_rounded),
                  helperText:
                      'Hanya huruf kecil, angka, titik, garis bawah, atau strip.',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Username wajib diisi.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _bioController,
                maxLines: 3,
                maxLength: 160,
                decoration: const InputDecoration(
                  labelText: 'Bio singkat',
                  alignLabelWithHint: true,
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 52),
                    child: Icon(Icons.edit_note_rounded),
                  ),
                  helperText:
                      'Ceritakan sedikit minat atau fokus berita favoritmu.',
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _save,
                  child: const Text('Simpan perubahan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    widget.controller.updateProfile(
      fullName: _nameController.text,
      handle: _handleController.text,
      bio: _bioController.text,
    );
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil berhasil diperbarui.')),
    );
  }
}

class _ProfileGroup extends StatelessWidget {
  const _ProfileGroup({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 8),
              child: Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            ...children,
          ],
        ),
      ),
    );
  }
}
