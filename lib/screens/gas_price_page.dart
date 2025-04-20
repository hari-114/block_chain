import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class GasPricePage extends StatefulWidget {
  const GasPricePage({super.key});

  @override
  _GasPricePageState createState() => _GasPricePageState();
}

class _GasPricePageState extends State<GasPricePage> {
  bool isLoading = true;
  List<FlSpot> gasPriceData = [];
  List<Map<String, dynamic>> gasPricesList = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    fetchGasPrices();
    _startSimulatingData();
  }

  // Fetch gas prices from the Etherscan API
  Future<void> fetchGasPrices() async {
    const apiUrl = 'https://api.etherscan.io/api';  // Base API URL
    const apiKey = '2RFVJTBC6TWD82GEIK6IKATYQIBQDNWZIR';  // Replace with your Etherscan API key

    try {
      final response = await http.get(
        Uri.parse('$apiUrl?module=gastracker&action=gasoracle&apikey=$apiKey'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == '1') {
          final gasPrice = data['result'];
          setState(() {
            isLoading = false;
            gasPricesList.add({
              'time': DateTime.now().toString(),
              'safeGasPrice': double.parse(gasPrice['SafeGasPrice'].toString()),
            });

            gasPriceData.add(
              FlSpot(
                gasPriceData.length.toDouble(),
                double.parse(gasPrice['SafeGasPrice'].toString()),
              ),
            );
          });
        } else {
          setState(() {
            isLoading = false;
          });
          throw Exception("Failed to fetch gas price");
        }
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception("Failed to load gas prices");
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching gas prices: $error');
    }
  }

  // Simulate real-time data by fetching new gas prices every 5 seconds
  void _startSimulatingData() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      fetchGasPrices();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Line chart for gas price visualization
  Widget buildLineChart(List<FlSpot> data) {
    return LineChart(
      LineChartData(
        minY: 0, // Min value set to 0 to start the y-axis from zero
        maxY: 2, // Set the max value of y-axis to 2.0 Gwei for a more detailed view
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            axisNameWidget: Text('Time'),
            sideTitles: SideTitles(showTitles: true),
          ),
          leftTitles: AxisTitles(
            axisNameWidget: Text('Gas Price (Gwei)'),
            sideTitles: SideTitles(
              showTitles: true,
              interval: 0.5,  // Set the interval to 0.5 to show more detailed scale
              getTitlesWidget: (value, _) => Text('${value.toStringAsFixed(1)}'), // Format to show 1 decimal point
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: data,
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.2)),
          ),
        ],
      ),
    );
  }

  // List view of gas prices
  Widget buildGasPricesList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: gasPricesList.length,
      itemBuilder: (context, index) {
        final gasPrice = gasPricesList[index];
        return ListTile(
          title: Text('Time: ${gasPrice['time']}'),
          subtitle: Text('Gas Price: ${gasPrice['safeGasPrice']} Gwei'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gas Price Visualization')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Real-Time Gas Prices',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              // Line chart
              Container(
                width: double.infinity,
                height: 300,
                child: buildLineChart(gasPriceData),
              ),
              const SizedBox(height: 16),
              const Text(
                'Line chart showing gas prices over time.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              // Gas prices list
              const Text(
                'Gas Price List:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                height: 200, // Adjust the height as necessary
                child: buildGasPricesList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
