import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  final slate50 = const Color(0xFFF8FAFC);
  final slate100 = const Color(0xFFF1F5F9);
  final slate500 = const Color(0xFF64748B);
  final slate600 = const Color(0xFF475569);
  final slate800 = const Color(0xFF1E293B);
  final emerald100 = const Color(0xFFD1FAE5);
  final emerald500 = const Color(0xFF10B981);
  final emerald600 = const Color(0xFF059669);
  final red100 = const Color(0xFFFEE2E2);
  final red500 = const Color(0xFFEF4444);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: slate50,
      appBar: AppBar(
        backgroundColor: emerald600,
        elevation: 0,
        title: const Text(
          "Bonjour Samba 👋\nSolde actuel",
          style: TextStyle(fontSize: 14, color: Colors.white, height: 1.4),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.notifications_outlined, color: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Solde et Graphique
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: emerald600,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "12 450 000 FCFA",
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 120,
                    child: LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: false),
                        titlesData: const FlTitlesData(show: false),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: const [
                              FlSpot(0, 3), FlSpot(1, 4), FlSpot(2, 3.5),
                              FlSpot(3, 5), FlSpot(4, 4), FlSpot(5, 6), FlSpot(6, 7),
                            ],
                            isCurved: true,
                            color: Colors.white,
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: const FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Actions Rapides
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildActionBtn(Icons.send, "Virement"),
                  _buildActionBtn(Icons.receipt_long, "Factures"),
                  _buildActionBtn(Icons.credit_card, "Cartes"),
                  _buildActionBtn(Icons.account_balance, "IBAN"),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Transactions récentes
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                "Transactions récentes",
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: slate800),
              ),
            ),
            const SizedBox(height: 16),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  _buildTransaction("Virement Sortant - Fournisseur", "- 450,000", false),
                  _buildTransaction("Paiement Client - Facture", "+ 1,200,000", true),
                  _buildTransaction("Abonnement Logiciel CRM", "- 25,000", false),
                  _buildTransaction("Frais bancaires", "- 5,000", false),
                  _buildTransaction("Dépôt initial", "+ 10,000,000", true),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildActionBtn(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: slate800.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4))
            ],
          ),
          child: Icon(icon, color: emerald600),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 13, color: slate600, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildTransaction(String title, String amount, bool isIncome) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: slate800.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isIncome ? emerald100 : red100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isIncome ? Icons.arrow_downward : Icons.arrow_upward,
              color: isIncome ? emerald600 : red500,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: slate800, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  "Aujourd'hui",
                  style: TextStyle(color: slate500, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            "$amount FCFA",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isIncome ? emerald600 : slate800,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
