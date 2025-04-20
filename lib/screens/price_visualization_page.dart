import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class VisualizationPage extends StatelessWidget {
  const VisualizationPage({super.key});

  // Sample data generators for different visualizations
  List<FlSpot> getWhaleTransactionData() {
    return List.generate(20, (i) => FlSpot(i.toDouble(), Random().nextDouble() * 800 + 200));
  }

  List<FlSpot> getAnomalyData() {
    return List.generate(20, (i) {
      double val = Random().nextBool() ? Random().nextDouble() * 1000 : 0;
      return FlSpot(i.toDouble(), val);
    });
  }

  List<FlSpot> getGasPriceData() {
    return List.generate(20, (i) => FlSpot(i.toDouble(), Random().nextDouble() * 200));
  }

  List<FlSpot> getPricePredictionData() {
    return List.generate(20, (i) => FlSpot(i.toDouble(), 1600 + Random().nextDouble() * 400));
  }

  // Real-Time Transactions Bar Chart Data (for bar chart visualization)
  List<BarChartGroupData> getRealTimeTransactionData() {
    return List.generate(20, (i) {
      double value = Random().nextDouble() * 1000;
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: value,
            color: value > 500 ? Colors.red : Colors.green, // Color based on value
            width: 12,
            borderRadius: BorderRadius.zero,
          )
        ],
      );
    });
  }

  Widget buildChart(String title, List<FlSpot> data, Color color, String xLabel, String yLabel,
      {bool showDots = false}) {
    double minY = data.map((e) => e.y).reduce(min);
    double maxY = data.map((e) => e.y).reduce(max);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SizedBox(
          height: 220,
          child: LineChart(
            LineChartData(
              clipData: FlClipData.all(), // Prevent overflow
              minY: minY - 50,
              maxY: maxY + 50,
              gridData: FlGridData(show: true),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  axisNameWidget: Text(xLabel),
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 5,
                    getTitlesWidget: (value, _) => Text('${value.toInt()}'),
                  ),
                ),
                leftTitles: AxisTitles(
                  axisNameWidget: Text(yLabel),
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: (maxY / 5).clamp(50, 300),
                    getTitlesWidget: (value, _) => Text('${value.toInt()}'),
                  ),
                ),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: data,
                  isCurved: true,
                  color: color,
                  barWidth: 2,
                  dotData: FlDotData(show: showDots),
                  belowBarData: BarAreaData(
                    show: true,
                    color: color.withOpacity(0.15),
                  ),
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "This graph visualizes $title over time, showcasing the trend and variations.",
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  // Bar chart for real-time transactions (additional chart)
  Widget buildRealTimeTransactionBarChart(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SizedBox(
          height: 220,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceBetween,
              gridData: FlGridData(show: true),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  axisNameWidget: Text('Time'),
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, _) => Text('${value.toInt()}'),
                  ),
                ),
                leftTitles: AxisTitles(
                  axisNameWidget: Text('Transaction Amount'),
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 500,
                    getTitlesWidget: (value, _) => Text('${value.toInt()}'),
                  ),
                ),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              barGroups: getRealTimeTransactionData(),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "This bar chart represents real-time transaction amounts. Transactions are shown over time, with varying heights.",
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final whaleData = getWhaleTransactionData();
    final anomalyData = getAnomalyData();
    final gasPriceData = getGasPriceData();
    final predictionData = getPricePredictionData();

    return Scaffold(
      appBar: AppBar(title: const Text('Visualizations')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildChart('Whale Transactions', whaleData, Colors.blue, 'Time', 'ETH Volume', showDots: true),
            buildChart('Anomalies Detected', anomalyData, Colors.red, 'Time', 'Anomaly Score', showDots: true),
            buildChart('Gas Prices', gasPriceData, Colors.green, 'Time', 'Gwei'),
            buildChart('ETH Price Prediction', predictionData, Colors.orange, 'Time', 'Price (USD)'),
            buildRealTimeTransactionBarChart('Real-Time Transactions Visualization'),
          ],
        ),
      ),
    );
  }
}
