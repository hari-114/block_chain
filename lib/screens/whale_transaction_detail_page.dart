import 'package:flutter/material.dart';
import 'ethereum_service.dart';

class WhaleTransactionDetailPage extends StatefulWidget {
  final String transactionHash;

  const WhaleTransactionDetailPage({super.key, required this.transactionHash});

  @override
  State<WhaleTransactionDetailPage> createState() =>
      _WhaleTransactionDetailPageState();
}

class _WhaleTransactionDetailPageState extends State<WhaleTransactionDetailPage> {
  Map<String, dynamic> transactionDetails = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTransactionDetails();
  }

  void _loadTransactionDetails() async {
    final details = await EthereumService.fetchTransactionDetails(widget.transactionHash);
    setState(() {
      transactionDetails = details;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Details'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: transactionDetails.isEmpty
            ? const Center(child: Text('No transaction details available'))
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Transaction Hash: ${widget.transactionHash}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('From: ${transactionDetails['from']}'),
            Text('To: ${transactionDetails['to']}'),
            Text('Value: ${transactionDetails['value']} ETH'),
            Text('Block Number: ${transactionDetails['blockNumber']}'),
            Text('Timestamp: ${transactionDetails['timeStamp']}'),
            // Add other transaction details here as needed
          ],
        ),
      ),
    );
  }
}
