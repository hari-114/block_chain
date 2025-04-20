import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class WhaleTransactionsPage extends StatefulWidget {
  const WhaleTransactionsPage({super.key});

  @override
  _WhaleTransactionsPageState createState() => _WhaleTransactionsPageState();
}

class _WhaleTransactionsPageState extends State<WhaleTransactionsPage> {
  List whaleTransactions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWhaleTransactions();
  }

  Future<void> fetchWhaleTransactions() async {
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
          whaleTransactions = data['result'].take(5).toList();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Whale Transactions')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
              child: ListView.builder(
                itemCount: whaleTransactions.length,
                itemBuilder: (context, index) {
                  final tx = whaleTransactions[index];
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
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Display Gas Price in Gwei
                          Text(
                            'Gas Price: ${tx['gasPrice']} Gwei',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.blue,
                            ),
                          ),
                          // Display Gas Fee in Gwei
                          Text(
                            'Gas Fee: $gasFee Gwei',
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
