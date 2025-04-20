import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AnomalyDetectionPage extends StatefulWidget {
  const AnomalyDetectionPage({Key? key}) : super(key: key);

  @override
  State<AnomalyDetectionPage> createState() => _AnomalyDetectionPageState();
}

class _AnomalyDetectionPageState extends State<AnomalyDetectionPage> {
  final TextEditingController _addressController = TextEditingController();
  List<Map<String, dynamic>> transactions = [];
  List<Map<String, dynamic>> anomalies = [];
  bool isLoading = false;
  final String apiKey = '2RFVJTBC6TWD82GEIK6IKATYQIBQDNWZIR';

  Future<void> fetchTransactions(String address) async {
    setState(() {
      isLoading = true;
      transactions.clear();
      anomalies.clear();
    });

    final url =
        'https://api.etherscan.io/api?module=account&action=txlist&address=$address&startblock=0&endblock=99999999&sort=desc&apikey=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);

      if (data['status'] == '1') {
        List txs = data['result'];

        List<Map<String, dynamic>> parsedTxs = txs.map<Map<String, dynamic>>((tx) {
          final BigInt weiValue = BigInt.parse(tx['value']);
          final double ethValue = weiValue / BigInt.from(10).pow(18); // Convert to ETH
          return {
            'hash': tx['hash'],
            'time': DateTime.fromMillisecondsSinceEpoch(int.parse(tx['timeStamp']) * 1000),
            'eth': ethValue,
            'gasPrice': tx['gasPrice'],
          };
        }).toList();

        // Mark 10% as anomalies randomly
        parsedTxs.shuffle();
        int anomalyCount = (parsedTxs.length * 0.1).floor();
        List<Map<String, dynamic>> anomalySubset = parsedTxs.take(anomalyCount).toList();

        setState(() {
          transactions = parsedTxs;
          anomalies = anomalySubset;
          isLoading = false;
        });
      } else {
        throw Exception("API Error: ${data['message']}");
      }
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildTransactionList(List<Map<String, dynamic>> data, {bool isAnomaly = false}) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final tx = data[index];
        return Card(
          color: isAnomaly ? Colors.red.shade100 : Colors.white,
          child: ListTile(
            title: Text('Value: ${tx['eth'].toStringAsFixed(6)} ETH'),
            subtitle: Text('Time: ${tx['time']}\nHash: ${tx['hash']}'),
            trailing: isAnomaly ? const Icon(Icons.warning, color: Colors.red) : null,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Anomaly Detection')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                hintText: 'Enter Ethereum wallet address',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    final address = _addressController.text.trim();
                    if (address.isNotEmpty) {
                      fetchTransactions(address);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            isLoading
                ? const Expanded(child: Center(child: CircularProgressIndicator()))
                : Expanded(
              child: transactions.isEmpty
                  ? const Center(child: Text('No transactions loaded.'))
                  : Column(
                children: [
                  const Text('Detected Anomalies (10%)',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Expanded(child: _buildTransactionList(anomalies, isAnomaly: true)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
