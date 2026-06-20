import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_providers.dart';
import '../models/transaction.dart';

/// Tableau de bord principal - Livrable 1.
/// Affiche le solde, les dernières transactions et les accès rapides.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _balanceVisible = true;

  @override
  void initState() {
    super.initState();
    // Charge les données si pas encore fait
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<TransactionProvider>();
      if (provider.transactions.isEmpty) {
        provider.loadData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final txProvider = context.watch<TransactionProvider>();
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      body: SafeArea(
        child: txProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () => txProvider.loadData(),
                child: CustomScrollView(
                  slivers: [
                    // En-tête
                    SliverToBoxAdapter(
                      child: _buildHeader(isDark, authProvider),
                    ),
                    // Carte de solde
                    SliverToBoxAdapter(
                      child: _buildBalanceCard(isDark, txProvider),
                    ),
                    // Actions rapides
                    SliverToBoxAdapter(
                      child: _buildQuickActions(isDark),
                    ),
                    // Titre "Transactions récentes"
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppTheme.spacingLg,
                          AppTheme.spacingLg,
                          AppTheme.spacingLg,
                          AppTheme.spacingSm,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Transactions récentes',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: isDark
                                    ? AppTheme.textPrimaryDark
                                    : AppTheme.textPrimaryLight,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                'Voir tout',
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Liste des transactions
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final transaction =
                              txProvider.recentTransactions[index];
                          return _buildTransactionItem(
                              transaction, isDark, context);
                        },
                        childCount: txProvider.recentTransactions.length,
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: AppTheme.spacingXl),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  // ─── En-tête avec salutation ──────────────────────────────────────
  Widget _buildHeader(bool isDark, AuthProvider authProvider) {
    final userName = authProvider.user?.firstName ?? 'Entrepreneur';
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Bonjour';
    } else if (hour < 18) {
      greeting = 'Bon après-midi';
    } else {
      greeting = 'Bonsoir';
    }

    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            ),
            child: Center(
              child: Text(
                authProvider.user?.initials ?? 'FP',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$greeting, $userName 👋',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: isDark
                        ? AppTheme.textPrimaryDark
                        : AppTheme.textPrimaryLight,
                  ),
                ),
                Text(
                  authProvider.user?.companyName ?? 'Mon Entreprise',
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
          IconButton(
            onPressed: () {},
            icon: Stack(
              children: [
                Icon(
                  Icons.notifications_outlined,
                  color: isDark
                      ? AppTheme.textPrimaryDark
                      : AppTheme.textPrimaryLight,
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppTheme.accentRed,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Carte de solde ───────────────────────────────────────────────
  Widget _buildBalanceCard(bool isDark, TransactionProvider txProvider) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.35),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Trésorerie disponible',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() => _balanceVisible = !_balanceVisible);
                  },
                  child: Icon(
                    _balanceVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.white70,
                    size: 22,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                _balanceVisible
                    ? '${_formatAmount(txProvider.balance)} FCFA'
                    : '••••••••',
                key: ValueKey(_balanceVisible),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingMd),
            const Divider(color: Colors.white24),
            const SizedBox(height: AppTheme.spacingSm),
            Row(
              children: [
                _buildBalanceStat(
                    Icons.arrow_downward, 'Entrées', '+1 700 000', AppTheme.accentGreen),
                const SizedBox(width: AppTheme.spacingLg),
                _buildBalanceStat(
                    Icons.arrow_upward, 'Sorties', '-890 000', AppTheme.accentRed),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceStat(
      IconData icon, String label, String amount, Color color) {
    return Expanded(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style:
                      const TextStyle(color: Colors.white60, fontSize: 12)),
              Text(amount,
                  style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w600,
                      fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Actions rapides ──────────────────────────────────────────────
  Widget _buildQuickActions(bool isDark) {
    final actions = [
      _QuickAction(Icons.send, 'Envoyer', AppTheme.primaryColor, () {
        Navigator.pushNamed(context, '/new-transfer');
      }),
      _QuickAction(Icons.request_page, 'Facture', AppTheme.secondaryColor, () {}),
      _QuickAction(Icons.qr_code_scanner, 'Scanner', const Color(0xFF9B59B6), () {}),
      _QuickAction(Icons.add_card, 'Recharger', AppTheme.accentGreen, () {}),
    ];

    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: actions.map((action) {
          return GestureDetector(
            onTap: action.onTap,
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: action.color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  ),
                  child: Icon(action.icon, color: action.color, size: 26),
                ),
                const SizedBox(height: 8),
                Text(
                  action.label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? AppTheme.textSecondaryDark
                        : AppTheme.textSecondaryLight,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ─── Item de transaction ──────────────────────────────────────────
  Widget _buildTransactionItem(
      Transaction transaction, bool isDark, BuildContext context) {
    final color = transaction.isDebit ? AppTheme.accentRed : AppTheme.accentGreen;
    final icon = _getTransactionIcon(transaction.type);

    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/transaction-detail',
            arguments: transaction.id);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingLg,
          vertical: AppTheme.spacingSm,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: AppTheme.spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: isDark
                          ? AppTheme.textPrimaryDark
                          : AppTheme.textPrimaryLight,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatDate(transaction.date),
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? AppTheme.textSecondaryDark
                          : AppTheme.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  transaction.formattedAmount,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: color,
                  ),
                ),
                if (transaction.status == TransactionStatus.pending)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'En attente',
                      style: TextStyle(
                        color: AppTheme.secondaryColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
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

  IconData _getTransactionIcon(TransactionType type) {
    switch (type) {
      case TransactionType.transferIn:
        return Icons.arrow_downward;
      case TransactionType.transferOut:
        return Icons.arrow_upward;
      case TransactionType.payment:
        return Icons.receipt;
      case TransactionType.invoice:
        return Icons.description;
      case TransactionType.fee:
        return Icons.account_balance;
      case TransactionType.deposit:
        return Icons.savings;
    }
  }

  String _formatAmount(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    }
    final str = amount.toStringAsFixed(0);
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write(' ');
      buffer.write(str[i]);
    }
    return buffer.toString();
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 60) return 'Il y a ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Il y a ${diff.inHours}h';
    if (diff.inDays == 1) return 'Hier';
    if (diff.inDays < 7) return 'Il y a ${diff.inDays} jours';

    return '${date.day}/${date.month}/${date.year}';
  }
}

class _QuickAction {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  _QuickAction(this.icon, this.label, this.color, this.onTap);
}
