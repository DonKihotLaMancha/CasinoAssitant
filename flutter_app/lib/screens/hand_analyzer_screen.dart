import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import 'hand_results_screen.dart';

class HandAnalyzerScreen extends StatelessWidget {
  const HandAnalyzerScreen({super.key});

  static const List<String> cardValues = [
    'A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hand Analyzer'),
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
                            Icon(Icons.psychology, color: Colors.purple.shade700),
                            const SizedBox(width: 8),
                            const Text(
                              'Analyze Your Hand',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Get optimal play recommendations for any blackjack hand',
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
                
                // Your Cards Section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Your Cards',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // First Card
                        const Text('First Card', style: TextStyle(fontSize: 14)),
                        const SizedBox(height: 8),
                        _CardSelector(
                          selectedCard: appState.playerCard1,
                          onCardSelected: (card) => appState.setPlayerCard1(card),
                        ),
                        const SizedBox(height: 16),
                        
                        // Second Card
                        const Text('Second Card', style: TextStyle(fontSize: 14)),
                        const SizedBox(height: 8),
                        _CardSelector(
                          selectedCard: appState.playerCard2,
                          onCardSelected: (card) => appState.setPlayerCard2(card),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Dealer Card Section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Dealer\'s Upcard',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _CardSelector(
                          selectedCard: appState.dealerUpcard,
                          onCardSelected: (card) => appState.setDealerUpcard(card),
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
                            fontSize: 20,
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
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Analyze Button
                ElevatedButton(
                  onPressed: () {
                    appState.analyzeHand();
                    if (appState.handAnalysis != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HandResultsScreen(),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Analyze Hand',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                // Info Card
                Card(
                  color: Colors.purple.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(Icons.lightbulb_outline, color: Colors.purple.shade700),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'The analyzer will show you the optimal action and expected value for each possible play',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.purple.shade900,
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

class _CardSelector extends StatelessWidget {
  final String selectedCard;
  final Function(String) onCardSelected;

  const _CardSelector({
    required this.selectedCard,
    required this.onCardSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: HandAnalyzerScreen.cardValues.map((card) {
        final isSelected = card == selectedCard;
        return InkWell(
          onTap: () => onCardSelected(card),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 50,
            height: 70,
            decoration: BoxDecoration(
              color: isSelected ? Colors.purple : Colors.white,
              border: Border.all(
                color: isSelected ? Colors.purple : Colors.grey.shade300,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                card,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
