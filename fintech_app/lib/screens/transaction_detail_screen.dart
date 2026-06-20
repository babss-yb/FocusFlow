import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_providers.dart';
import '../models/transaction.dart';

/// Écran de détail d'une transaction.
class TransactionDetailScreen extends StatelessWidget {
  final String transactionId;

  const TransactionDetailScreen({super.key, required this.transactionId});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final txProvider = context.watch<TransactionProvider>();
    final transaction = txProvider.transactions.firstWhere(
      (t) => t.id == transactionId,
      orElse: () => Transaction(
        id: 'N/A',
        title: 'Transaction introuvable',
        description: '',
        amount: 0,
        date: DateTime.now(),
        type: TransactionType.payment,
      ),
    );

    final isDebit = transaction.isDebit;
    final color = isDebit ? AppTheme.accentRed : AppTheme.accentGreen;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail de la transaction'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        child: Column(
          children: [
            // Montant principal
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppTheme.spacingXl),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.cardDark : AppTheme.cardLight,
                borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                border: Border.all(
                  color: isDark ? AppTheme.dividerDark : AppTheme.dividerLight,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isDebit ? Icons.arrow_upward : Icons.arrow_downward,
                      color: color,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingMd),
                  Text(
                    transaction.formattedAmount,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    transaction.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? AppTheme.textPrimaryDark
                          : AppTheme.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingMd),
                  _buildStatusBadge(transaction.status),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacingLg),

            // Détails
            Container(
              width: double.infinity,
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
                  Text(
                    'Informations',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDark
                          ? AppTheme.textPrimaryDark
                          : AppTheme.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingMd),
                  _buildDetailRow('Description', transaction.description, isDark),
                  if (transaction.recipientName != null)
                    _buildDetailRow('Bénéficiaire', transaction.recipientName!, isDark),
                  if (transaction.recipientAccount != null)
                    _buildDetailRow('Compte', transaction.recipientAccount!, isDark),
                  if (transaction.reference != null)
                    _buildDetailRow('Référence', transaction.reference!, isDark),
                  if (transaction.category != null)
                    _buildDetailRow('Catégorie', transaction.category!, isDark),
                  _buildDetailRow(
                    'Date',
                    '${transaction.date.day}/${transaction.date.month}/${transaction.date.year} à ${transaction.date.hour}:${transaction.date.minute.toString().padLeft(2, '0')}',
                    isDark,
                  ),
                  _buildDetailRow('ID', transaction.id, isDark),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacingLg),

            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.download),
                    label: const Text('Télécharger'),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingMd),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.share),
                    label: const Text('Partager'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMd),
            if (transaction.status == TransactionStatus.pending)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.cancel),
                  label: const Text('Annuler la transaction'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentRed,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(TransactionStatus status) {
    Color color;
    String label;
    IconData icon;

    switch (status) {
      case TransactionStatus.completed:
        color = AppTheme.accentGreen;
        label = 'Terminée';
        icon = Icons.check_circle;
        break;
      case TransactionStatus.pending:
        color = AppTheme.secondaryColor;
        label = 'En attente';
        icon = Icons.hourglass_top;
        break;
      case TransactionStatus.failed:
        color = AppTheme.accentRed;
        label = 'Échouée';
        icon = Icons.error;
        break;
      case TransactionStatus.cancelled:
        color = Colors.grey;
        label = 'Annulée';
        icon = Icons.cancel;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(AppTheme.radiusRound),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: isDark
                    ? AppTheme.textSecondaryDark
                    : AppTheme.textSecondaryLight,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppTheme.textPrimaryDark
                    : AppTheme.textPrimaryLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
