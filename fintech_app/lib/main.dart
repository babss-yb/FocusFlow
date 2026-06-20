import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'theme/app_theme.dart';
import 'providers/app_providers.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/activation_screen.dart';
import 'screens/home_shell.dart';
import 'screens/transaction_detail_screen.dart';
import 'screens/new_transfer_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const FintechApp());
}

class FintechApp extends StatelessWidget {
  const FintechApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'FinFlow - Fintech PME',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            initialRoute: '/onboarding',
            routes: {
              '/onboarding': (context) => const OnboardingScreen(),
              '/login': (context) => const LoginScreen(),
              '/register': (context) => const RegisterScreen(),
              '/activation': (context) => const ActivationScreen(),
              '/home': (context) => const HomeShell(),
              '/new-transfer': (context) => const NewTransferScreen(),
            },
            onGenerateRoute: (settings) {
              if (settings.name == '/transaction-detail') {
                final transactionId = settings.arguments as String;
                return MaterialPageRoute(
                  builder: (context) =>
                      TransactionDetailScreen(transactionId: transactionId),
                );
              }
              return null;
            },
          );
        },
      ),
    );
  }
}
