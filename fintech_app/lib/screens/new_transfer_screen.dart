import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_providers.dart';

/// Formulaire de nouveau virement.
class NewTransferScreen extends StatefulWidget {
  const NewTransferScreen({super.key});

  @override
  State<NewTransferScreen> createState() => _NewTransferScreenState();
}

class _NewTransferScreenState extends State<NewTransferScreen> {
  final _formKey = GlobalKey<FormState>();
  final _recipientNameController = TextEditingController();
  final _recipientAccountController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isSending = false;

  @override
  void dispose() {
    _recipientNameController.dispose();
    _recipientAccountController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleSend() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSending = true);

    final txProvider = context.read<TransactionProvider>();
    final transaction = await txProvider.createTransfer(
      recipientName: _recipientNameController.text.trim(),
      recipientAccount: _recipientAccountController.text.trim(),
      amount: double.parse(_amountController.text.replaceAll(' ', '')),
      description: _descriptionController.text.trim(),
    );

    if (mounted) {
      setState(() => _isSending = false);
      if (transaction != null) {
        _showSuccessDialog();
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppTheme.accentGreen.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: AppTheme.accentGreen,
                  size: 40,
                ),
              ),
              const SizedBox(height: AppTheme.spacingMd),
              const Text(
                'Virement initié !',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Votre virement de ${_amountController.text} FCFA a été envoyé avec succès.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: AppTheme.spacingLg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Ferme le dialog
                    Navigator.pop(context); // Retour au dashboard
                  },
                  child: const Text('Retour au dashboard'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouveau virement'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bénéficiaire
              Text(
                'Bénéficiaire',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isDark
                      ? AppTheme.textPrimaryDark
                      : AppTheme.textPrimaryLight,
                ),
              ),
              const SizedBox(height: AppTheme.spacingMd),

              // Contacts rapides (simulés)
              SizedBox(
                height: 90,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildQuickContact('Mamadou', 'MT', isDark),
                    _buildQuickContact('Fatou', 'FN', isDark),
                    _buildQuickContact('Orange', 'OR', isDark),
                    _buildQuickContact('SCI Dakar', 'SD', isDark),
                    _buildQuickContact('Nouveau', '+', isDark, isAdd: true),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacingMd),

              TextFormField(
                controller: _recipientNameController,
                decoration: const InputDecoration(
                  labelText: 'Nom du bénéficiaire',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (v) =>
                    v?.isEmpty == true ? 'Champ requis' : null,
              ),
              const SizedBox(height: AppTheme.spacingMd),

              TextFormField(
                controller: _recipientAccountController,
                decoration: const InputDecoration(
                  labelText: 'Numéro de compte (IBAN)',
                  hintText: 'SN08 XXXX XXXX XXXX XXXX',
                  prefixIcon: Icon(Icons.account_balance),
                ),
                validator: (v) =>
                    v?.isEmpty == true ? 'Champ requis' : null,
              ),
              const SizedBox(height: AppTheme.spacingLg),

              Text(
                'Détails du virement',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isDark
                      ? AppTheme.textPrimaryDark
                      : AppTheme.textPrimaryLight,
                ),
              ),
              const SizedBox(height: AppTheme.spacingMd),

              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Montant',
                  hintText: '0',
                  prefixIcon: Icon(Icons.payments),
                  suffixText: 'FCFA',
                ),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Montant requis';
                  final amount =
                      double.tryParse(v.replaceAll(' ', ''));
                  if (amount == null || amount <= 0) {
                    return 'Montant invalide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppTheme.spacingMd),

              TextFormField(
                controller: _descriptionController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Motif du virement',
                  hintText: 'Ex: Paiement facture fournisseur',
                  prefixIcon: Icon(Icons.note),
                ),
              ),
              const SizedBox(height: AppTheme.spacingMd),

              // Sélection de la date d'exécution
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.cardDark : AppTheme.cardLight,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  border: Border.all(
                    color: isDark
                        ? AppTheme.dividerDark
                        : AppTheme.dividerLight,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.schedule,
                        color: AppTheme.primaryColor),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Exécution immédiate',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? AppTheme.textPrimaryDark
                                  : AppTheme.textPrimaryLight,
                            ),
                          ),
                          Text(
                            'Le virement sera traité dans les minutes qui suivent',
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
                    const Icon(Icons.chevron_right,
                        color: AppTheme.primaryColor),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacingXl),

              // Bouton envoyer
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isSending ? null : _handleSend,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                  ),
                  child: _isSending
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.send),
                            SizedBox(width: 8),
                            Text('Envoyer le virement'),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickContact(String name, String initials, bool isDark,
      {bool isAdd = false}) {
    return GestureDetector(
      onTap: () {
        if (!isAdd) {
          _recipientNameController.text = name;
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(right: AppTheme.spacingMd),
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isAdd
                    ? (isDark ? AppTheme.cardDark : AppTheme.scaffoldLight)
                    : AppTheme.primaryColor.withOpacity(0.12),
                border: isAdd
                    ? Border.all(
                        color: isDark
                            ? AppTheme.dividerDark
                            : AppTheme.dividerLight,
                        style: BorderStyle.solid,
                      )
                    : null,
              ),
              child: Center(
                child: isAdd
                    ? Icon(Icons.add,
                        color: isDark
                            ? AppTheme.textSecondaryDark
                            : AppTheme.textSecondaryLight)
                    : Text(
                        initials,
                        style: const TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              name,
              style: TextStyle(
                fontSize: 11,
                color: isDark
                    ? AppTheme.textSecondaryDark
                    : AppTheme.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
