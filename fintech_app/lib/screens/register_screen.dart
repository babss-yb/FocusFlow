import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_providers.dart';

/// Écran d'inscription KYC mobile-first - Livrable 3.
/// Formulaire multi-étapes avec upload de documents simulé.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _companyNameController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  // Document upload simulation
  bool _kbisUploaded = false;
  bool _idUploaded = false;
  double _uploadProgress = 0.0;
  bool _isUploading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _companyNameController.dispose();
    super.dispose();
  }

  Future<void> _simulateUpload(String docType) async {
    setState(() {
      _isUploading = true;
      _uploadProgress = 0;
    });

    for (int i = 0; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 200));
      if (mounted) {
        setState(() => _uploadProgress = i / 10);
      }
    }

    if (mounted) {
      setState(() {
        _isUploading = false;
        if (docType == 'kbis') {
          _kbisUploaded = true;
        } else {
          _idUploaded = true;
        }
      });
    }
  }

  Future<void> _handleRegister() async {
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.register(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passwordController.text,
      companyName: _companyNameController.text.trim(),
    );

    if (mounted) {
      if (success) {
        Navigator.pushReplacementNamed(context, '/activation');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.error ?? 'Erreur lors de l\'inscription'),
            backgroundColor: AppTheme.accentRed,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer un compte'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Indicateur de progression
            _buildProgressIndicator(isDark),
            const SizedBox(height: AppTheme.spacingLg),

            // Titre de l'étape
            Text(
              _stepTitles[_currentStep],
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              _stepSubtitles[_currentStep],
              style: TextStyle(
                color: isDark
                    ? AppTheme.textSecondaryDark
                    : AppTheme.textSecondaryLight,
              ),
            ),
            const SizedBox(height: AppTheme.spacingLg),

            // Contenu de l'étape
            Form(
              key: _formKey,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _buildCurrentStep(isDark),
              ),
            ),

            const SizedBox(height: AppTheme.spacingXl),

            // Boutons
            Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() => _currentStep--);
                      },
                      child: const Text('Précédent'),
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: AppTheme.spacingMd),
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 54,
                    child: ElevatedButton(
                      onPressed: authProvider.isLoading
                          ? null
                          : () {
                              if (_currentStep < 2) {
                                setState(() => _currentStep++);
                              } else {
                                _handleRegister();
                              }
                            },
                      child: authProvider.isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              _currentStep < 2
                                  ? 'Continuer'
                                  : 'Finaliser l\'inscription',
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  final _stepTitles = [
    'Informations personnelles',
    'Votre entreprise',
    'Documents justificatifs',
  ];

  final _stepSubtitles = [
    'Renseignez vos coordonnées pour commencer.',
    'Parlez-nous de votre activité.',
    'Déposez vos documents pour la vérification KYC.',
  ];

  Widget _buildProgressIndicator(bool isDark) {
    return Row(
      children: List.generate(3, (index) {
        final isActive = index <= _currentStep;
        final isCompleted = index < _currentStep;
        return Expanded(
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive
                      ? AppTheme.primaryColor
                      : (isDark ? AppTheme.cardDark : AppTheme.scaffoldLight),
                  border: Border.all(
                    color: isActive
                        ? AppTheme.primaryColor
                        : (isDark
                            ? AppTheme.dividerDark
                            : AppTheme.dividerLight),
                  ),
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: isActive
                                ? Colors.white
                                : (isDark
                                    ? AppTheme.textSecondaryDark
                                    : AppTheme.textSecondaryLight),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                ),
              ),
              if (index < 2)
                Expanded(
                  child: Container(
                    height: 2,
                    color: index < _currentStep
                        ? AppTheme.primaryColor
                        : (isDark
                            ? AppTheme.dividerDark
                            : AppTheme.dividerLight),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCurrentStep(bool isDark) {
    switch (_currentStep) {
      case 0:
        return _buildPersonalInfoStep(isDark);
      case 1:
        return _buildCompanyStep(isDark);
      case 2:
        return _buildDocumentsStep(isDark);
      default:
        return const SizedBox.shrink();
    }
  }

  // ─── Étape 1 : Infos personnelles ────────────────────────────────
  Widget _buildPersonalInfoStep(bool isDark) {
    return Column(
      key: const ValueKey('step0'),
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'Prénom',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
            ),
            const SizedBox(width: AppTheme.spacingMd),
            Expanded(
              child: TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Nom',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingMd),
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Téléphone',
            hintText: '+221 7X XXX XX XX',
            prefixIcon: Icon(Icons.phone_outlined),
          ),
        ),
        const SizedBox(height: AppTheme.spacingMd),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Email professionnel',
            prefixIcon: Icon(Icons.email_outlined),
          ),
        ),
        const SizedBox(height: AppTheme.spacingMd),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            labelText: 'Mot de passe',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(_obscurePassword
                  ? Icons.visibility_off
                  : Icons.visibility),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
        ),
        const SizedBox(height: AppTheme.spacingMd),
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: _obscureConfirm,
          decoration: InputDecoration(
            labelText: 'Confirmer le mot de passe',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(_obscureConfirm
                  ? Icons.visibility_off
                  : Icons.visibility),
              onPressed: () =>
                  setState(() => _obscureConfirm = !_obscureConfirm),
            ),
          ),
        ),
      ],
    );
  }

  // ─── Étape 2 : Entreprise ─────────────────────────────────────────
  Widget _buildCompanyStep(bool isDark) {
    return Column(
      key: const ValueKey('step1'),
      children: [
        TextFormField(
          controller: _companyNameController,
          decoration: const InputDecoration(
            labelText: 'Nom de l\'entreprise',
            prefixIcon: Icon(Icons.business),
          ),
        ),
        const SizedBox(height: AppTheme.spacingMd),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Type d\'entreprise',
            prefixIcon: Icon(Icons.category),
          ),
          items: const [
            DropdownMenuItem(value: 'SARL', child: Text('SARL')),
            DropdownMenuItem(value: 'SA', child: Text('SA')),
            DropdownMenuItem(value: 'SAS', child: Text('SAS')),
            DropdownMenuItem(value: 'EI', child: Text('Entreprise Individuelle')),
            DropdownMenuItem(value: 'GIE', child: Text('GIE')),
            DropdownMenuItem(value: 'Auto', child: Text('Auto-entrepreneur')),
          ],
          onChanged: (value) {},
        ),
        const SizedBox(height: AppTheme.spacingMd),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Secteur d\'activité',
            prefixIcon: Icon(Icons.work_outline),
          ),
          items: const [
            DropdownMenuItem(value: 'commerce', child: Text('Commerce général')),
            DropdownMenuItem(value: 'services', child: Text('Services')),
            DropdownMenuItem(value: 'tech', child: Text('Technologie')),
            DropdownMenuItem(value: 'agri', child: Text('Agriculture')),
            DropdownMenuItem(value: 'transport', child: Text('Transport & Logistique')),
            DropdownMenuItem(value: 'btp', child: Text('BTP')),
            DropdownMenuItem(value: 'autre', child: Text('Autre')),
          ],
          onChanged: (value) {},
        ),
        const SizedBox(height: AppTheme.spacingMd),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Pays',
            prefixIcon: Icon(Icons.flag_outlined),
          ),
          value: 'SN',
          items: const [
            DropdownMenuItem(value: 'SN', child: Text('🇸🇳 Sénégal')),
            DropdownMenuItem(value: 'CI', child: Text('🇨🇮 Côte d\'Ivoire')),
            DropdownMenuItem(value: 'ML', child: Text('🇲🇱 Mali')),
            DropdownMenuItem(value: 'BF', child: Text('🇧🇫 Burkina Faso')),
            DropdownMenuItem(value: 'BJ', child: Text('🇧🇯 Bénin')),
            DropdownMenuItem(value: 'TG', child: Text('🇹🇬 Togo')),
            DropdownMenuItem(value: 'NE', child: Text('🇳🇪 Niger')),
            DropdownMenuItem(value: 'GW', child: Text('🇬🇼 Guinée-Bissau')),
          ],
          onChanged: (value) {},
        ),
      ],
    );
  }

  // ─── Étape 3 : Documents KYC ─────────────────────────────────────
  Widget _buildDocumentsStep(bool isDark) {
    return Column(
      key: const ValueKey('step2'),
      children: [
        // Info box
        Container(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          decoration: BoxDecoration(
            color: AppTheme.secondaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(
              color: AppTheme.secondaryColor.withOpacity(0.3),
            ),
          ),
          child: const Row(
            children: [
              Icon(Icons.info_outline, color: AppTheme.secondaryColor),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Pour valider votre compte, nous avons besoin d\'un justificatif d\'entreprise (Kbis ou équivalent) et d\'une pièce d\'identité.',
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppTheme.spacingLg),

        // Upload Kbis
        _buildDocumentUploadCard(
          isDark: isDark,
          icon: Icons.description,
          title: 'Registre de commerce (Kbis)',
          subtitle: 'PDF ou image, max 5 Mo',
          isUploaded: _kbisUploaded,
          onUpload: () => _simulateUpload('kbis'),
        ),
        const SizedBox(height: AppTheme.spacingMd),

        // Upload ID
        _buildDocumentUploadCard(
          isDark: isDark,
          icon: Icons.badge,
          title: 'Pièce d\'identité',
          subtitle: 'CNI, Passeport ou Carte de séjour',
          isUploaded: _idUploaded,
          onUpload: () => _simulateUpload('id'),
        ),

        // Barre de progression si upload en cours
        if (_isUploading) ...[
          const SizedBox(height: AppTheme.spacingLg),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Envoi en cours…',
                    style: TextStyle(
                      color: isDark
                          ? AppTheme.textSecondaryDark
                          : AppTheme.textSecondaryLight,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    '${(_uploadProgress * 100).toInt()}%',
                    style: const TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _uploadProgress,
                  backgroundColor: isDark
                      ? AppTheme.dividerDark
                      : AppTheme.dividerLight,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                      AppTheme.primaryColor),
                  minHeight: 6,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildDocumentUploadCard({
    required bool isDark,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isUploaded,
    required VoidCallback onUpload,
  }) {
    return InkWell(
      onTap: isUploaded ? null : onUpload,
      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.cardDark : AppTheme.cardLight,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(
            color: isUploaded
                ? AppTheme.accentGreen
                : (isDark ? AppTheme.dividerDark : AppTheme.dividerLight),
            width: isUploaded ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUploaded
                    ? AppTheme.accentGreen.withOpacity(0.15)
                    : AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              ),
              child: Icon(
                isUploaded ? Icons.check_circle : icon,
                color: isUploaded ? AppTheme.accentGreen : AppTheme.primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: AppTheme.spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppTheme.textPrimaryDark
                          : AppTheme.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isUploaded ? 'Document envoyé ✓' : subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: isUploaded
                          ? AppTheme.accentGreen
                          : (isDark
                              ? AppTheme.textSecondaryDark
                              : AppTheme.textSecondaryLight),
                    ),
                  ),
                ],
              ),
            ),
            if (!isUploaded)
              const Icon(Icons.cloud_upload_outlined,
                  color: AppTheme.primaryColor),
          ],
        ),
      ),
    );
  }
}
