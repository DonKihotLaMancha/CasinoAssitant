import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import 'results_screen.dart';

class OddsCalculatorScreen extends StatelessWidget {
  const OddsCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Odds Calculator'),
        elevation: 0,
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.analytics, color: Colors.blue.shade700),
                            const SizedBox(width: 8),
                            const Text(
                              'Monte Carlo Simulation',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Run thousands of blackjack hands to calculate accurate probabilities',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Number of Simulations
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Number of Simulations',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${appState.numSimulations.toStringAsFixed(0)} hands',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Slider(
                          value: appState.numSimulations.toDouble(),
                          min: 1000,
                          max: 100000,
                          divisions: 99,
                          label: appState.numSimulations.toString(),
                          onChanged: (value) {
                            appState.setNumSimulations(value.toInt());
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('1,000', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                            Text('100,000', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Number of Decks
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Number of Decks',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${appState.numDecks} ${appState.numDecks == 1 ? "deck" : "decks"}',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Slider(
                          value: appState.numDecks.toDouble(),
                          min: 1,
                          max: 8,
                          divisions: 7,
                          label: appState.numDecks.toString(),
                          onChanged: (value) {
                            appState.setNumDecks(value.toInt());
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('1 deck', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                            Text('8 decks', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Strategy Selection
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Strategy',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SwitchListTile(
                          title: const Text('Use Basic Strategy'),
                          subtitle: Text(
                            appState.useBasicStrategy
                                ? 'Optimal play based on hand value and dealer upcard'
                                : 'Simple strategy: Hit until 17',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                          ),
                          value: appState.useBasicStrategy,
                          onChanged: (value) {
                            appState.setUseBasicStrategy(value);
                          },
                          activeColor: Colors.green,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Run Button
                ElevatedButton(
                  onPressed: appState.isSimulating
                      ? null
                      : () async {
                          await appState.runSimulation();
                          if (context.mounted && appState.results != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ResultsScreen(),
                              ),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: appState.isSimulating
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Simulating...',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.play_arrow),
                            SizedBox(width: 8),
                            Text(
                              'Run Simulation',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                ),
                const SizedBox(height: 16),
                
                // Info Card
                Card(
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue.shade700),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'More simulations = more accurate results. Recommended: 10,000+',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue.shade900,
                            ),
                          ),
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
