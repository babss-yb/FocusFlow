import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_providers.dart';

/// Profil utilisateur - Livrable 4.
/// Permet de modifier les infos personnelles et inclut un programme de parrainage.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  
  String? _avatarPath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    _firstNameController = TextEditingController(text: user?.firstName ?? '');
    _lastNameController = TextEditingController(text: user?.lastName ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _avatarPath = user?.avatarUrl;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authProvider = context.watch<AuthProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final user = authProvider.user;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacingLg),
          child: Column(
            children: [
              // En-tête profil
              _buildProfileHeader(isDark, user),
              const SizedBox(height: AppTheme.spacingLg),

              // Carte de parrainage
              _buildReferralCard(isDark, user),
              const SizedBox(height: AppTheme.spacingLg),

              // Informations personnelles
              _buildInfoSection(isDark),
              const SizedBox(height: AppTheme.spacingLg),

              // Paramètres
              _buildSettingsSection(isDark, themeProvider),
              const SizedBox(height: AppTheme.spacingLg),

              // Actions
              _buildActionsSection(isDark, authProvider),
              const SizedBox(height: AppTheme.spacingXl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(bool isDark, dynamic user) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Mon Profil',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              icon: const Icon(Icons.settings_outlined),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingMd),
        // Avatar
        GestureDetector(
          onTap: () async {
            final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
            if (image != null) {
              setState(() {
                _avatarPath = image.path;
              });
              if (user != null) {
                final updatedUser = user.copyWith(avatarUrl: image.path);
                context.read<AuthProvider>().updateProfile(updatedUser);
              }
            }
          },
          child: Stack(
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  shape: BoxShape.circle,
                  image: _avatarPath != null 
                      ? DecorationImage(image: NetworkImage(_avatarPath!), fit: BoxFit.cover) 
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: _avatarPath == null ? Center(
                  child: Text(
                    user?.initials ?? 'FP',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ) : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 14),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppTheme.spacingMd),
        Text(
          user?.fullName ?? 'Entrepreneur',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 2),
        Text(
          user?.companyName ?? 'Mon Entreprise',
          style: TextStyle(
            color: isDark
                ? AppTheme.textSecondaryDark
                : AppTheme.textSecondaryLight,
          ),
        ),
        const SizedBox(height: AppTheme.spacingSm),
        if (user?.isVerified == true)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.accentGreen.withOpacity(0.12),
              borderRadius: BorderRadius.circular(AppTheme.radiusRound),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified, color: AppTheme.accentGreen, size: 16),
                SizedBox(width: 4),
                Text(
                  'Compte vérifié',
                  style: TextStyle(
                    color: AppTheme.accentGreen,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildReferralCard(bool isDark, dynamic user) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        gradient: AppTheme.goldGradient,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppTheme.secondaryColor.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.card_giftcard, color: Colors.black87, size: 24),
              SizedBox(width: 8),
              Text(
                'Programme de parrainage PME',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingSm),
          const Text(
            'Parrainez un entrepreneur et recevez 25 000 FCFA de bonus sur votre compte !',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: AppTheme.spacingMd),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  user?.referralCode ?? 'FINFLOW-2025',
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 1.2,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Code copié dans le presse-papier !'),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                        ),
                      ),
                    );
                  },
                  child: const Icon(Icons.copy, color: Colors.black54, size: 20),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Row(
            children: [
              const Icon(Icons.people, color: Colors.black54, size: 16),
              const SizedBox(width: 4),
              Text(
                '3 filleuls • 75 000 FCFA gagnés',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.6),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : AppTheme.cardLight,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(
          color: isDark ? AppTheme.dividerDark : AppTheme.dividerLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Informations personnelles',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isDark
                      ? AppTheme.textPrimaryDark
                      : AppTheme.textPrimaryLight,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  if (_isEditing) {
                    // Sauvegarder les modifications
                    final auth = context.read<AuthProvider>();
                    if (auth.user != null) {
                      final updated = auth.user!.copyWith(
                        firstName: _firstNameController.text,
                        lastName: _lastNameController.text,
                        phone: _phoneController.text,
                        email: _emailController.text,
                      );
                      auth.updateProfile(updated);
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Profil mis à jour avec succès !'),
                          backgroundColor: AppTheme.accentGreen,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                          ),
                        ),
                      );
                    }
                  }
                  setState(() => _isEditing = !_isEditing);
                },
                icon: Icon(
                  _isEditing ? Icons.check : Icons.edit,
                  size: 16,
                ),
                label: Text(
                  _isEditing ? 'Sauvegarder' : 'Modifier',
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingMd),

          if (_isEditing) ...[
            TextFormField(
              controller: _firstNameController,
              decoration: const InputDecoration(
                labelText: 'Prénom',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: AppTheme.spacingMd),
            TextFormField(
              controller: _lastNameController,
              decoration: const InputDecoration(
                labelText: 'Nom',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: AppTheme.spacingMd),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Téléphone',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
            ),
            const SizedBox(height: AppTheme.spacingMd),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
          ] else ...[
            _buildInfoRow(Icons.person_outline, 'Prénom',
                _firstNameController.text, isDark),
            _buildInfoRow(Icons.person_outline, 'Nom',
                _lastNameController.text, isDark),
            _buildInfoRow(Icons.phone_outlined, 'Téléphone',
                _phoneController.text, isDark),
            _buildInfoRow(Icons.email_outlined, 'Email',
                _emailController.text, isDark),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(
      IconData icon, String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
      child: Row(
        children: [
          Icon(icon,
              size: 20,
              color: isDark
                  ? AppTheme.textSecondaryDark
                  : AppTheme.textSecondaryLight),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark
                      ? AppTheme.textSecondaryDark
                      : AppTheme.textSecondaryLight,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? AppTheme.textPrimaryDark
                      : AppTheme.textPrimaryLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(bool isDark, ThemeProvider themeProvider) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : AppTheme.cardLight,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(
          color: isDark ? AppTheme.dividerDark : AppTheme.dividerLight,
        ),
      ),
      child: Column(
        children: [
          _buildSettingsTile(
            icon: Icons.dark_mode,
            title: 'Mode sombre',
            isDark: isDark,
            trailing: Switch(
              value: themeProvider.isDarkMode,
              onChanged: (_) => themeProvider.toggleTheme(),
              activeColor: AppTheme.primaryColor,
            ),
          ),
          Divider(
            height: 1,
            color: isDark ? AppTheme.dividerDark : AppTheme.dividerLight,
          ),
          _buildSettingsTile(
            icon: Icons.notifications,
            title: 'Notifications',
            isDark: isDark,
            trailing: Switch(
              value: true,
              onChanged: (_) {},
              activeColor: AppTheme.primaryColor,
            ),
          ),
          Divider(
            height: 1,
            color: isDark ? AppTheme.dividerDark : AppTheme.dividerLight,
          ),
          _buildSettingsTile(
            icon: Icons.language,
            title: 'Langue',
            isDark: isDark,
            trailing: Text(
              'Français',
              style: TextStyle(
                color: isDark
                    ? AppTheme.textSecondaryDark
                    : AppTheme.textSecondaryLight,
                fontSize: 14,
              ),
            ),
          ),
          Divider(
            height: 1,
            color: isDark ? AppTheme.dividerDark : AppTheme.dividerLight,
          ),
          _buildSettingsTile(
            icon: Icons.security,
            title: 'Sécurité',
            isDark: isDark,
            trailing: const Icon(Icons.chevron_right, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required bool isDark,
    required Widget trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingMd, vertical: 4),
      child: Row(
        children: [
          Icon(icon,
              size: 22,
              color: isDark
                  ? AppTheme.textSecondaryDark
                  : AppTheme.textSecondaryLight),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                color: isDark
                    ? AppTheme.textPrimaryDark
                    : AppTheme.textPrimaryLight,
              ),
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  Widget _buildActionsSection(bool isDark, AuthProvider authProvider) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.help_outline),
            label: const Text('Centre d\'aide'),
          ),
        ),
        const SizedBox(height: AppTheme.spacingSm),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.description_outlined),
            label: const Text('Conditions d\'utilisation'),
          ),
        ),
        const SizedBox(height: AppTheme.spacingMd),
        SizedBox(
          width: double.infinity,
          child: TextButton.icon(
            onPressed: () async {
              await authProvider.logout();
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
            icon:
                const Icon(Icons.logout, color: AppTheme.accentRed, size: 20),
            label: const Text(
              'Se déconnecter',
              style: TextStyle(color: AppTheme.accentRed),
            ),
          ),
        ),
        const SizedBox(height: AppTheme.spacingSm),
        Text(
          'FinFlow v1.0.0',
          style: TextStyle(
            fontSize: 12,
            color: isDark
                ? AppTheme.textSecondaryDark
                : AppTheme.textSecondaryLight,
          ),
        ),
      ],
    );
  }
}
