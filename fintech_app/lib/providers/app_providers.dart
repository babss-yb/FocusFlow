import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../models/user_model.dart';
import '../models/project.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../services/rest_service.dart';

/// Provider gérant l'état de l'authentification.
class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool _isLoggedIn = false;
  UserModel? _user;
  String? _error;

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  UserModel? get user => _user;
  String? get error => _error;

  AuthProvider() {
    _init();
  }

  Future<void> _init() async {
    await _authService.init();
    _isLoggedIn = _authService.isLoggedIn;
    _user = _authService.currentUser;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _authService.login(email: email, password: password);
    _isLoading = false;
    _isLoggedIn = result.success;
    _user = result.user;
    _error = result.errorMessage;
    notifyListeners();

    return result.success;
  }

  Future<bool> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    String? companyName,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _authService.register(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      password: password,
      companyName: companyName,
    );

    _isLoading = false;
    _isLoggedIn = result.success;
    _user = result.user;
    _error = result.errorMessage;
    notifyListeners();

    return result.success;
  }

  Future<void> updateProfile(UserModel updatedUser) async {
    await _authService.updateProfile(updatedUser);
    _user = updatedUser;
    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.logout();
    _isLoggedIn = false;
    _user = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}

/// Provider gérant les transactions et le solde.
class TransactionProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Transaction> _transactions = [];
  double _balance = 0;
  bool _isLoading = false;

  List<Transaction> get transactions => _transactions;
  double get balance => _balance;
  bool get isLoading => _isLoading;

  /// Transactions en attente.
  List<Transaction> get pendingTransactions =>
      _transactions.where((t) => t.status == TransactionStatus.pending).toList();

  /// Dernières transactions (max 5).
  List<Transaction> get recentTransactions =>
      _transactions.take(5).toList();

  /// Charge les transactions et le solde depuis l'API.
  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    _transactions = await _apiService.getTransactions();
    _balance = await _apiService.getBalance();
    _isLoading = false;
    notifyListeners();
  }

  /// Crée un nouveau virement.
  Future<Transaction?> createTransfer({
    required String recipientName,
    required String recipientAccount,
    required double amount,
    required String description,
  }) async {
    _isLoading = true;
    notifyListeners();

    final transaction = await _apiService.createTransfer(
      recipientName: recipientName,
      recipientAccount: recipientAccount,
      amount: amount,
      description: description,
    );

    _transactions.insert(0, transaction);
    _balance -= amount;
    _isLoading = false;
    notifyListeners();

    return transaction;
  }
}

/// Provider gérant le thème de l'application.
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}

/// Provider gérant les projets via l'API REST (Livrable 2).
class ProjectProvider extends ChangeNotifier {
  final RestApiService _apiService = RestApiService();

  List<Project> _projects = [];
  List<ProjectTask> _tasks = [];
  bool _isLoading = false;

  List<Project> get projects => _projects;
  List<ProjectTask> get tasks => _tasks;
  bool get isLoading => _isLoading;

  Future<void> loadProjectsAndTasks() async {
    _isLoading = true;
    notifyListeners();

    try {
      _projects = await _apiService.getProjects();
      _tasks = await _apiService.getTasks();
    } catch (e) {
      debugPrint("Erreur chargement API: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addProject(String title, String description) async {
    _isLoading = true;
    notifyListeners();

    try {
      final newProj = Project(id: 0, title: title, description: description, userId: 1);
      final created = await _apiService.addProject(newProj);
      _projects.insert(0, created);
    } catch (e) {
      debugPrint("Erreur ajout API: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProject(Project project) async {
    _isLoading = true;
    notifyListeners();

    try {
      final updated = await _apiService.updateProject(project);
      final index = _projects.indexWhere((p) => p.id == project.id);
      if (index != -1) {
        _projects[index] = updated;
      }
    } catch (e) {
      debugPrint("Erreur modification API: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteProject(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await _apiService.deleteProject(id);
      if (success) {
        _projects.removeWhere((p) => p.id == id);
      }
    } catch (e) {
      debugPrint("Erreur suppression API: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
