import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'whale_transactions_page.dart';
import 'anomaly_detection_page.dart';
import 'gas_price_page.dart';
import 'price_visualization_page.dart';
import 'profile_page.dart';
import 'login_page.dart';// Import ProfilePage

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List recentTransactions = [];
  bool isLoading = true;
  Timer? refreshTimer;

  @override
  void initState() {
    super.initState();
    fetchRecentTransactions();
    refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      fetchRecentTransactions();
    });
  }

  @override
  void dispose() {
    refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> fetchRecentTransactions() async {
    setState(() => isLoading = true);

    const apiKey = '2RFVJTBC6TWD82GEIK6IKATYQIBQDNWZIR'; // 🔑 Replace this
    const address = '0xde0B295669a9FD93d5F28D9Ec85E40f4cb697BAe'; // Example address

    final url = Uri.parse(
        'https://api.etherscan.io/api?module=account&action=txlist&address=$address&startblock=0&endblock=99999999&sort=desc&apikey=$apiKey');

    try {
      final response = await http.get(url);
      final data = jsonDecode(response.body);
      print('API Response: $data'); // Debugging: Print the raw response
      if (data['status'] == '1') {
        setState(() {
          recentTransactions = data['result'].take(5).toList();
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        print('Error fetching: ${data['message']}');
      }
    } catch (e) {
      setState(() => isLoading = false);
      print('Failed to fetch transactions: $e');
    }
  }

  // Convert Wei to Gas Fee (in Gwei)
  String formatGasFee(String gasUsed, String gasPrice) {
    final gasUsedInt = BigInt.tryParse(gasUsed) ?? BigInt.zero;
    final gasPriceInt = BigInt.tryParse(gasPrice) ?? BigInt.zero;
    final gasFeeInWei = gasUsedInt * gasPriceInt;
    final gasFeeInGwei = gasFeeInWei / BigInt.from(1e9); // Convert to Gwei
    return gasFeeInGwei.toStringAsFixed(6); // Format to 6 decimal places
  }

  // Logout and navigate to Login Page
  void logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false, // Remove all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blockchain Analytics'),
        automaticallyImplyLeading: false, // Remove the back button
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,  // Logout functionality
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),  // Profile button
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _DashboardCard(
                    title: 'Whale Transactions',
                    icon: Icons.search,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const WhaleTransactionsPage()),
                    ),
                  ),
                  _DashboardCard(
                    title: 'Anomaly Detection',
                    icon: Icons.warning,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AnomalyDetectionPage()),
                    ),
                  ),
                  _DashboardCard(
                    title: 'Gas Prices',
                    icon: Icons.local_gas_station,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const GasPricePage()),
                    ),
                  ),
                  _DashboardCard(
                    title: 'Visualizations',
                    icon: Icons.show_chart,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const VisualizationPage()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Recent Transactions (Auto-updates)',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: 8),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                children: recentTransactions.map((tx) {
                  final gasFee = formatGasFee(tx['gasUsed'], tx['gasPrice']);
                  return Card(
                    elevation: 2,
                    child: ListTile(
                      title: Text(
                        'From: ${tx['from'].toString().substring(0, 10)}...',
                        style: const TextStyle(fontSize: 14),
                      ),
                      subtitle: Text(
                        'To: ${tx['to'].toString().substring(0, 10)}...',
                        style: const TextStyle(fontSize: 14),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Removed ETH value display
                          Text(
                            'Gas: $gasFee Gwei',
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40, color: Colors.deepPurple),
              const SizedBox(height: 12),
              Text(title, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
