import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_providers.dart';
import '../models/transaction.dart';

/// Écran Virements / Factures (onglet 2).
/// Affiche l'historique complet des transactions avec filtres.
class TransfersScreen extends StatefulWidget {
  const TransfersScreen({super.key});

  @override
  State<TransfersScreen> createState() => _TransfersScreenState();
}

class _TransfersScreenState extends State<TransfersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'Tout';

  final _filters = ['Tout', 'Entrées', 'Sorties', 'En attente'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Transaction> _filterTransactions(List<Transaction> transactions) {
    switch (_selectedFilter) {
      case 'Entrées':
        return transactions.where((t) => !t.isDebit).toList();
      case 'Sorties':
        return transactions.where((t) => t.isDebit).toList();
      case 'En attente':
        return transactions
            .where((t) => t.status == TransactionStatus.pending)
            .toList();
      default:
        return transactions;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final txProvider = context.watch<TransactionProvider>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Virements & Factures',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.search),
                  ),
                ],
              ),
            ),

            // Filtres
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
              child: SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _filters.length,
                  itemBuilder: (context, index) {
                    final filter = _filters[index];
                    final isActive = _selectedFilter == filter;

                    return GestureDetector(
                      onTap: () =>
                          setState(() => _selectedFilter = filter),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppTheme.primaryColor
                              : (isDark
                                  ? AppTheme.cardDark
                                  : AppTheme.scaffoldLight),
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusRound),
                          border: Border.all(
                            color: isActive
                                ? AppTheme.primaryColor
                                : (isDark
                                    ? AppTheme.dividerDark
                                    : AppTheme.dividerLight),
                          ),
                        ),
                        child: Text(
                          filter,
                          style: TextStyle(
                            color: isActive
                                ? Colors.white
                                : (isDark
                                    ? AppTheme.textSecondaryDark
                                    : AppTheme.textSecondaryLight),
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingMd),

            // Liste des transactions
            Expanded(
              child: _buildTransactionList(
                  _filterTransactions(txProvider.transactions), isDark),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/new-transfer');
        },
        icon: const Icon(Icons.add),
        label: const Text('Nouveau'),
      ),
    );
  }

  Widget _buildTransactionList(
      List<Transaction> transactions, bool isDark) {
    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long,
              size: 64,
              color: isDark
                  ? AppTheme.dividerDark
                  : AppTheme.dividerLight,
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Text(
              'Aucune transaction trouvée',
              style: TextStyle(
                color: isDark
                    ? AppTheme.textSecondaryDark
                    : AppTheme.textSecondaryLight,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
      itemCount: transactions.length,
      separatorBuilder: (_, __) => Divider(
        color: isDark ? AppTheme.dividerDark : AppTheme.dividerLight,
        height: 1,
      ),
      itemBuilder: (context, index) {
        final tx = transactions[index];
        final color =
            tx.isDebit ? AppTheme.accentRed : AppTheme.accentGreen;

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 4),
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            ),
            child: Icon(
              tx.isDebit ? Icons.arrow_upward : Icons.arrow_downward,
              color: color,
              size: 22,
            ),
          ),
          title: Text(
            tx.title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            tx.description,
            style: TextStyle(
              fontSize: 12,
              color: isDark
                  ? AppTheme.textSecondaryDark
                  : AppTheme.textSecondaryLight,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                tx.formattedAmount,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: color,
                  fontSize: 14,
                ),
              ),
              if (tx.status == TransactionStatus.pending)
                const Text(
                  'En attente',
                  style: TextStyle(
                    color: AppTheme.secondaryColor,
                    fontSize: 10,
                  ),
                ),
            ],
          ),
          onTap: () {
            Navigator.pushNamed(context, '/transaction-detail',
                arguments: tx.id);
          },
        );
      },
    );
  }
}
