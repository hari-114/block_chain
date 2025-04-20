import 'dart:convert';
import 'package:http/http.dart' as http;

class WhaleTransactionService {
  final String apiKey = '2RFVJTBC6TWD82GEIK6IKATYQIBQDNWZIR'; // Replace with your API key
  final String baseUrl = 'https://api.etherscan.io/api';

  // Function to fetch whale transactions
  Future<List<Map<String, dynamic>>> fetchWhaleTransactions() async {
    final response = await http.get(Uri.parse(
      '$baseUrl?module=account&action=txlist&address=0xAddressHere&startblock=0&endblock=99999999&sort=desc&apikey=$apiKey',
    ));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == '1') {
        // Parse the transactions
        List transactions = data['result'];
        return transactions.map<Map<String, dynamic>>((tx) {
          return {
            'transaction_id': tx['hash'],
            'amount': tx['value'],
            'timestamp': tx['timeStamp'],
            'from': tx['from'],
            'to': tx['to'],
          };
        }).toList();
      } else {
        throw Exception('Failed to load transactions');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }
}
