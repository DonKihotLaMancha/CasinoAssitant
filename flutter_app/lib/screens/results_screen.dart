import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/app_state.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simulation Results'),
        elevation: 0,
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          final results = appState.results;
          if (results == null) {
            return const Center(child: Text('No results available'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Summary Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Simulation Summary',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _InfoRow('Total Hands', '${results.totalGames}'),
                        _InfoRow('Number of Decks', '${appState.numDecks}'),
                        _InfoRow(
                          'Strategy',
                          appState.useBasicStrategy ? 'Basic Strategy' : 'Simple Strategy',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Win/Loss Pie Chart
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Win/Loss Distribution',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 200,
                          child: PieChart(
                            PieChartData(
                              sections: [
                                PieChartSectionData(
                                  value: results.playerWinRate,
                                  title: '${results.playerWinRate.toStringAsFixed(1)}%',
                                  color: Colors.green,
                                  radius: 80,
                                  titleStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                PieChartSectionData(
                                  value: results.dealerWinRate,
                                  title: '${results.dealerWinRate.toStringAsFixed(1)}%',
                                  color: Colors.red,
                                  radius: 80,
                                  titleStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                PieChartSectionData(
                                  value: results.pushRate,
                                  title: '${results.pushRate.toStringAsFixed(1)}%',
                                  color: Colors.grey,
                                  radius: 80,
                                  titleStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                              sectionsSpace: 2,
                              centerSpaceRadius: 40,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _LegendItem('Player Wins', Colors.green),
                            _LegendItem('Dealer Wins', Colors.red),
                            _LegendItem('Pushes', Colors.grey),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Detailed Statistics
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Detailed Statistics',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _StatRow(
                          'Player Win Rate',
                          '${results.playerWinRate.toStringAsFixed(2)}%',
                          Colors.green,
                        ),
                        _StatRow(
                          'Dealer Win Rate',
                          '${results.dealerWinRate.toStringAsFixed(2)}%',
                          Colors.red,
                        ),
                        _StatRow(
                          'Push Rate',
                          '${results.pushRate.toStringAsFixed(2)}%',
                          Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Financial Analysis
                Card(
                  color: results.expectedReturn < 0 ? Colors.red.shade50 : Colors.green.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.attach_money,
                              color: results.expectedReturn < 0 ? Colors.red : Colors.green,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Financial Analysis',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _InfoRow(
                          'Expected Return',
                          '${results.expectedReturn >= 0 ? '+' : ''}${results.expectedReturn.toStringAsFixed(3)}%',
                        ),
                        _InfoRow(
                          'House Edge',
                          '${results.expectedReturn >= 0 ? '-' : '+'}${(-results.expectedReturn).toStringAsFixed(3)}%',
                        ),
                        _InfoRow(
                          'Per \$100 bet',
                          '\$${(100 + results.expectedReturn).toStringAsFixed(2)}',
                        ),
                        _InfoRow(
                          'Per \$1000 bet',
                          '\$${(1000 + results.expectedReturn * 10).toStringAsFixed(2)}',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Key Insights
                Card(
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.lightbulb, color: Colors.blue.shade700),
                            const SizedBox(width: 8),
                            const Text(
                              'Key Insights',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _InsightText(
                          results.expectedReturn < 0
                              ? 'The house has an edge of ${(-results.expectedReturn).toStringAsFixed(3)}%'
                              : 'You have an edge of ${results.expectedReturn.toStringAsFixed(3)}%',
                        ),
                        _InsightText(
                          'Over 1000 hands at \$10/hand, expected ${results.expectedReturn < 0 ? 'loss' : 'gain'}: \$${((results.expectedReturn / 100) * 10000).abs().toStringAsFixed(2)}',
                        ),
                        if (appState.useBasicStrategy)
                          _InsightText(
                            'Using basic strategy - optimal play reduces house edge to minimum',
                          )
                        else
                          _InsightText(
                            'Consider using basic strategy to improve your odds by ~3-4%',
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatRow(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final String label;
  final Color color;

  const _LegendItem(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}

class _InsightText extends StatelessWidget {
  final String text;

  const _InsightText(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 14)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
