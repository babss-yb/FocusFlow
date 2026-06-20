import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Écran d'onboarding avec simulateur de coûts bancaires.
/// Première interaction avec l'utilisateur PME.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Simulateur de coûts
  double _monthlyTransactions = 50;
  double _averageAmount = 500000;
  double _employeeCount = 5;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  double get _estimatedMonthlyCost {
    // Simulation : frais de 0.5% par transaction + 2000 FCFA/employé
    return (_monthlyTransactions * _averageAmount * 0.005) +
        (_employeeCount * 2000);
  }

  double get _fintechMonthlyCost {
    // Notre offre : frais réduits de 60%
    return _estimatedMonthlyCost * 0.4;
  }

  double get _savings => _estimatedMonthlyCost - _fintechMonthlyCost;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Indicateur de page
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingLg,
                  vertical: AppTheme.spacingMd),
              child: Row(
                children: List.generate(
                  3,
                  (index) => Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: index <= _currentPage
                            ? AppTheme.primaryColor
                            : (isDark
                                ? AppTheme.dividerDark
                                : AppTheme.dividerLight),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Pages
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() => _currentPage = page);
                  _fadeController.reset();
                  _fadeController.forward();
                },
                children: [
                  _buildWelcomePage(isDark),
                  _buildFeaturesPage(isDark),
                  _buildSimulatorPage(isDark),
                ],
              ),
            ),

            // Boutons navigation
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              child: Row(
                children: [
                  if (_currentPage > 0)
                    TextButton(
                      onPressed: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: const Text('Retour'),
                    ),
                  const Spacer(),
                  if (_currentPage < 2)
                    ElevatedButton(
                      onPressed: () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Suivant'),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, size: 18),
                        ],
                      ),
                    )
                  else
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.secondaryColor,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Commencer'),
                          SizedBox(width: 8),
                          Icon(Icons.rocket_launch, size: 18),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Page 1 : Bienvenue ─────────────────────────────────────────────
  Widget _buildWelcomePage(bool isDark) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo / Icône
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(AppTheme.radiusXl),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.account_balance_wallet,
                size: 56,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: AppTheme.spacingXl),
            Text(
              'Bienvenue sur FinFlow',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppTheme.textPrimaryDark
                        : AppTheme.textPrimaryLight,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Text(
              'La solution bancaire pensée pour les entrepreneurs et PME d\'Afrique de l\'Ouest.\nGérez votre trésorerie, payez vos fournisseurs et suivez vos finances en toute simplicité.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: isDark
                        ? AppTheme.textSecondaryDark
                        : AppTheme.textSecondaryLight,
                    height: 1.6,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacingXl),
            // Badges de confiance
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildBadge(Icons.security, 'Sécurisé', isDark),
                const SizedBox(width: AppTheme.spacingMd),
                _buildBadge(Icons.speed, 'Rapide', isDark),
                const SizedBox(width: AppTheme.spacingMd),
                _buildBadge(Icons.savings, 'Économique', isDark),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(IconData icon, String label, bool isDark) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? AppTheme.cardDark : AppTheme.scaffoldLight,
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(
              color: isDark ? AppTheme.dividerDark : AppTheme.dividerLight,
            ),
          ),
          child: Icon(icon, color: AppTheme.primaryColor, size: 28),
        ),
        const SizedBox(height: 6),
        Text(
          label,
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

  // ─── Page 2 : Fonctionnalités ───────────────────────────────────────
  Widget _buildFeaturesPage(bool isDark) {
    final features = [
      _FeatureItem(
        icon: Icons.account_balance,
        title: 'Compte professionnel',
        subtitle: 'Ouverture rapide, 100% mobile, sans paperasse.',
        color: AppTheme.primaryColor,
      ),
      _FeatureItem(
        icon: Icons.swap_horiz,
        title: 'Virements instantanés',
        subtitle: 'Envoyez et recevez en FCFA, UEMOA et au-delà.',
        color: AppTheme.accentGreen,
      ),
      _FeatureItem(
        icon: Icons.receipt_long,
        title: 'Facturation intégrée',
        subtitle: 'Créez et suivez vos factures professionnelles.',
        color: AppTheme.secondaryColor,
      ),
      _FeatureItem(
        icon: Icons.smart_toy,
        title: 'Assistant IA comptable',
        subtitle: 'Posez vos questions à notre IA dédiée aux PME.',
        color: const Color(0xFF9B59B6),
      ),
    ];

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppTheme.spacingXl),
            Text(
              'Tout ce qu\'il faut\npour votre PME',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppTheme.textPrimaryDark
                        : AppTheme.textPrimaryLight,
                  ),
            ),
            const SizedBox(height: AppTheme.spacingLg),
            ...features.map((f) => _buildFeatureCard(f, isDark)),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(_FeatureItem feature, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingMd),
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : AppTheme.cardLight,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(
          color: isDark ? AppTheme.dividerDark : AppTheme.dividerLight,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: feature.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            ),
            child: Icon(feature.icon, color: feature.color, size: 24),
          ),
          const SizedBox(width: AppTheme.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: isDark
                        ? AppTheme.textPrimaryDark
                        : AppTheme.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  feature.subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? AppTheme.textSecondaryDark
                        : AppTheme.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Page 3 : Simulateur de coûts ─────────────────────────────────
  Widget _buildSimulatorPage(bool isDark) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppTheme.spacingLg),
            Text(
              'Simulateur de coûts',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppTheme.textPrimaryDark
                        : AppTheme.textPrimaryLight,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Estimez vos économies en passant chez FinFlow',
              style: TextStyle(
                color: isDark
                    ? AppTheme.textSecondaryDark
                    : AppTheme.textSecondaryLight,
              ),
            ),
            const SizedBox(height: AppTheme.spacingLg),

            // Slider 1 : Nombre de transactions
            _buildSliderCard(
              isDark: isDark,
              icon: Icons.receipt,
              label: 'Transactions par mois',
              value: _monthlyTransactions,
              min: 10,
              max: 200,
              displayValue: '${_monthlyTransactions.toInt()}',
              onChanged: (v) => setState(() => _monthlyTransactions = v),
            ),
            const SizedBox(height: AppTheme.spacingMd),

            // Slider 2 : Montant moyen
            _buildSliderCard(
              isDark: isDark,
              icon: Icons.payments,
              label: 'Montant moyen (FCFA)',
              value: _averageAmount,
              min: 50000,
              max: 5000000,
              displayValue:
                  '${(_averageAmount / 1000).toStringAsFixed(0)}K FCFA',
              onChanged: (v) => setState(() => _averageAmount = v),
            ),
            const SizedBox(height: AppTheme.spacingMd),

            // Slider 3 : Employés
            _buildSliderCard(
              isDark: isDark,
              icon: Icons.people,
              label: 'Nombre d\'employés',
              value: _employeeCount,
              min: 1,
              max: 50,
              displayValue: '${_employeeCount.toInt()}',
              onChanged: (v) => setState(() => _employeeCount = v),
            ),
            const SizedBox(height: AppTheme.spacingLg),

            // Résultat du simulateur
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Banque traditionnelle',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      Text(
                        '${(_estimatedMonthlyCost / 1000).toStringAsFixed(0)}K FCFA/mois',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Avec FinFlow',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${(_fintechMonthlyCost / 1000).toStringAsFixed(0)}K FCFA/mois',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingMd),
                  const Divider(color: Colors.white30),
                  const SizedBox(height: AppTheme.spacingMd),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.savings, color: Colors.amber, size: 28),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Économie estimée',
                            style: TextStyle(color: Colors.white70),
                          ),
                          Text(
                            '${(_savings / 1000).toStringAsFixed(0)}K FCFA / mois',
                            style: const TextStyle(
                              color: Colors.amber,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacingXl),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderCard({
    required bool isDark,
    required IconData icon,
    required String label,
    required double value,
    required double min,
    required double max,
    required String displayValue,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : AppTheme.cardLight,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(
          color: isDark ? AppTheme.dividerDark : AppTheme.dividerLight,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.primaryColor, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: isDark
                        ? AppTheme.textSecondaryDark
                        : AppTheme.textSecondaryLight,
                    fontSize: 14,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                ),
                child: Text(
                  displayValue,
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: AppTheme.primaryColor,
              inactiveTrackColor: AppTheme.primaryColor.withOpacity(0.2),
              thumbColor: AppTheme.primaryColor,
              overlayColor: AppTheme.primaryColor.withOpacity(0.1),
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  _FeatureItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });
}
