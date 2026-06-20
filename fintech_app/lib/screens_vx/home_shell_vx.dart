import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'dashboard_screen.dart';
import 'transfer_screen.dart';
import 'ai_assistant_screen.dart';
import 'profile_referral_screen.dart';

class HomeShellVx extends StatefulWidget {
  const HomeShellVx({super.key});

  @override
  State<HomeShellVx> createState() => _HomeShellVxState();
}

class _HomeShellVxState extends State<HomeShellVx> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const TransferScreen(),
    const AiAssistantScreen(),
    const ProfileReferralScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Vx.white,
        indicatorColor: Vx.emerald100,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.space_dashboard_outlined),
            selectedIcon: Icon(Icons.space_dashboard, color: Vx.emerald700),
            label: 'Tableau',
          ),
          NavigationDestination(
            icon: Icon(Icons.swap_horiz_outlined),
            selectedIcon: Icon(Icons.swap_horiz, color: Vx.emerald700),
            label: 'Virements',
          ),
          NavigationDestination(
            icon: Icon(Icons.smart_toy_outlined),
            selectedIcon: Icon(Icons.smart_toy, color: Vx.emerald700),
            label: 'Assistant IA',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: Vx.emerald700),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
