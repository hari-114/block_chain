import 'dart:convert';
import 'package:http/http.dart' as http;

class EthereumService {
  static const String etherscanApiUrl = 'https://api.etherscan.io/api';
  static const String apiKey = '2RFVJTBC6TWD82GEIK6IKATYQIBQDNWZIR';

  // Fetch Whale Transactions
  static Future<List<Map<String, dynamic>>> fetchWhaleTransactions() async {
    final response = await http.get(
      Uri.parse('$etherscanApiUrl?module=account&action=txlist&address=0xYourEthereumAddress&startblock=0&endblock=99999999&sort=desc&apikey=$apiKey'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == '1') {
        List transactions = data['result'];
        return transactions
            .where((tx) => double.tryParse(tx['value']) != null)
            .map<Map<String, dynamic>>((tx) => {
          'hash': tx['hash'],
          'from': tx['from'],
          'to': tx['to'],
          'value': tx['value'],
          'timeStamp': tx['timeStamp'],
        })
            .toList();
      }
    }
    return [];
  }

  // Fetch Transaction Details by Hash
  static Future<Map<String, dynamic>> fetchTransactionDetails(String hash) async {
    final response = await http.get(
      Uri.parse('$etherscanApiUrl?module=transaction&action=gettxinfo&txhash=$hash&apikey=$apiKey'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == '1') {
        return data['result'];
      }
    }
    return {};
  }
}
