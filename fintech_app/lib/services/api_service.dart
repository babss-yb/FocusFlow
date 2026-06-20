import '../models/transaction.dart';
import '../models/user_model.dart';

/// Service simulant les appels API REST vers le backend Fintech.
/// Chaque méthode est préparée pour être remplacée par de véritables
/// appels HTTP (GET, POST, PUT, DELETE) une fois l'API déployée.
class ApiService {
  // Base URL du futur backend
  static const String baseUrl = 'https://api.fintech-pme.com/v1';

  // ─── Transactions (CRUD) ──────────────────────────────────────────

  /// GET /transactions - Récupère toutes les transactions de l'utilisateur.
  Future<List<Transaction>> getTransactions() async {
    // Simulation d'un délai réseau
    await Future.delayed(const Duration(milliseconds: 800));
    return _mockTransactions;
  }

  /// GET /transactions/:id - Récupère le détail d'une transaction.
  Future<Transaction?> getTransactionById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      return _mockTransactions.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  /// POST /transactions - Crée un nouveau virement.
  Future<Transaction> createTransfer({
    required String recipientName,
    required String recipientAccount,
    required double amount,
    required String description,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    return Transaction(
      id: 'TXN-${DateTime.now().millisecondsSinceEpoch}',
      title: 'Virement à $recipientName',
      description: description,
      amount: amount,
      date: DateTime.now(),
      type: TransactionType.transferOut,
      status: TransactionStatus.pending,
      recipientName: recipientName,
      recipientAccount: recipientAccount,
      reference: 'REF-${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  /// PUT /transactions/:id - Met à jour une transaction.
  Future<bool> updateTransaction(String id, Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return true; // Succès simulé
  }

  /// DELETE /transactions/:id - Annule une transaction.
  Future<bool> deleteTransaction(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true; // Succès simulé
  }

  // ─── Utilisateur (CRUD) ───────────────────────────────────────────

  /// GET /user/profile - Récupère le profil utilisateur.
  Future<UserModel> getUserProfile() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _mockUser;
  }

  /// PUT /user/profile - Met à jour le profil utilisateur.
  Future<UserModel> updateUserProfile(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _mockUser;
  }

  /// GET /user/balance - Récupère le solde courant.
  Future<double> getBalance() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return 2750000;
  }

  // ─── Données mockées ──────────────────────────────────────────────

  static final UserModel _mockUser = UserModel(
    id: 'USR-001',
    firstName: 'Aminata',
    lastName: 'Diallo',
    email: 'aminata.diallo@pme-dakar.sn',
    phone: '+221 77 123 45 67',
    companyName: 'Diallo & Fils SARL',
    companyType: 'SARL',
    isVerified: true,
    createdAt: DateTime(2025, 3, 15),
    referralCode: 'DIALLO-2025',
  );

  static final List<Transaction> _mockTransactions = [
    Transaction(
      id: 'TXN-001',
      title: 'Paiement fournisseur',
      description: 'Achat de marchandises - Lot n°2547',
      amount: 450000,
      date: DateTime.now().subtract(const Duration(hours: 2)),
      type: TransactionType.transferOut,
      status: TransactionStatus.completed,
      recipientName: 'Mamadou Trading',
      recipientAccount: 'SN08 2001 0001 0000 1234 5678',
      reference: 'REF-2025-001',
      category: 'Fournisseurs',
    ),
    Transaction(
      id: 'TXN-002',
      title: 'Encaissement client',
      description: 'Facture #FA-2025-089 - Services consulting',
      amount: 1200000,
      date: DateTime.now().subtract(const Duration(hours: 5)),
      type: TransactionType.transferIn,
      status: TransactionStatus.completed,
      recipientName: 'Groupe Sénégal Invest',
      reference: 'REF-2025-002',
      category: 'Clients',
    ),
    Transaction(
      id: 'TXN-003',
      title: 'Paiement facture Orange',
      description: 'Abonnement téléphonique mensuel',
      amount: 85000,
      date: DateTime.now().subtract(const Duration(days: 1)),
      type: TransactionType.payment,
      status: TransactionStatus.completed,
      recipientName: 'Orange Sénégal',
      reference: 'REF-2025-003',
      category: 'Télécom',
    ),
    Transaction(
      id: 'TXN-004',
      title: 'Versement salaire',
      description: 'Salaire employé - Juin 2025',
      amount: 350000,
      date: DateTime.now().subtract(const Duration(days: 1)),
      type: TransactionType.transferOut,
      status: TransactionStatus.completed,
      recipientName: 'Fatou Ndiaye',
      recipientAccount: 'SN08 2001 0002 0000 9876 5432',
      reference: 'REF-2025-004',
      category: 'Salaires',
    ),
    Transaction(
      id: 'TXN-005',
      title: 'Frais de tenue de compte',
      description: 'Frais bancaires mensuels',
      amount: 5000,
      date: DateTime.now().subtract(const Duration(days: 2)),
      type: TransactionType.fee,
      status: TransactionStatus.completed,
      reference: 'REF-2025-005',
      category: 'Frais bancaires',
    ),
    Transaction(
      id: 'TXN-006',
      title: 'Dépôt espèces',
      description: 'Dépôt au guichet - Agence Plateau',
      amount: 500000,
      date: DateTime.now().subtract(const Duration(days: 3)),
      type: TransactionType.deposit,
      status: TransactionStatus.completed,
      reference: 'REF-2025-006',
      category: 'Dépôts',
    ),
    Transaction(
      id: 'TXN-007',
      title: 'Virement en attente',
      description: 'Paiement loyer local commercial',
      amount: 300000,
      date: DateTime.now().subtract(const Duration(hours: 1)),
      type: TransactionType.transferOut,
      status: TransactionStatus.pending,
      recipientName: 'SCI Dakar Immobilier',
      recipientAccount: 'SN08 2003 0001 0000 5555 6666',
      reference: 'REF-2025-007',
      category: 'Loyer',
    ),
  ];
}
