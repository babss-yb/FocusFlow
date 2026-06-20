import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Écran d'activation post-inscription avec checklist guidée de 5 étapes.
/// Rassure l'utilisateur sur l'avancement de la mise en place de son compte.
class ActivationScreen extends StatefulWidget {
  const ActivationScreen({super.key});

  @override
  State<ActivationScreen> createState() => _ActivationScreenState();
}

class _ActivationScreenState extends State<ActivationScreen>
    with TickerProviderStateMixin {
  final List<_ActivationStep> _steps = [
    _ActivationStep(
      icon: Icons.check_circle,
      title: 'Compte créé',
      subtitle: 'Votre compte FinFlow a été créé avec succès.',
      isCompleted: true,
    ),
    _ActivationStep(
      icon: Icons.verified_user,
      title: 'Vérification d\'identité',
      subtitle: 'Vos documents sont en cours de vérification.',
      isCompleted: true,
    ),
    _ActivationStep(
      icon: Icons.account_balance,
      title: 'Validation du compte',
      subtitle: 'Votre compte professionnel est en cours d\'approbation.',
      isCompleted: false,
      isInProgress: true,
    ),
    _ActivationStep(
      icon: Icons.credit_card,
      title: 'Carte en cours de livraison',
      subtitle: 'Votre carte de paiement sera livrée sous 48h.',
      isCompleted: false,
    ),
    _ActivationStep(
      icon: Icons.rocket_launch,
      title: 'Prêt à démarrer !',
      subtitle: 'Effectuez votre premier virement et profitez de FinFlow.',
      isCompleted: false,
    ),
  ];

  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  int get _completedCount => _steps.where((s) => s.isCompleted).length;
  double get _progress => _completedCount / _steps.length;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppTheme.spacingMd),

              // En-tête avec progression circulaire
              Center(
                child: Column(
                  children: [
                    AnimatedBuilder(
                      animation: _progressController,
                      builder: (context, child) {
                        return SizedBox(
                          width: 100,
                          height: 100,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 100,
                                height: 100,
                                child: CircularProgressIndicator(
                                  value: _progress *
                                      _progressController.value,
                                  strokeWidth: 8,
                                  backgroundColor: isDark
                                      ? AppTheme.dividerDark
                                      : AppTheme.dividerLight,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          AppTheme.primaryColor),
                                  strokeCap: StrokeCap.round,
                                ),
                              ),
                              Text(
                                '${(_progress * 100).toInt()}%',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: AppTheme.spacingMd),
                    Text(
                      'Activation en cours',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$_completedCount sur ${_steps.length} étapes complétées',
                      style: TextStyle(
                        color: isDark
                            ? AppTheme.textSecondaryDark
                            : AppTheme.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacingXl),

              // Checklist
              Expanded(
                child: ListView.builder(
                  itemCount: _steps.length,
                  itemBuilder: (context, index) {
                    final step = _steps[index];
                    final isLast = index == _steps.length - 1;
                    return _buildStepItem(step, isLast, isDark, index);
                  },
                ),
              ),

              // Bouton pour accéder au dashboard
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Accéder au tableau de bord'),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 18),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacingSm),
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Besoin d\'aide ? Contactez-nous',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepItem(
      _ActivationStep step, bool isLast, bool isDark, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 150)),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline
            Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: step.isCompleted
                        ? AppTheme.accentGreen
                        : step.isInProgress
                            ? AppTheme.primaryColor
                            : (isDark
                                ? AppTheme.cardDark
                                : AppTheme.scaffoldLight),
                    border: Border.all(
                      color: step.isCompleted
                          ? AppTheme.accentGreen
                          : step.isInProgress
                              ? AppTheme.primaryColor
                              : (isDark
                                  ? AppTheme.dividerDark
                                  : AppTheme.dividerLight),
                      width: 2,
                    ),
                    boxShadow: step.isInProgress
                        ? [
                            BoxShadow(
                              color: AppTheme.primaryColor.withOpacity(0.3),
                              blurRadius: 8,
                            ),
                          ]
                        : null,
                  ),
                  child: Icon(
                    step.isCompleted
                        ? Icons.check
                        : step.isInProgress
                            ? Icons.hourglass_top
                            : step.icon,
                    color: step.isCompleted || step.isInProgress
                        ? Colors.white
                        : (isDark
                            ? AppTheme.textSecondaryDark
                            : AppTheme.textSecondaryLight),
                    size: 20,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: step.isCompleted
                          ? AppTheme.accentGreen
                          : (isDark
                              ? AppTheme.dividerDark
                              : AppTheme.dividerLight),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: AppTheme.spacingMd),

            // Contenu
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: AppTheme.spacingLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: step.isCompleted || step.isInProgress
                            ? (isDark
                                ? AppTheme.textPrimaryDark
                                : AppTheme.textPrimaryLight)
                            : (isDark
                                ? AppTheme.textSecondaryDark
                                : AppTheme.textSecondaryLight),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      step.subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? AppTheme.textSecondaryDark
                            : AppTheme.textSecondaryLight,
                      ),
                    ),
                    if (step.isInProgress) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryColor.withOpacity(0.15),
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusSm),
                        ),
                        child: const Text(
                          'En cours • Estimé : 24h',
                          style: TextStyle(
                            color: AppTheme.secondaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivationStep {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isCompleted;
  final bool isInProgress;

  _ActivationStep({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isCompleted,
    this.isInProgress = false,
  });
}
